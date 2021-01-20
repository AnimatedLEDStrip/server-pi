#!/usr/bin/env bash

#  Copyright (c) 2018-2021 AnimatedLEDStrip
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

rm .tmpledconfig
touch .tmpledconfig

echo -n "Number of LEDs [240]: "
read INPUT
echo "numLEDs=${INPUT:-"240"}" >> .tmpledconfig

echo -n "Pin [12]: "
read INPUT
echo "pin=${INPUT:-"12"}" >> .tmpledconfig

echo -n "Ports [5 6]: "
read INPUT
echo "ports=${INPUT:-"5 6"}" >> .tmpledconfig

echo -n "Render Delay (ms) [10]: "
read INPUT
echo "render-delay=${INPUT:-"10"}" >> .tmpledconfig

echo -n "Support 1D Animations [true]: "
read INPUT
echo "1d=${INPUT:-"true"}" >> .tmpledconfig

echo -n "Support 2D Animations [false]: "
read INPUT
echo "2d=${INPUT:-"false"}" >> .tmpledconfig

echo -n "Support 3D Animations [false]: "
read INPUT
echo "3d=${INPUT:-"false"}" >> .tmpledconfig

echo -n "Persist Animations Across Server Restarts [false]: "
read INPUT
echo "persist=${INPUT:-"false"}" >> .tmpledconfig

echo -n "Log Level (error|warn|info|debug|verbose) [warn]: "
read INPUT
echo "log-level=${INPUT:-"warn"}" >> .tmpledconfig

echo -n "Log Renders [false]: "
read INPUT
echo "log-renders=${INPUT:-"false"}" >> .tmpledconfig

if [[ "${INPUT,,}" == "true" ]]
then
    echo -n "Render Log File []: "
    read INPUT
    echo "log-file=$INPUT" >> .tmpledconfig

    echo -n "Render Count Between Log Saves [1000]: "
    read INPUT
    echo "log-render-count=${INPUT:-"1000"}" >> .tmpledconfig
else
    echo "log-file=" >> .tmpledconfig
    echo "log-render-count=1000" >> .tmpledconfig
fi

echo -n "Installing new config file..."

install -m 644 .tmpledconfig /etc/leds/led.config

echo "done"

rm -f .tmpledconfig
