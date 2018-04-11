# vim: ts=2 sts=2 noet :
#
# SEE for details: https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
function fish_prompt --description 'Write out the prompt'

	# TODO check if the vars are already declared
	# @see https://github.com/fish-shell/fish-shell/blob/627ce4ea34f180745003f50c540a17cbfc5a22ba/share/tools/web_config/sample_prompts/classic_vcs.fish#L37

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

		# Print
		echo -ns (set_color $color) $error_code '❯ '
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
