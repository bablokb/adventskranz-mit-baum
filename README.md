Neo-Pixel illuminated Christmas-Tree
====================================

This project collects various artifacts around my illuminated christmas tree
project.

![](tree.jpg)


3D-Model
--------

The model of the tree (`3D/Ornament.stl`) is from
<https://www.thingiverse.com/thing:2705104> with an additional hole in
the bottom. It is printed in vase-mode with clear PET.


Hardware-Setup
--------------

This projects uses 8mm diffused neopixels from Adafruit, see
<https://www.adafruit.com/product/1734>. Every pixel needs an additional
100nF capacitor and the first pixel in a row should have a 300 Ohm resistor
in line with data-in.

You need a microcontroller driving the neopixel. If you use only a single
pixel or only a few, you can get away with powering from 3V3 and using
3V3 data-lines. Otherwise, you should power from 5V and use level-shifters
if your mcu is a 3V3 device. All the details are in the
<https://learn.adafruit.com/adafruit-neopixel-uberguide>.


PCB
---

A simple pcb for a single 8mm pixel with connectors for chaining.


Python-Source
-------------

The python-source uses CircuitPython to drive one or more pixels.

