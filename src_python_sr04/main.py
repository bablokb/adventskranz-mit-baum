#!/usr/bin/python3
# --------------------------------------------------------------------------
# Control four neopixels with a HC-SR04 distance-sensor:
# cycle through 0-1-2-3-4-0 active pixels. All pixels have the same color.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/adventskranz-mit-baum
#
# Note: color-wheel code from the neopixel-sample from Adafruit
# --------------------------------------------------------------------------

import time
import board
import digitalio
import neopixel
import adafruit_hcsr04

PIN_NEO  = board.GP28
NUM_NEO  = 4
ORD_NEO  = neopixel.RGB
PIN_TRIG = board.GP16
PIN_ECHO = board.GP17

# --- objects   -------------------------------------------------------------

# list of neo-pixel-objects
pixels = neopixel.NeoPixel(
  PIN_NEO, NUM_NEO, brightness=0.2, auto_write=False, pixel_order=ORD_NEO)

# distance sensor
sonar = adafruit_hcsr04.HCSR04(trigger_pin=PIN_TRIG,echo_pin=PIN_ECHO)

# --- measure distance   -----------------------------------------------------

def get_distance():
  sum = 0
  for i in range(5):
    a = 0
    while not a:
      try:
        a = sonar.distance
      except RuntimeError:
        a = 0
    sum += a
    time.sleep(0.1)
  sum = sum/5
  return sum

# --- colorwheel   -----------------------------------------------------------

def wheel(pos):
  # Input a value 0 to 255 to get a color value.
  # The colours are a transition r - g - b - back to r.
  if pos < 0 or pos > 255:
    r = g = b = 0
  elif pos < 85:
    r = int(pos * 3)
    g = int(255 - pos * 3)
    b = 0
  elif pos < 170:
    pos -= 85
    r = int(255 - pos * 3)
    g = 0
    b = int(pos * 3)
  else:
    pos -= 170
    r = 0
    g = int(pos * 3)
    b = int(255 - pos * 3)
  return (r,g,b) if ORD_NEO in (neopixel.RGB,neopixel.GRB) else (r,g,b,0)

# --- pixel-update   --------------------------------------------------------

col_pos = 0
def update_pixel():
  global col_pos
  # update color
  col_pos = (col_pos+1)%256
  color   = wheel(col_pos)
  # update pixels
  for i in range(NUM_NEO):
    pixels[i] = color if i<counter else (0,0,0)
  pixels.show()
  
# --- main loop   -----------------------------------------------------------

counter = 0
while True:
  # wait for "on"-event, i.e. distance < 100cm
  while get_distance() > 100:
    update_pixel()
    continue

  # update counter
  counter = (counter+1)%5

  # and wait for "off"-event, i.e. distance > 100cm
  while get_distance() < 100:
    update_pixel()
    continue
