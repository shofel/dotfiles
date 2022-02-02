# Defined in /run/user/1000/fish.sETpPI/new-branch.fish @ line 2
function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument topic issue
  if test -z $topic
    echo >&2 Usage: new-branch topic [issue]
    return
  end

  if test -z $issue
    set -l issue x-0
  end

  set -l date (date +%Y-%m-%d)

  set -l branch (string join '-' $issue $topic $date)

  git switch -c $branch

  git push -o ci.skip -u origin $branch 2>&1 |
    grep merge_requests/new |
    awk '{print $2}' |
    xargs xdg-open
end
