#!/usr/bin/python3
# --------------------------------------------------------------------------
# Control four neopixels with a button: cycle through 0-1-2-3-4-0 active
# pixels. All pixels have the same color.
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

# values for Pimoroni Plasma2040
PIN_NEO = board.DATA
NUM_NEO = 4
ORD_NEO = neopixel.RGB
LVL_NEO = 0.4             # brightness
INT_NEO = 1               # update interval for colors
PIN_BTN = board.SW_A
INT_BTN = 1               # button delay interval (debounce)
LED_ON  = False           # active low LED

# --- objects   -------------------------------------------------------------

# list of neo-pixel-objects
pixels = neopixel.NeoPixel(
  PIN_NEO, NUM_NEO, brightness=LVL_NEO, auto_write=False, pixel_order=ORD_NEO)
time.sleep(1)

# button
btn           = digitalio.DigitalInOut(PIN_BTN)
btn.switch_to_input(pull=digitalio.Pull.UP)

# led
led = digitalio.DigitalInOut(board.LED_R)
led.switch_to_output(value = not LED_ON)

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
  return (r, g, b) if ORD_NEO in (neopixel.RGB, neopixel.GRB) else (r, g, b, 0)


# --- main loop   -----------------------------------------------------------

counter = 0
col_pos = 0
last_btn    = 0
last_update = 0

while True:
  # update counter
  if not btn.value and time.monotonic() > last_btn + INT_BTN:
    last_btn = time.monotonic()
    counter = (counter+1)%(NUM_NEO+1)
    led.value = LED_ON
    time.sleep(0.2)
    led.value = not LED_ON
  if time.monotonic() > last_update + INT_NEO:
    # update color
    last_update = time.monotonic()
    col_pos     = (col_pos+1)%256
    color       = wheel(col_pos)
    # update pixels
  for i in range(NUM_NEO):
    pixels[i] = color if i<counter else (0,0,0)
  pixels.show()
  time.sleep(0.1)
