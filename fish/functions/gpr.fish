function gpr
	set branch (git branch ^/dev/null | grep '^*' | cut -d' ' -f2)
    open "https://github.com/examus/ChromeApp/compare/$branch?expand=1"
end
