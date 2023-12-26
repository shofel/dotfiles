function force-tag -a x
    git tag -f $x
    git push -f origin $x
end
