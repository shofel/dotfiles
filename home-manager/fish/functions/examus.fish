# Defined in - @ line 2
function examus --wraps=docker-compose
	docker-compose -f ~/workspaces/Examus/proctoring-project/docker-compose.yml $argv
end
