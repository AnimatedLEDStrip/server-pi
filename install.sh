#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

VERSION=$(curl -s https://api.github.com/repos/AnimatedLEDStrip/server-pi/releases/latest | grep --color="never" -P '"tag_name":' | cut -d '"' -f 4)

mkdir /tmp/ledserver-download

cd /tmp/ledserver-download

mkdir /usr/local/leds

wget https://github.com/AnimatedLEDStrip/server-pi/releases/download/${VERSION}/animatedledstrip-server-pi-${VERSION}.jar

mv animatedledstrip-server-pi-${VERSION}.jar /usr/local/leds/ledserver.jar

wget https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.bash

install -m 755 ledserver.bash /usr/local/leds/ledserver.bash

chmod 755 /usr/local/leds/ledserver.bash

ln -s /usr/local/leds/ledserver.bash /usr/bin/ledserver

mkdir /etc/leds

wget https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/led.config

install -m 644 led.config /etc/leds/led.config

wget https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.service

install -m 644 ledserver.service /lib/systemd/system/ledserver.service

systemctl enable ledserver

systemctl daemon-reload

rm -rf /tmp/ledserver-download
