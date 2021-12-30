function new-branch \
   --description 'Set up new branch: 1.create 2.push 3.MergeRequest' \
   --argument-names topic issue
  set -l date (date +%Y-%m-%d)

  if test -z $issue
    set -l issue x-0
  end

  set -l branch $issue-$topic-$date

  git switch -c $branch

  git push -o ci.skip -u origin $branch 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs xdg-open
end
