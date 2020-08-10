# To set up user defined PATH elements
# use universal variable $fish_user_path
# see https://fishshell.com/docs/current/tutorial.html#tut_path
source ~/opt/asdf/asdf.fish

# SSH agent.

# Assure an agent is running.
if test -z (pgrep ssh-agent); ssh-agent -t 1h; end

# Connect to the agent, mimicking output of `ssh-agent`.
# -U means universally; -x means export
set -Ux SSH_AGENT_PID (pgrep ssh-agent)
set -Ux SSH_AUTH_SOCK /tmp/ssh-*/agent.(math $SSH_AGENT_PID - 1)
