// ---------------------------------------------------------------------------
// Control four neopixels with a button: cycle through 0-1-2-3-4-0 active
// pixels. All pixels have the same color.
//
// Author: Bernhard Bablok
// License: GPL3
//
// Website: https://github.com/bablokb/adventskranz-mit-baum
//
// Note: this is an adapted example from Adafruit's neopixel-lib
// ---------------------------------------------------------------------------

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

uint32_t wheel(byte pos);

// --- settings   ------------------------------------------------------------

#define NEO_PIN     0          // connected to data-in
#define BTN_PIN     2          // button
#define NUMPIXELS   4          // number of pixels
#define BRIGHTNESS  50         // pin-brightness: 0-255 (not linear)
#define DELAY       100       // delay in ms

// --- objects   -------------------------------------------------------------

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, NEO_PIN,
                                            NEO_RGB + NEO_KHZ800);
int          counter;
byte         col_pos;
uint32_t     color;

// --- setup of objects   ----------------------------------------------------

void setup() {
  pinMode(BTN_PIN, INPUT_PULLUP);
  counter = 0;
  col_pos = 0;
  strip.begin();
  strip.setBrightness(BRIGHTNESS);
  strip.show();                       // initialize all pixels to 'off'
}

// --- main loop   -----------------------------------------------------------

void loop() {
  if (digitalRead(BTN_PIN) == LOW) {
    counter = (counter+1)%5;
    delay(DELAY);                       // debounce
  }

  // update color
  col_pos = (col_pos+1)%256;
  color   = wheel(col_pos);

  // update pixels
  for (int i=0; i<NUMPIXELS; ++i) {
    if (i < counter) {
      strip.setPixelColor(i,color);
    } else {
      strip.setPixelColor(i,0);
    }
  }

  // display result and wait
  strip.show();
  delay(DELAY);
}

// --- get color from the color wheel   --------------------------------------
// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.

uint32_t wheel(byte pos) {
  pos = 255 - pos;
  if(pos < 85) {
    return strip.Color(255 - pos * 3, 0, pos * 3);
  }
  if(pos < 170) {
    pos -= 85;
    return strip.Color(0, pos * 3, 255 - pos * 3);
  }
  pos -= 170;
  return strip.Color(pos * 3, 255 - pos * 3, 0);
}
