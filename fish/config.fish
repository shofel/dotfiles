# To set up user defined PATH elements
# use universal variable $fish_user_path
# see https://fishshell.com/docs/current/tutorial.html#tut_path
source ~/opt/asdf/asdf.fish

# Batcat theme
set -x BAT_THEME Monokai Extended Light

# SSH agent.
#

# Sometimes global vars are annoyingly set by someone.
set -ge SSH_AUTH_SOCK
set -ge SSH_AGENT_PID

# Check if ssh-agent is up and connected.
ssh-add -L 2>&1 >/dev/null

if test $status -eq 2
  set out (ssh-agent -t 1h -c | awk '{gsub(";", ""); print $3}')

  # Connect to the agent, mimicking output of `ssh-agent`.
  # -U means universally. That is connect all fish instances.
  set -Ux SSH_AUTH_SOCK $out[1]
  set -Ux SSH_AGENT_PID $out[2]

  echo got new ssh-agent: pid=\|$SSH_AUTH_SOCK\| sock=\|$SSH_AGENT_PID\|
end
