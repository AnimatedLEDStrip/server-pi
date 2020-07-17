#!/bin/bash

# Build and deploy a new version to the remote device

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
re_ip='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
re_ip_user='^.+@[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
IP_LIST=""
MVN_SETTINGS_FILE=""
RESTART=0

while test $# -gt 0
do
    case "$1" in
        -h)
            shift
            echo "Usage: ./deploy.bash [-H IP | -H USER@IP]... [-R] [-s SETTINGS_FILE] [-v VERSION]"
            echo "      -h          Show this help message"
            echo "      -H IP       Specify a host with username pi"
            echo "      -H USER@IP  Specify a host with a different username"
            echo "      -R          Restart the remote host instead of just restarting the service"
            echo "      -s          Specify a maven settings file"
            echo "      -v          Specify a specific version of animatedledstrip to build"
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
        -R)
            shift
            RESTART=1
        ;;
        -s)
            shift
            if test $# -gt 0
            then
                MVN_SETTINGS_FILE=$1
                shift
            fi
        ;;
        -v)
            shift
            if test $# -gt 0
            then
                ALS_VERSION=$1
                shift
            fi
        ;;
    esac
done

if [[ ${MVN_SETTINGS_FILE} != "" ]]
then
    MVN_SETTINGS_FILE="-gs ${MVN_SETTINGS_FILE}"
fi

if [[ ${ALS_VERSION} != "" ]]
then
    ALS_VERSION="-Danimatedledstrip.version=${ALS_VERSION}"
fi

# shellcheck disable=SC2086
mvn package ${MVN_SETTINGS_FILE} ${ALS_VERSION}

# shellcheck disable=SC2181
if [[ $? != 0 ]]
then
    echo "Maven build failed"
    exit
else
    echo "Maven build successful, continuing to deployment..."
fi

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
            scp "${DIR}"/target/animatedledstrip-server-example-1.0.jar "${host}":/usr/local/leds/ledserver.jar
            if [[ ${RESTART} == 1 ]]
            then
                ssh "${host}" -t "sudo reboot"
            else
                ssh "${host}" -t "sudo systemctl restart ledserver"
            fi
        fi
    done
fi
