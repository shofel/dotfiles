# Defined in - @ line 2
function grbm
	git fetch --all --prune
    and git pull --rebase
    and git rebase origin/master $argv
    and git push --force-with-lease
end
