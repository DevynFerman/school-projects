---
marp: true
size: 4:3
paginate: true
title: Learning with AI — Driving an External LCD Display via Serial and I2C
---

# Driving an External LCD Display via Serial and I2C

Learning with AI — Topic 2
Devyn Ferman | CSC 494

---

## The Problem

I needed a 16x2 LCD to display GitHub PR status — updated in real time from a Swift CLI running on my Mac.

That meant solving two things:

1. Getting the **Arduino** to drive the LCD over **I2C**
2. Getting the **Mac** to talk to the Arduino over **serial**

Neither had a built-in Swift abstraction, which was most unfotunate for myself.

---

## What I Learned: I2C and the LCD

I2C is a two-wire protocol: **SDA** (data) and **SCL** (clock). The LCD uses an I2C backpack at address `0x27`, driven by the `LiquidCrystal_I2C` library that did the heavy lifting.

```cpp
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
    lcd.init();
    lcd.backlight();
    lcd.setCursor(0, 0);
    lcd.print("GitHubWatcher");
}
```

---

## I2C and the LCD: Key Lesson

**All I2C devices must share a common ground.** Separate grounds prevent any communication, this was the first hardware bug I hit. A brave Arduino Nano and LCD were lost in the completion of this project.

---

## What I Learned: POSIX Serial in Swift

Swift has no built-in serial port API. You use Darwin's C layer directly via `termios`.

```swift
var options = termios()
tcgetattr(fileDescriptor, &options)
cfmakeraw(&options)
cfsetispeed(&options, speed_t(B9600))
cfsetospeed(&options, speed_t(B9600))
tcsetattr(fileDescriptor, TCSANOW, &options)
```

Configuration: **9600 baud, 8 data bits, no parity, 1 stop bit (8N1)**

---

## POSIX Serial in Swift: Sending Data

Send data with `write()`. Call `tcdrain()` to wait for the buffer to flush before continuing. Because this relied on Darwin's C layer, there was a litany of good examples available online and Claude Code helped massively!

---

## What I Learned: Designing the Protocol

Keep serial protocols as simple as possible.

**Format:** `topLine|bottomLine\n`

- Pipe `|` separates the two LCD lines
- Newline `\n` signals end of message
- Both sides truncate to 16 characters — matching the physical display width

Simple, self-delimiting, and predictable. This is where my SWE experience shown most! Enforced on both the Swift side (when building the payload) and the Arduino side (when parsing it).

---

## What I Learned: Validate Hardware Before Adding Software

Before integrating the serial connection, I built a **static test sketch**, just a standalone Arduino program that cycles through hardcoded messages on the LCD with no serial involved.

This confirmed:
- The LCD was correctly wired
- The I2C address was right (`0x27`)
- The library was working

Once the hardware was verified, adding the serial layer was straightforward. Debugging hardware and software simultaneously sounded like a nightmare!

---

## Key Takeaways

1. I2C requires a **shared ground**: all devices on the bus must reference the same GND rail
2. Use Darwin's `termios` API for serial in Swift: configure baud rate, parity, and stop bits explicitly
3. Design your serial protocol to be minimal and self-delimiting: a newline terminator is enough
4. Build a static hardware test before integrating software: it takes a little time but saves loads!
