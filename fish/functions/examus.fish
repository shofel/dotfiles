# Defined in - @ line 2
function examus
	pushd ~/workspaces/Examus/proctoring-project/
    docker-compose $argv
    popd
end
