#!/bin/bash

USERNAME=""
RECIPIENT=""
PASSWORD=""
URL=""
SLEEP_TIME=28800 #8 hours
SEARCH_STRING='This Page is unchanged'

for (( ; ; )); do
    curl $URL -L --compressed -s > new.html
    RESULT="$(cat new.html | grep "$SEARCH_STRING")"
    if [ "0" != "${#RESULT}" ]; then
        # Bar is still closed. Continue.
        sleep $SLEEP_TIME
    else
        echo NO_CHANGE!!
        sendEmail -f $USERNAME -s smtp.gmail.com:587 \
            -xu $USERNAME -xp $PASSWORD -t $RECIPIENT \
            -o tls=yes -u "Web page changed" \
            -m "Visit it at $URL"
        exit 0
    fi
    sleep $SLEEP_TIME
done
