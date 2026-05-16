# GitHubWatcher

A Swift CLI that polls the GitHub API for pull request activity and sends live status updates over serial to an Arduino-driven I2C LCD display — giving you a physical, always-on PR dashboard you can glance at without leaving your editor.

## How It Works

1. The Swift CLI authenticates with GitHub and fetches your repos at startup
2. Every poll cycle it checks for open PRs and review requests across all your repos
3. It applies priority logic to decide what to show: **review requests → draft PRs → open PR count → all clear**
4. If the display message changed since the last cycle, it sends `topLine|bottomLine\n` over serial to the Arduino
5. The Arduino parses the message and updates the 16x2 LCD

## Hardware Required

- Arduino Nano
- 16x2 HD44780-compatible LCD
- I2C backpack (address `0x27`)
- MB-102 breadboard + jumper wires
- USB cable to connect the Arduino to your Mac

## Project Structure

```
├── GitHub-Status-IoT-App/
│   └── GitHubWatcher/              # Swift Package (CLI executable)
│       └── Sources/GitHubWatcher/
│           ├── GitHubWatcher.swift             # AsyncParsableCommand, polling loop
│           ├── ArduinoSerialConnection.swift   # POSIX serial (9600 baud, 8N1)
│           ├── Models/                         # Credentials, GitHubUser, Repository, WatcherManager
│           └── Endpoints/                      # GitHub API calls, display message logic
├── Arduino/
│   ├── GitHubWatcher_IoT/          # Main sketch: serial input → I2C LCD
│   └── LCD-StatusMessage-Static/   # Static test sketch for hardware validation
└── Learning-With-AI/               # CSC 494 learning journal (Marp slides + progress log)
```

## Setup

### 1. Arduino Firmware

Open `Arduino/GitHubWatcher_IoT/GitHubWatcher_IoT.ino` in the Arduino IDE, install the `LiquidCrystal_I2C` library, and flash it to your Arduino Nano.

> If this is your first time wiring the LCD, use the static test sketch in `Arduino/LCD-StatusMessage-Static/` to verify hardware before adding serial.

### 2. Swift CLI

Requires Swift 6.2+.

```bash
cd GitHub-Status-IoT-App/GitHubWatcher
swift build -c release
```

Or use the included wrapper script from the repo root:

```bash
./start-watcher.zsh <github-username> <github-token> [options]
```

### GitHub Token

Generate a classic personal access token at [github.com/settings/tokens](https://github.com/settings/tokens) with the `repo` scope.

## Usage

```
swift run GitHubWatcher <username> <github-token> [--wait <minutes>] [--watchTimeout <minutes>] [--port <serial-port>]
```

| Option | Default | Description |
|---|---|---|
| `--wait` | `5` | Minutes between poll cycles |
| `--watchTimeout` | `8` | Total runtime in minutes |
| `--port` | `/dev/cu.usbserial-210` | Serial port path for the Arduino |

Find your Arduino's serial port with:

```bash
ls /dev/cu.*
```

## Display Priority

| Priority | Condition | Example Display |
|---|---|---|
| 1 | Review requested on your PR | `Review Needed` / `repo-name` |
| 2 | Draft PR open | `Draft PR` / `repo-name` |
| 3 | Open PRs | `Open PRs: 3` / `repo-name` |
| 4 | Nothing open | `No Open PRs` |

The display only updates when the status changes — no unnecessary serial writes.
