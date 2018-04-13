# vim: ts=2 sts=2 noet :
#
# SEE
# __fish_git_prompt sources
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#
# SEE
# nice command composition
# https://github.com/oh-my-fish/theme-mars/blob/master/fish_prompt.fish
#
# TODO current time: pale and at the right side
# SEE https://github.com/oh-my-fish/theme-trout
#
# TODO command execution duration when
#
function fish_prompt --description 'Write out the prompt'

	# TODO check if the vars are already declared
	# @see https://github.com/fish-shell/fish-shell/blob/master/share/tools/web_config/sample_prompts/classic_vcs.fish#L37

	set -g __fish_git_prompt_show_informative_status 1
	set -g __fish_git_prompt_hide_untrackedfiles 1
	set -g __fish_git_prompt_color_branch magenta --bold

	set -g __fish_git_prompt_showupstream "informative"

	set -g __fish_git_prompt_color_dirtystate blue
	set -g __fish_git_prompt_color_stagedstate yellow
	set -g __fish_git_prompt_color_invalidstate red
	set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
	set -g __fish_git_prompt_color_cleanstate green --bold

	set -g __fish_git_prompt_char_stateseparator ' '

	set -l last_status $status

	set -g __fish_prompt_normal (set_color normal)

	function suffix -S --description "Prompt trailer. + Indicates status."
		# Color: error or clean.
		set -l color
		if test $last_status -eq 0
			set color $fish_color_cwd
		else
			set color $fish_color_error
		end

		# Error code. Empty if status is 0.
		set -l error_code
		if test $last_status -ne 0
			set error_code $last_status
		end

		set -l suffix_list  ↳ ⯈ ⇶ ⮞ ⮕ ⮩ ⮚ ⮞

		# Increment or initialize the suffix number.
		set -qg __prompt_suffix_number
		or set -g __prompt_suffix_number 0

		# Inc suffix index
		set __prompt_suffix_number (math $__prompt_suffix_number + 1)

		# Modulo
		set __prompt_suffix_number (\
			math 1 + $__prompt_suffix_number '%' (count $suffix_list -1))

		set -l suffix_symbol $suffix_list[$__prompt_suffix_number]

		# Print
		echo -ns (set_color $color) $error_code $suffix_symbol ' '
	end


	#
	# Print
	#

	# PWD
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal

	# Git
	__fish_git_prompt '  %s '

	# Suffix
	suffix

	set_color normal
end
