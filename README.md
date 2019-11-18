# AnimatedLEDStripServerExample
An example usage of the AnimatedLEDStripServer library with the AnimatedLEDStripPi device library.

## Install
This repository supports installation using `ansible-pull`.
A device running `ansible-pull` pulls a repository and then runs the configuration tasks on itself.

To install this server on a Raspberry Pi, run
```bash
sudo pip install ansible
ansible-pull -U https://github.com/AnimatedLEDStrip/AnimatedLEDStripServerExample.git
```

This will build, package and install the server on your Pi and add it as a systemd service that runs on startup.

### Note about Raspberry Pi 3B and 3B+
On the 3B and 3B+, the Pi's GPU does not initialize fully if there is no monitor connected on boot.
If using PWM to control the LEDs, they will not work.
The workaround is to use a "dummy plug" that pretends to be a monitor and tricks the Pi into initializing the GPU.
These are cheap and can be purchased from Amazon.
This has not been tested on the Raspberry Pi 4B yet.

AnimatedLEDStrip uses SPI by default (GPIO pin 12, physical pin 32), so this shouldn't be an issue
(as long as you don't change the pin in the config file or with a command line flag).


## Configure
The config file is located at `/usr/leds/led.config`.
See the [AnimatedLEDStripServer wiki](https://github.com/AnimatedLEDStrip/AnimatedLEDStripServer/wiki/Configuration) for instructions on configuring the server.


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
