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
            echo "Usage: ./deploy.bash [-H IP | -H USER@IP]..."
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
        -s)
            shift
            if test $# -gt 0
            then
                MVN_SETTINGS_FILE=$1
                shift
            fi
        ;;
    esac
done

if [[ ${MVN_SETTINGS_FILE} != "" ]]
then
    MVN_SETTINGS_FILE="-gs ${MVN_SETTINGS_FILE}"
fi

mvn package ${MVN_SETTINGS_FILE}

if [[ ${IP_LIST} == "" ]]
then
    echo "No hosts specified"
else
    echo "Hosts: ${IP_LIST}"
    for host in ${IP_LIST}
    do
        echo "${host}"
        if [[ ${host} != "" ]]
        then
            scp ${DIR}/target/animatedledstrip-server-example-1.0.jar ${host}:/usr/leds/ledserver.jar
            ssh ${host} -t "sudo reboot"
        fi
    done
fi
