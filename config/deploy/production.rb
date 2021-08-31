server '35.73.158.104', user: 'ec2-user', roles: %w{app db web}

set :ssh_options, {
  # keys: [ENV.fetch('PRODUCTION_SSH_KEY').to_s],
  keys: ['~/.ssh/id_rsa_f472fddc3fa078e857db2595610c1400'],
  forward_agent: true,
  auth_methods: %w[publickey]
}