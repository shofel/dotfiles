function glog
	git log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"
end
