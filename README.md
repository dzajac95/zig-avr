# zig-avr

A baremetal blink example targetting the ATmega 328P/Arduino Uno, written entirely in Zig.

I wrote this to be as minimal as humanly possible - no fancy HALs here!

Some inspiration taken from [avr-arduino-zig](https://github.com/FireFox317/avr-arduino-zig).

## Building
Run `zig build`

## Flashing
You need to have avrdude installed.
Then, with the arduino connected, run `zig build flash`
