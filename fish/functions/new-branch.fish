function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument branch
  set -l date (date +%Y-%m-%d)
  set -l branch_name x-0-$branch-$date

  echo TODO: make an empty `noci` commit to avoid useless pipeline
  echo TODO: '? start from fresh master ?'

  git switch -c $branch_name

  git push -u origin $branch_name 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs xdg-open
end
