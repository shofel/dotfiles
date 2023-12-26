function new-branch --description 'Set up new branch: 1.create 2.push 3.MergeRequest' --argument issue topic
  if test -z "$issue" -o -z "$topic"
    # Rebase on a fresh main branch.
    echo >&2 'Usage:   new-branch issue topic'
    echo >&2 'Example: new-branch acme-112 make-a-good-thing'
    return
  end

  set -l date (date +%Y-%m-%d)

  set -l branch (string join '-' $issue $topic $date)

  git switch -c $branch

  # Rebase on a fresh main branch.
  git fetch origin master ;or git fetch origin main
  git rebase origin/master ;or git rebase origin/main

  git push -u origin $branch 2>&1 \
    -o ci.skip -o merge_request.create \
    -o merge_request.draft \
    -o merge_request.title="$issue $topic"
end
