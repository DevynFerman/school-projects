//
//  ArduinoSerialConnection.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 3/14/26.
//

import Foundation
import Darwin

private func configureSerialPort(fileDescriptor: Int32) throws {
    var options = termios()

    guard tcgetattr(fileDescriptor, &options) == 0 else {
        throw NSError(
            domain: "SerialWrite",
            code: 2,
            userInfo: [NSLocalizedDescriptionKey: "Failed to read serial port attributes."]
        )
    }

    cfmakeraw(&options)

    options.c_cflag |= tcflag_t(CLOCAL | CREAD)
    options.c_cflag &= ~tcflag_t(PARENB)
    options.c_cflag &= ~tcflag_t(CSTOPB)
    options.c_cflag &= ~tcflag_t(CSIZE)
    options.c_cflag |= tcflag_t(CS8)

    guard cfsetispeed(&options, speed_t(B9600)) == 0 else {
        throw NSError(
            domain: "SerialWrite",
            code: 3,
            userInfo: [NSLocalizedDescriptionKey: "Failed to set input baud rate."]
        )
    }

    guard cfsetospeed(&options, speed_t(B9600)) == 0 else {
        throw NSError(
            domain: "SerialWrite",
            code: 4,
            userInfo: [NSLocalizedDescriptionKey: "Failed to set output baud rate."]
        )
    }

    guard tcsetattr(fileDescriptor, TCSANOW, &options) == 0 else {
        throw NSError(
            domain: "SerialWrite",
            code: 5,
            userInfo: [NSLocalizedDescriptionKey: "Failed to apply serial port attributes."]
        )
    }

    tcflush(fileDescriptor, TCIOFLUSH)
}

final class ArduinoSerialConnection {
    private let fileDescriptor: Int32
    private let portPath: String

    init(portPath: String, startupDelay: TimeInterval = 2.0) throws {
        self.portPath = portPath

        let descriptor = open(portPath, O_RDWR | O_NOCTTY)
        guard descriptor >= 0 else {
            throw NSError(
                domain: "SerialWrite",
                code: 6,
                userInfo: [NSLocalizedDescriptionKey: "Failed to open serial port at \(portPath)."]
            )
        }

        self.fileDescriptor = descriptor

        do {
            try configureSerialPort(fileDescriptor: descriptor)
            Thread.sleep(forTimeInterval: startupDelay)
        } catch {
            close(descriptor)
            throw error
        }
    }

    deinit {
        close(fileDescriptor)
    }

    func send(topLine: String, bottomLine: String) throws {
        let payload = "\(String(topLine.prefix(16)))|\(String(bottomLine.prefix(16)))\n"
        let bytes = Array(payload.utf8)

        let bytesWritten = bytes.withUnsafeBytes { buffer in
            write(fileDescriptor, buffer.baseAddress, buffer.count)
        }

        guard bytesWritten == bytes.count else {
            throw NSError(
                domain: "SerialWrite",
                code: 7,
                userInfo: [NSLocalizedDescriptionKey: "Failed to write full payload to the serial port at \(portPath)."]
            )
        }

        tcdrain(fileDescriptor)
    }
}
