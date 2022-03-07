**WP task**

1. Prerequisites for local machine
- ssh public key is generated
- ssh-agent is started and key is added
- aws cli is installed and configured for your account
- terraform is installed

2. Launching project
- clone repo
- cd to terraform dir and run `terraform init`
- run setup.sh with apply argument, e.g.:
`DB_USER=username DB_SECRET=very_secet_secret ./setup.sh apply`
setup.sh passes these envs and command (e.g. apply) to the terraform. You can ommit declaring them but 
be ready to manually input data on terraform prompt.
Also setup.sh assumes that your public key is stored at `$HOME/.ssh/id_rsa.pub`
if it is not then set `PUB_KEY` env with correct path.

3. Destroying project
- run setup.sh with destroy argument, e.g.:
`DB_USER=username DB_SECRET=very_secet_secret ./setup.sh destroy`
beacuse of the way terraform works you should pass envs used with apply command
