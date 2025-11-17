# ~/.dotfiles/zsh/aliases.zsh
#
# Este arquivo contém todos os aliases de shell.

alias checksh="shellcheck"
alias ll="ls -lah"
alias cursor="cursor"
alias code="cursor"
alias edit="cursor"
alias c="cursor"
alias cn="cursor_new"
alias co="cursor_open"
alias ca="cursor_agent"
alias reload="reload_dotfiles"
alias status="check_dotfiles_status"
alias setup="setup_dotfiles"
alias opauth='op_auto_auth'
alias opinject='op_inject_env'
alias opinject-local='op_inject_env local'
alias opinject-prod='op_inject_env prod'
alias oplist='op vault list'
alias opsearch='op item list'
alias opget='op item get'
alias opcreate='op item create'
alias opedit='op item edit'
alias opdelete='op item delete'
alias opvaults='op vault list --format table'
alias opitems='op item list --format table'
alias opvault='op vault'
alias opmacos='op vault list --format json | jq -r ".[] | select(.name | contains(\"macos\")) | .name"'
alias opvps='op vault list --format json | jq -r ".[] | select(.name | contains(\"vps\")) | .name"'
alias opsenamfo='op vault list --format json | jq -r ".[] | select(.name | contains(\"senamfo\")) | .name"'
alias opframework='op_framework_auth'
alias opstart='cd $HOME/cursor-automation-framework && make start'
alias opstop='cd $HOME/cursor-automation-framework && make stop'
alias opstatus='cd $HOME/cursor-automation-framework && make status'
alias ophealth='cd $HOME/cursor-automation-framework && make health'
alias opcollect='op_collect_vault'
alias opdeploy-local='cd ~/infra/stack-local && op_inject_env local && docker compose up -d'
alias opdeploy-prod='cd ~/infra/stack-local && ./scripts/deploy-prod.sh'
