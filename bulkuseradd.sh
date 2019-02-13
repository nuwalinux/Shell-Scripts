#!/bin/bash
#############################################################################################################
# * Script by Nuwan kaushalya                                                                               #
# * ad single ore bulk users to open ldap server       													                                        #
#############################################################################################################
 
_main () {

trap "rm -f $tmpuop $passtp" 0 1 2 5 15
 tmpuop='/tmp/tmpuop'
 
#################### Copy dialogrc for dialogbox modificatios ##################################
> $HOME/.dialogrc
cp -r /Sharepoint/.dialogrc $HOME
################################################################################################

dialog --backtitle "Your Company Copyright © 2017" \
--title "LDAP Server Access Contol Panel" \
--menu "Please choose an option:" 16 58 7 \
                   1 "> LDAP User Add ->" \
                   2 "> LDAP User Delete ->" \
                   3 "> Exit from this menu ->" 2> $tmpuop 

   retv=$?
   choice=$(cat $tmpuop)
   [ $retv -eq 1 -o $retv -eq 255 ] && exit

   case $choice in
       1)
          chmod 777 /tmp/tmpuop
          _ldapaddscript ;;

       2) chmod 777 /tmp/tmpuop
          _ldapselcript ;;

       3) exit ;; 
      esac

}

_ldapaddscript () {
dn="dc=example,dc=com"
ldap_server='ip address'
vim ~/Desktop/testdir/namelist.txt
cat ~/Desktop/testdir/namelist.txt | while read LINE
do
available_uidNumber=`expr $(ldapsearch -x -b ${dn} -h ${ldap_server} '(objectClass=posixAccount)' uidNumber | grep "uidNumber: " | sed "s|uidNumber: ||" | uniq | sort -n | tail -n 1) + 1` 
echo $LINE | awk '{print "dn: uid="$3",ou=people,dc=nlab,dc=com\ncn: "$1" "$2"\ngidNumber: 100\ngivenName: "$1"\nhomeDirectory: /home/"$3"\nloginShell: /bin/bash\nobjectClass: top\nobjectClass: posixAccount\nobjectClass: inetOrgPerson\nuidNumber: '$available_uidNumber'\nsn: "$2"\nuserPassword: {SHA}jLIjfQZ5yojbZGTqxg2pY0VROWQ=\nuid: "$3"\n"}' > ~/Desktop/testdir/user.ldif
ldapadd -h ldap-server-ip -x -w ldap-server-password -D "cn=Administrator,dc=example,dc=com" -f ~/Desktop/testdir/user.ldif
done && /Sharepoint/bulkuseradd.sh
}

_ldapselcript () {
vim ~/Desktop/deluser.txt
deluser=`cat ~/Desktop/deluser.txt`
for deluser in $deluser;
do
ldapdelete -h ldap-server-ip -x -D "cn=Administrator,dc=example,dc=com" -w ldap-server-ip \ "uid=$deluser,ou=People,dc=nlab,dc=com"
sleep 02
done && /Sharepoint/bulkuseradd.sh
}
_main
