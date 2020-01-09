#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
re_ip='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
re_ip_user='^.+@[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
IP_LIST=""
MVN_SETTINGS_FILE=""

while test $# -gt 0
do
    case "$1" in
        -h)
            shift
            echo "Usage: ./setup.bash [-H IP | -H USER@IP]..."
            exit
        ;;
        -H)
            shift
            if test $# -gt 0
            then
                if [[ $1 =~ $re_ip_user ]]
                then
                    IP_LIST="${IP_LIST} $1"
                elif [[ $1 =~ $re_ip ]]
                then
                    IP_LIST="${IP_LIST} pi@$1"
                else
                    echo "Invalid IP: $1"
                fi
                shift
            fi
        ;;
    esac
done

if [[ ${IP_LIST} == "" ]]
then
    echo "No hosts specified"
    exit 1
else
    echo "Hosts: ${IP_LIST}"
    for host in ${IP_LIST}
    do
        echo "${host}"
        if [[ ${host} != "" ]]
        then
            ssh ${host} -t "sudo pip install ansible; ansible-pull -U https://github.com/AnimatedLEDStrip/AnimatedLEDStripPiServerExample.git"
        fi
    done
fi
