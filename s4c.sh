#!/bin/bash

USERNAME=""
RECIPIENT=""
PASSWORD=""
URL=""
SLEEP_TIME=28800 #8 hours
SEARCH_STRING='This Page is unchanged'
FILE_OUT=out.html

for (( ; ; )); do
    curl $URL -L --compressed -s > $FILE_OUT
    RESULT="$(cat $FILE_OUT | grep "$SEARCH_STRING")"
    if [ "0" != "${#RESULT}" ]; then
        sleep $SLEEP_TIME
    else
        sendEmail -f $USERNAME -s smtp.gmail.com:587 \
            -xu $USERNAME -xp $PASSWORD -t $RECIPIENT \
            -o tls=yes -u "Web page changed" \
            -m "Visit it at $URL"
        rm $FILE_OUT
        exit 0
    fi
    sleep $SLEEP_TIME
done
