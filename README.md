# AnimatedLEDStripServerExample
An example usage of the AnimatedLEDStripServer library with the AnimatedLEDStripPi library.

## Install
To install this server on a Raspberry Pi, run
```
sudo pip install ansible
ansible-pull -U https://github.com/AnimatedLEDStrip/AnimatedLEDStripServerExample.git
```

This will build and install the server on your Pi and add it as a systemd service that runs on startup.

### Note about Raspberry Pi 3B and 3B+
This has been tested on the Raspberry Pi 3B, 3B+, and 4B. On the 3B and 3B+, the Pi's GPU does not initialize fully if
there is no monitor connected on boot. This will cause the LEDs to not work. The workaround is to use a "dummy plug"
that pretends to be a monitor and tricks the Pi into initializing the GPU. These are cheap and can be purchased from Amazon.

The Pi 4B initializes its GPU enough that a dummy plug is not necessary.

## Configuration
The config file is located at `/usr/leds/led.config`. See the 
[AnimatedLEDStripServer wiki](https://github.com/AnimatedLEDStrip/AnimatedLEDStripServer/wiki/Configuration) 
for instructions on configuring the server.
