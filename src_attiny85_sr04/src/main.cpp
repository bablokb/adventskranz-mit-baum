// ---------------------------------------------------------------------------
// Control four neopixels with a HC-SR04 ultrasonic sensor:
// cycle through 0-1-2-3-4-0 active pixels. All pixels have the same color.
//
// Note there is an additional button to turn the pixels on/off without
// changing the number of active pixels.
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
#include <NewPing.h>

void update_pixel(void);
uint32_t wheel(byte pos);

// --- settings   ------------------------------------------------------------

#define NEO_PIN 0     // connected to data-in
#define LED_PIN 1     // on board LED
#define BTN_PIN 2     // button
#define TRG_PIN 3     // SR04 trigger pin
#define ECHO_PIN 4    // SR05 echo pin
#define NUMPIXELS 4   // number of pixels
#define BRIGHTNESS 50 // pin-brightness: 0-255 (not linear)
#define DELAY 100     // delay in ms

// --- objects   -------------------------------------------------------------

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS, NEO_PIN,
                                            NEO_RGB + NEO_KHZ800);
NewPing sonar(TRG_PIN, ECHO_PIN);

byte counter, global_state, sonar_state, col_pos;
uint32_t color;

// --- setup of objects   ----------------------------------------------------

void setup() {
  pinMode(BTN_PIN, INPUT_PULLUP);
  pinMode(LED_PIN,OUTPUT);
  digitalWrite(LED_PIN,LOW);
  counter = 0;
  global_state = 0;
  sonar_state = 0;
  col_pos = 0;
  strip.begin();
  strip.setBrightness(BRIGHTNESS);
  strip.show(); // initialize all pixels to 'off'
}

// --- main loop   -----------------------------------------------------------

void loop() {
  while (true) {
    update_pixel();

    if (digitalRead(BTN_PIN) == LOW) {
      global_state = 1 - global_state;
      digitalWrite(LED_PIN,global_state);
      delay(2*DELAY); // debounce
      continue;
    }

    // idle loop if state is off
    if (!global_state) {
      continue;
    }

    // check "on"-event, i.e. distance < 100cm
    if (!sonar_state && sonar.convert_cm(sonar.ping_median()) < 100) {
      sonar_state = 1;
      counter = (counter + 1) % 5;  // event detected, update counter
      continue;
    }

    // check "off"-event, i.e. distance > 100cm
    if (sonar_state && sonar.convert_cm(sonar.ping_median()) > 100) {
      sonar_state = 0;
    }
  }
}

// --- pixel-update   --------------------------------------------------------

void update_pixel(void) {
  // update color
  col_pos = col_pos + 1;     // this is %256, since col_pos is a byte
  color = wheel(col_pos);

  // update pixels
  for (int i = 0; i < NUMPIXELS; ++i) {
    if (i < counter && global_state) {
      strip.setPixelColor(i, color);
    } else {
      strip.setPixelColor(i, 0);
    }
  }
  strip.show();
}

// --- get color from the color wheel   --------------------------------------
// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.

uint32_t wheel(byte pos) {
  pos = 255 - pos;
  if (pos < 85) {
    return strip.Color(255 - pos * 3, 0, pos * 3);
  }
  if (pos < 170) {
    pos -= 85;
    return strip.Color(0, pos * 3, 255 - pos * 3);
  }
  pos -= 170;
  return strip.Color(pos * 3, 255 - pos * 3, 0);
}
