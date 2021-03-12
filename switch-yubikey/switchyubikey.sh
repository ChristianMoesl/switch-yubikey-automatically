#!/bin/bash

user="{{USER}}"
mail="{{MAIL}}"

# wait until Yubikey is probably ready
sleep 1

# we have to restart agents if we use them
killall -9 ssh-agent gpg-agent

# delete all private keys for that mail address
for keystub in $(/usr/local/bin/gpg --with-keygrip --list-secret-keys $mail | grep Keygrip | awk '{print $3}')
do 
  rm "/Users/${user}/.gnupg/private-keys-v1.d/$keystub.key" 
done

# initialize new Yubikey
/usr/local/bin/gpg --card-status

# start previously killed agents
eval $(/usr/local/bin/gpgconf --launch gpg-agent)

ssh-add -l
