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

	set -l color_cwd
	set -l prefix
	switch $USER
	case root toor
		if set -q fish_color_cwd_root
			set color_cwd $fish_color_cwd_root
		else
			set color_cwd $fish_color_cwd
		end
		set suffix '#'
	case '*'
		set color_cwd $fish_color_cwd
		set suffix '❯'
	end

	# Indicate failed commands.
	set -l color_status $fish_color_cwd
	if test $last_status -ne 0
		set color_status $fish_color_error
	end

	#
	# Print
	#

	# PWD
	set_color $color_cwd
	echo -n (prompt_pwd)
	set_color normal

	# Git
	__fish_git_prompt ' %s '

	# Suffix
	set_color $color_status
	echo -n "$suffix "

	set_color normal
end
