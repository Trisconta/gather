#!/bin/bash

failed ()
{
 local RES=$1
 shift
 echo "Bailing out: $*"
 exit $RES
}

#
# Main
#

[ "$(basename $(pwd))" != "gather" ] && failed 2 "Not at propper dir!"
[ "$*" ] && failed 0 "No args expected"

(cd external/dztxt-data && ./steps.sh)
RES=$?
[ $RES != 0 ] && failed $RES "steps.sh invoked, exit with status $RES"
(cd external/dztxt-data && ./script.sh)
RES=$?

echo "...
done, bye: $RES."

# Exit status ok
exit $RES
