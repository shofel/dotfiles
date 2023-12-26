# Defined in - @ line 2
function brightness
	echo $argv | sudo tee /sys/class/backlight/*/brightness
end
