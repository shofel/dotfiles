# Defined in /run/user/1000/fish.mXJ7dj/new-branch.fish @ line 2
function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument branch
  git switch -c $branch
  git push -u origin $branch 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs xdg-open
end
