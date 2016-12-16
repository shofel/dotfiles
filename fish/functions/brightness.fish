function brightness
	echo $argv | sudo tee /sys/class/backlight/radeon_bl0/brightness
end
