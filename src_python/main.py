#!/usr/bin/python3
# --------------------------------------------------------------------------
# Control four neopixels with a button: cycle through 0-1-2-3-4-0 active
# pixels. All pixels have the same color.
#
# Author: Bernhard Bablok
# License: GPL3
#
# Website: https://github.com/bablokb/christmas-tree
#
# Note: color-wheel code from the neopixel-sample from Adafruit
# --------------------------------------------------------------------------

import time
import board
import digitalio
import neopixel

NEO = board.GP15
BTN = board.GP20

btn           = digitalio.DigitalInOut(BTN)
btn.direction = digitalio.Direction.INPUT
btn.pull      = digitalio.Pull.UP

# The number of NeoPixels
num_pixels = 4
ORDER = neopixel.RGB
pixels = neopixel.NeoPixel(
  NEO, num_pixels, brightness=0.2, auto_write=False, pixel_order=ORDER
)

# colorwheel
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
  return (r, g, b) if ORDER in (neopixel.RGB, neopixel.GRB) else (r, g, b, 0)


# --- main loop   -----------------------------------------------------------

counter = 0
col_pos = 0
while True:
  # update counter
  if not btn.value:
    counter = (counter+1)%5
    time.sleep(0.1)
  # update color
  col_pos = (col_pos+1)%256
  color   = wheel(col_pos)
  # update pixels
  for i in range(num_pixels):
    pixels[i] = color if i<counter else (0,0,0)
  pixels.show()
  # and wait
  time.sleep(0.1)
