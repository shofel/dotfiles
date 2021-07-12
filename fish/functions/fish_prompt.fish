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

	set -g __fish_prompt_normal (set_color normal)

	set -l last_status $status

	function status_ -S --description "Indicate status code of the last command."
		if test $last_status -ne 0
			set_color $fish_color_error
			echo -n $last_status
		end
	end

	function suffix --description "Prompt trailer."
		set_color $fish_color_cwd
		echo -n '➤ '
	end

	function vim_marker
		if test -n "$VIM"; echo -n 'vim'; end
	end

	function nix_shell_marker
		if test -n "$IN_NIX_SHELL"; echo -n 'nix'; end
	end

	function markers
		set -l markers (vim_marker) (nix_shell_marker)
		if test (count $markers) -gt 0
			echo -n (set_color $fish_color_param)'['(string join ' ' $markers)'] '
		end
	end

	function _pwd
		set_color $fish_color_cwd
		echo -n (prompt_pwd) ''
	end

	#
	# Print
	#

	markers
	_pwd
	__fish_git_prompt ' %s '
	status_
	suffix

	set_color normal
end
