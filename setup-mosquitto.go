package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	err := writeConfig()
	if err != nil {
		fmt.Printf("ERROR: %s\n", err)
		os.Exit(1)
	}
}

func run() error {
	if err := writeConfig(); err != nil {
		return err
	}
	return users()
}

func writeConfig() error {
	confFilePath := os.Getenv("CONFIG_FILE")
	conf, err := os.Create(confFilePath)
	if err != nil {
		return fmt.Errorf("failed to create %s: %s\n", confFilePath, err)
	}

	for _, env := range os.Environ() {
		if !strings.HasPrefix(env, "MQ_") {
			continue
		}

		entry := strings.TrimPrefix(env, "MQ_")
		parts := strings.Split(entry, "=")
		if len(parts) == 0 {
			continue
		}

		key := strings.ToLower(parts[0])

		if len(parts) > 1 {
			_, err = fmt.Fprintf(conf, "%s %s\n", key, strings.Join(parts[1:], "="))
		} else {
			_, err = fmt.Fprintf(conf, "%s\n", key)
		}

		if err != nil {
			return fmt.Errorf("failed to write to %s: %s\n", confFilePath, err)
		}
	}
	return nil
}

func users() error {
	pwFilePath := os.Getenv("MQ_PASSWORD_FILE")
	_, err := os.OpenFile(pwFilePath, os.O_RDWR|os.O_CREATE, 0640)
	if err != nil {
		return fmt.Errorf("failed to create password file: %s", err)
	}
	for _, env := range os.Environ() {
		if !strings.HasPrefix(env, "USER_NAME_") {
			continue
		}

		parts := strings.Split(env, "=")
		if len(parts) < 2 || parts[1] == "" {
			return fmt.Errorf("no user name supplied for %s", env)
		}
		name := strings.Join(parts[1:], "=")

		nr := strings.TrimPrefix(env, "USER_NAME_")
		passwordEnvKey := "USER_PASSWORD_" + nr
		password := os.Getenv(passwordEnvKey)
		if password == "" {
			return fmt.Errorf("no password provided for user %s", name)
		}

		out, err := exec.Command("mosquitto_passwd", "-b", pwFilePath, name, password).CombinedOutput()
		if err != nil {
			return fmt.Errorf("failed to create user: %s: %s", out, err)
		}
	}
	return nil
}
