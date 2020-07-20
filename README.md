# AnimatedLEDStrip Server for Raspberry Pi
An example usage of the AnimatedLEDStripServer library with the AnimatedLEDStripPi device library.

## Install
To install this server on a Raspberry Pi, run
```bash
curl -s https://animatedledstrip.github.io/install/install-pi-server.sh | sudo bash
```

This will install the server on your Pi and add it as a systemd service that runs on startup.

## Physical Setup
See the [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide) for a good introduction to ws281x LEDs, specifically their NeoPixels

### Data
With the default configuration, the data should be connected to GPIO 12 (physical pin 32).
If you set the pin to a different number, check a pin diagram for the Pi to check what physical pin to connect to.
Check the [rpi_ws281x](https://github.com/jgarff/rpi_ws281x) library for which pins are supported, which protocols they correspond to, and other notes about the protocols.

### Ground
The ground should be connected to one of the ground pins on the Pi (physical pins 6, 9, 14, 20, 25, 30, 34 and 39).
The ground should also be connected to the ground of the power supply.

### Power
The [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels) has good tips for powering the LEDs.
If your strip is short enough, may be able to connect the power to the 5V power on the Pi (physical pins 2 and 4).

**Be careful doing this.**

To borrow words from the [rpi_ws281x](https://github.com/jgarff/rpi_ws281x) library: *Know what you're doing with the hardware and electricity. I take no reponsibility for damage, harm, or mistakes.*


## Configure
The config file is located at `/etc/leds/led.config`.
See the [AnimatedLEDStripServer wiki](https://github.com/AnimatedLEDStrip/server/wiki/Configuration) for instructions on configuring the server.


## Update
If you need to update the server with a new version, i.e. a development version, you can use the `./deploy.bash` script.
The script packages the server on your computer, then copies it to any hosts you specify and restarts them.

To specify which hosts to update, add `-H` flags for each host's IP or user@IP, i.e.:
```bash
./deploy.bash -H 10.0.0.254 -H user2@10.0.0.253
```
If no user is specified, `pi` is assumed as default.

To specify a specific `settings.xml` file to use for `mvn`, use the `-s` flag:

```bash
./deploy.bash -H 10.0.0.254 -H user2@10.0.0.253 -s ./settings.xml
```
