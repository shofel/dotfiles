function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument issue topic
  if test -z $issue -o -z $topic
    echo >&2 'Usage:   new-branch issue topic'
    echo >&2 'Example: new-branch acme-112 make-a-good-thing'
    return
  end

  set -l date (date +%Y-%m-%d)

  set -l branch (string join '-' $issue $topic $date)

  git switch -c $branch

  git push -o ci.skip -u origin $branch 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs open
end
