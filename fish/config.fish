# To set up user defined PATH elements
# use universal variable $fish_user_path
# see https://fishshell.com/docs/current/tutorial.html#tut_path
source ~/opt/asdf/asdf.fish

# SSH agent.

set -eg SSH_AGENT_PID
set -eg SSH_AUTH_SOCK

if ssh-add -L 2>&1 | string match -r '^Error ' > /dev/null
  set out (ssh-agent -t 1h -c | awk '{gsub(";", ""); print $3}')

  # Connect to the agent, mimicking output of `ssh-agent`.
  # -U means universally. That is connect all fish instances.
  set -U SSH_AUTH_SOCK $out[1]
  set -U SSH_AGENT_PID $out[2]

  echo got new ssh-agent: pid=\|$SSH_AUTH_SOCK\| sock=\|$SSH_AGENT_PID\|
end
