# Defined in - @ line 2
function gBFG
	# preserve current branch
    set current_branch (git branch | grep '^*' | awk '{ print $2 }')


    ##
    # Update.
    ##

    git checkout master
    git fetch --all --prune

    ##
    #
    ##

    # merged: both local and remote branches
    echo === merged branches ===

    set branches (git branch -vv --merged | grep -v master | awk '{ print $1 }')

    for x in $branches
        git branch -D $x # locals
        git push --delete origin $x # remotes
    end


    # Branches without origin.
    echo === branches without origin ===

    set branches (git branch -vv | grep -v '\[origin/' | awk '{ print $1 }')

    for x in $branches
        git branch -D $x
    end

    # local with gone remote.
    echo === branches with gone remote ===

    for x in (git branch -vv | grep ': gone]' | awk '{print $1}')
        git branch -D $x
    end


    # restore current branch

    git checkout current_branch
end
