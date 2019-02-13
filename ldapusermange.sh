#!/bin/bash
dn="dc=orangeit,dc=com"
ldap_server='192.168.103.100'

fullname=`cat ~/Desktop/testdir/fullname.txt`
firstname=`echo $fullname | awk '{print $1}'`
secondname=`echo $fullname | awk '{print $2}'`
username=`cat ~/Desktop/testdir/username.txt`

available_uidNumber=`expr $(ldapsearch -x -b ${dn} -h ${ldap_server} '(objectClass=posixAccount)' uidNumber | grep "uidNumber: " | sed "s|uidNumber: ||" | uniq | sort -n | tail -n 1) + 1 `

echo "dn: uid=$username,ou=people,dc=orangeit,dc=com
cn: $fullname
gidNumber: 100
givenName: $firstname
homeDirectory: /home/$username
loginShell: /bin/bash
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
sn: $secondname
uid: $username
uidNumber: $available_uidNumber" > ~/Desktop/testdir/ldapuser.ldif

ldapadd -h 192.168.103.100 -x -W -D "cn=Administrator,dc=orangeit,dc=com" -f ~/Desktop/testdir/ldapuser.ldif

ldappasswd -h 192.168.103.100 -s 12345 -W -D "cn=Administrator,dc=orangeit,dc=com" -x "uid=$username,ou=people,dc=orangeit,dc=com"