#!/bin/bash
#############################################################################################################
# * Script by Nuwan kaushalya                                                                               #       													               #
#############################################################################################################
#notify when file updated
#script by Nuwan Kaushalya
LTIME=`stat -c %Z /testscript/test`
Aline=`wc -l < /testscript/test`

while true
do
   ATIME=`stat -c %Z /testscript/test`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       Bline=`wc -l < /testscript/test`
       let count=$Bline-$Aline
       echo "$count" > /tmp/count
       msg=`cat /tmp/count`
       zenity --info --title "hiii nuwan" --text "updted $msg line" --display=:0
       Aline=`wc -l < /testscript/test`
       LTIME=$ATIME
   fi
       sleep 05
done
