# Defined in - @ line 2
function examus-up
	pushd workspaces/Examus/proctoring-project/
    sudo docker-compose up -d
    popd
end
