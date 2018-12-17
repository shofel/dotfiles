# Defined in - @ line 2
function x
	cp ~/workspaces/dotfiles/.xinitrc-$argv[1] .xinitrc
    startx
end
