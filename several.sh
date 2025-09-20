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
	[ $? = 0 ] && continue
	echo "+++
"
	mv $X external/dzr-plays/lists/
 done
 rm -f rep.out.* plays.txt
 return 0
}

#
# Main
#

[ "$(basename $(pwd))" != "gather" ] && failed 2 "Not at propper dir!"

external/dzr-plays/lists/update_raws.sh

filter_out

(cd external/jadata-samples && ./upload_playlists.sh)

# Give kudos...
echo "...
done, bye."

# Exit status ok
exit 0
