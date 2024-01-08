# Defined in - @ line 2
function touchp
	for x in $argv
        mkdir -p (dirname $x)
        touch $x
        type -q git ;and git add $x
    end
end
