#!/bin/bash
#moitor test1 folder and sync ever test1 to test1=2
#apply all changes from test1 to test2
LTIME=`stat -c %Z /test1`
while true
do
   ATIME=`stat -c %Z /test1`
   if [[ "$ATIME" != "$LTIME" ]]
   then
       rsync -ravzh --delete /test1/ /test2/
       LTIME=$ATIME
   fi
    rsync -ravzh /test1/ /test2/
done

######################################################################
######################################################################

#!/bin/bash
#moitor test2 folder and sync ever test2 to test1
#apply all changes from test2 to test1
LTIME=`stat -c %Z /test2`
while true
do
   ATIME=`stat -c %Z /test2`
   if [[ "$ATIME" != "$LTIME" ]]
   then
       rsync -ravzh --delete /test2/ /test1/
       LTIME=$ATIME
   fi
    rsync -ravzh /test2/ /test1/
done
