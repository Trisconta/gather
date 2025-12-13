#!/bin/bash


failed ()
{
 local RES=$1
 shift
 echo "Bailing out: $*"
 exit $RES
}

filter_out ()
{
 local X
 for X in raw-*.txt; do
	diff $X external/dzr-plays/lists/
	if [ $? = 0 ]; then
		rm -f "$X"
		continue
	fi
	echo "+++
"
	mv $X external/dzr-plays/lists/
 done
 rm -f out.rep out.rep.* plays.txt
 return 0
}

#
# Main
#

[ "$(basename $(pwd))" != "gather" ] && failed 2 "Not at propper dir!"

case $1 in
	--skip)
		shift
		[ "$*" ] && failed 3 Invalid
		echo Skipped: update_raws.sh;;
	*) external/dzr-plays/lists/update_raws.sh;;
esac

filter_out

(cd external/jadata-samples && ./upload_playlists.sh)

# Give kudos...
echo "...
done, bye."

# Exit status ok
exit 0
