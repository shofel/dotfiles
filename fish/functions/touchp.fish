# Defined in - @ line 2
function touchp
	for x in $argv
        mkdir -p (dirname $x)
        touch $x
    end
end
