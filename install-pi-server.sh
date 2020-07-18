#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

VERSION=$(curl -s https://api.github.com/repos/AnimatedLEDStrip/server-pi/releases/latest | grep --color="never" -P '"tag_name":' | cut -d '"' -f 4)

rm -rf /tmp/ledserver-download
mkdir /tmp/ledserver-download
cd /tmp/ledserver-download


echo -n "Creating /usr/local/leds..."

install -d /usr/local/leds

echo "done"


echo -n "Installing ledserver..."

wget -q https://github.com/AnimatedLEDStrip/server-pi/releases/download/${VERSION}/animatedledstrip-server-pi-${VERSION}.jar

mv animatedledstrip-server-pi-${VERSION}.jar /usr/local/leds/ledserver.jar

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.sh

install -m 755 ledserver.sh /usr/local/leds/ledserver.sh

chmod 755 /usr/local/leds/ledserver.sh

ln -f -s /usr/local/leds/ledserver.sh /usr/bin/ledserver

echo "done"


echo -n "Installing led.config..."

install -d /etc/leds

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/led.config

install -m 644 led.config /etc/leds/led.config

echo "done"


echo -n "Creating ledserver systemd service..."

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.service

install -m 644 ledserver.service /lib/systemd/system/ledserver.service

systemctl enable ledserver

systemctl daemon-reload

echo "done"


rm -rf /tmp/ledserver-download

echo "AnimatedLEDStrip LED Server for Raspberry Pi installed successfully"
