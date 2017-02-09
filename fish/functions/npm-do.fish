function npm-do
	set -lx PATH (npm bin) $PATH
    eval $argv
end
