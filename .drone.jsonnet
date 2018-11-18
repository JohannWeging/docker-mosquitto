local step(arch, tag) = {
  name: 'version ' + tag,
  image: 'plugins/docker',
  settings: {
    repo: 'johannweging/mosquitto',
    tags: tag,
    dockerfile: 'Dockerfile',
    build_args: [
      'ALPINE_VERSION=' + tag,
      'GOARCH=' + arch,
      'GOARM=6',
    ],
    username: { from_secret: 'docker_username' },
    password: { from_secret: 'docker_password' },
  },
};

local pipeline(name, arch, tag) = {
  kind: 'pipeline',
  name: name,
  steps: [
    step(arch, tag),
  ],
  trigger: {
    branch: ['master'],
  },
};

local secret = {
  kind: 'secret',
  external_data: {
    docker_username: {
      path: 'secret/deployment/docker',
      name: 'username',
    },
    docker_password: {
      path: 'secret/deployment/docker',
      name: 'password',
    },
  },
};

[
  pipeline('build amd64', 'amd64', 'latest'),
  pipeline('build arm32v6', 'arm', 'latest-arm32v6'),
  secret,
]
