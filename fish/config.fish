# @see https://github.com/akoenig/gulp.plugin.zsh/blob/master/gulp.plugin.zsh
set PATH ~/.local/bin/ $PATH

function gulptasks
        set -l gulpfiles (find . -maxdepth 1 -name 'gulpfile.*')

        if test (count $gulpfiles) -gt 0
          grep -Eho "gulp\.task[^,]*" $gulpfiles ^ /dev/null \
          | sed s/\"/\'/g \
          | cut -d "'" -f 2 \
          | sort
        end
end

complete --command gulp --arguments "(gulptasks)" --no-files
