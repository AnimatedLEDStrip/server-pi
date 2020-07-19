#!/usr/bin/env bash

#   Copyright (c) 2020 AnimatedLEDStrip
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#   THE SOFTWARE.

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

echo -n "Determining latest version..."

VERSION=$(curl -s https://api.github.com/repos/AnimatedLEDStrip/server-pi/releases/latest | grep --color="never" -P '"tag_name":' | cut -d '"' -f 4)

if [[ -z "$VERSION" ]]
then
  echo "Could not determine latest version, aborting"
  exit 1
else
  echo "$VERSION"
fi

echo -n "Checking for java..."

if ! command -v java &> /dev/null
then
  echo "not found"
  echo "Please install java"
  exit 1
else
  echo "found"
fi

rm -rf /tmp/ledserver-download
mkdir /tmp/ledserver-download
cd /tmp/ledserver-download


echo -n "Creating /usr/local/leds..."

if [[ -d /usr/local/leds ]]
then
  echo "exists"
else
  install -d /usr/local/leds
  echo "done"
fi


echo -n "Downloading ledserver..."

wget -q "https://github.com/AnimatedLEDStrip/server-pi/releases/download/${VERSION}/animatedledstrip-server-pi-${VERSION}.jar"

echo "done"


echo -n "Installing ledserver..."

mv "animatedledstrip-server-pi-${VERSION}.jar" /usr/local/leds/ledserver.jar

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.sh

install -m 755 ledserver.sh /usr/local/leds/ledserver.sh

chmod 755 /usr/local/leds/ledserver.sh

ln -f -s /usr/local/leds/ledserver.sh /usr/bin/ledserver

echo "done"


echo -n "Creating /etc/leds..."

if [[ -d /etc/leds ]]
then
  echo "exists"
else
  install -d /etc/leds
  echo "done"
fi


echo -n "Creating led.config..."

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/led.config

install -m 644 led.config /etc/leds/led.config

echo "done"


echo -n "Creating ledserver systemd service..."

wget -q https://raw.githubusercontent.com/AnimatedLEDStrip/server-pi/master/install/ledserver.service

install -m 644 ledserver.service /lib/systemd/system/ledserver.service

systemctl enable ledserver &> /dev/null

systemctl daemon-reload

echo "done"


rm -rf /tmp/ledserver-download

echo "AnimatedLEDStrip LED Server for Raspberry Pi installed successfully"
