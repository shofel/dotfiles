# Defined in - @ line 2
function examus-create-session
	examus exec web bash -c 'echo \
  "Session.objects.create(\
    exam=Exam.objects.first(),\
    user=User.objects.get(email__startswith=\"student\"))" \
| python3 manage.py shell_plus --quiet-load 2>/dev/null \
| grep Session: \
| cut -d: -f3-'
end
