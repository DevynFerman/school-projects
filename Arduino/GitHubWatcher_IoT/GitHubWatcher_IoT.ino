#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

String serialBuffer = "";

void setup() {
  Serial.begin(9600);

  lcd.init();
  lcd.backlight();

  lcd.setCursor(0, 0);
  lcd.print("GitHubWatcher");
  lcd.setCursor(0, 1);
  lcd.print("Waiting...");

  delay(500);
}

void loop() {
  while (Serial.available()) {
    char c = Serial.read();

    if (c == '\n') {
      displayMessage(serialBuffer);
      serialBuffer = "";
    } else {
      serialBuffer += c;
    }
  }
}

// Expects format: "topLine|bottomLine"
void displayMessage(String payload) {
  int separatorIndex = payload.indexOf('|');
  if (separatorIndex < 0) {
    return;
  }

  String topLine = payload.substring(0, separatorIndex);
  String bottomLine = payload.substring(separatorIndex + 1);

  topLine = topLine.substring(0, min((unsigned int)16, topLine.length()));
  bottomLine = bottomLine.substring(0, min((unsigned int)16, bottomLine.length()));

  lcd.clear();

  lcd.setCursor(0, 0);
  lcd.print(topLine);

  lcd.setCursor(0, 1);
  lcd.print(bottomLine);
}
