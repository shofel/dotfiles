function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument branch
  set -l date (date +%Y-%m-%-d)
  git switch -c $branch-$date
  git push -u origin $branch-$date 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs xdg-open
end
