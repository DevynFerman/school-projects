#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

int screen = 0;

void setup() {
  lcd.init();
  lcd.backlight();
}

void loop() {

  lcd.clear();

  if (screen == 0) {
    lcd.setCursor(0,0);
    lcd.print("GitHub Status");
    lcd.setCursor(0,1);
    lcd.print("Checking...");
  }

  else if (screen == 1) {
    lcd.setCursor(0,0);
    lcd.print("PRs Ready");
    lcd.setCursor(0,1);
    lcd.print("2 waiting");
  }

  else if (screen == 2) {
    lcd.setCursor(0,0);
    lcd.print("Reviews Needed");
    lcd.setCursor(0,1);
    lcd.print("1 request");
  }

  delay(3000);

  screen++;

  if (screen > 2) {
    screen = 0;
  }
}