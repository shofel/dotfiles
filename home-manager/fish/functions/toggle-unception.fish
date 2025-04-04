function toggle-unception

  # give them nice short names
  set --function saved $NVIM_UNCEPTION_PIPE_PATH_HOST__SAVED
  set --function active $NVIM_UNCEPTION_PIPE_PATH_HOST

  # exactly one of them must be empty
  if test -z "$saved"; and test -z "$active"
    echo ERROR: both saved and active unception pipe paths are empty
    return 2
  end

  # swap and rename back
  set -g NVIM_UNCEPTION_PIPE_PATH_HOST__SAVED $active
  set -g NVIM_UNCEPTION_PIPE_PATH_HOST $saved

  if test -z "$NVIM_UNCEPTION_PIPE_PATH_HOST"
    set -ge NVIM_UNCEPTION_PIPE_PATH_HOST
    echo unception is disabled
  else
    echo unception is enabled
  end
end
