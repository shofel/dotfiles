# Defined in - @ line 1
function dev
	git fetch --all
    git pull
    docker-compose pull
    docker-compose up -d
end
