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
import random
import adafruit_fancyled.adafruit_fancyled as fancy

LEVELS = [round(0.1*i,1) for i in range(0,11)]

# values for Pimoroni Plasma2040
PIN_NEO = board.DATA
NUM_NEO = 4
ORD_NEO = neopixel.RGB
LVL_NEO = 4               # index into brightness-levels
INT_NEO = 5               # update interval for colors
PIN_BTN = board.SW_A
PIN_LVL = board.SW_B
INT_BTN = 0               # button delay interval (debounce)
LED     = board.LED_R     # board led
LED_ON  = False           # active low LED

# values for Pico
# PIN_NEO = board.GP18
# NUM_NEO = 4
# ORD_NEO = neopixel.GRB
# LVL_NEO = 2               # index into brightness-levels
# INT_NEO = 1               # update interval for colors
# PIN_BTN = board.GP14
# PIN_LVL = board.GP15
# INT_BTN = 0.5             # button delay interval (debounce)
# LED     = board.LED       # board led
# LED_ON  = True            # active high LED

# --- objects   -------------------------------------------------------------

# list of neo-pixel-objects
pixels = neopixel.NeoPixel(
  PIN_NEO, NUM_NEO, brightness=LEVELS[LVL_NEO],
  auto_write=False, pixel_order=ORD_NEO)
time.sleep(1)

# button
btn           = digitalio.DigitalInOut(PIN_BTN)
btn.switch_to_input(pull=digitalio.Pull.UP)
lvl           = digitalio.DigitalInOut(PIN_LVL)
lvl.switch_to_input(pull=digitalio.Pull.UP)

# led
led = digitalio.DigitalInOut(LED)
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

brit_index  = LVL_NEO
col_pos     = random.randrange(256)
color       = wheel(col_pos)
color_adj   = fancy.gamma_adjust(fancy.CRGB(*color),gamma_value=2.2,
                                 brightness=LEVELS[brit_index]).pack()
last_btn    = 0
last_update = 0

while True:
  # update counter on button press
  if not btn.value and time.monotonic() > last_btn + INT_BTN:
    last_btn = time.monotonic()
    counter = (counter+1)%(NUM_NEO+1)
    led.value = LED_ON
    time.sleep(0.2)
    led.value = not LED_ON

  # update brightness-level on button press
  if not lvl.value and time.monotonic() > last_btn + INT_BTN:
    last_btn = time.monotonic()
    brit_index = 1 + brit_index%10
    pixels.brightness = LEVELS[brit_index]
    color_adj = fancy.gamma_adjust(fancy.CRGB(*color),gamma_value=2.2,
                                   brightness=LEVELS[brit_index]).pack()
    led.value = LED_ON
    time.sleep(0.2)
    led.value = not LED_ON

  # update color after INT_NEO seconds
  if time.monotonic() > last_update + INT_NEO:
    # update color
    last_update = time.monotonic()
    col_pos     = (col_pos+1)%256
    color       = wheel(col_pos)
    color_adj = fancy.gamma_adjust(fancy.CRGB(*color),gamma_value=2.2,
                                   brightness=LEVELS[brit_index]).pack()
  # update pixels
  for i in range(NUM_NEO):
    pixels[i] = color_adj if i<counter else (0,0,0)
  pixels.show()
  time.sleep(0.1)
