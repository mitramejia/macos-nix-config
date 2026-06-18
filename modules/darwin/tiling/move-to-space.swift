import CoreGraphics
import Foundation

func fail(_ message: String) -> Never {
  fputs("yabai-move-to-space: \(message)\n", stderr)
  exit(1)
}

func focusedGrabPoint() -> CGPoint {
  let proc = Process()
  proc.executableURL = URL(fileURLWithPath: "@YABAI@")
  proc.arguments = ["-m", "query", "--windows", "--window"]

  let pipe = Pipe()
  proc.standardOutput = pipe
  proc.standardError = FileHandle.nullDevice

  do {
    try proc.run()
  } catch {
    fail("failed to run yabai: \(error)")
  }

  proc.waitUntilExit()
  if proc.terminationStatus != 0 {
    fail("no focused yabai window")
  }

  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  guard
    let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
    let frame = obj["frame"] as? [String: Any],
    let x = frame["x"] as? Double,
    let y = frame["y"] as? Double,
    let w = frame["w"] as? Double
  else {
    fail("focused window did not include a usable frame")
  }

  return CGPoint(x: x + w / 2.0, y: y + 14.0)
}

func mouse(_ type: CGEventType, _ pt: CGPoint) {
  guard let e = CGEvent(
    mouseEventSource: nil,
    mouseType: type,
    mouseCursorPosition: pt,
    mouseButton: .left
  ) else {
    fail("failed to create mouse event")
  }
  e.flags = []
  e.post(tap: .cghidEventTap)
}

func key(_ code: CGKeyCode, _ down: Bool) {
  guard let e = CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: down) else {
    fail("failed to create key event")
  }
  e.flags = .maskControl
  e.post(tap: .cghidEventTap)
}

guard CommandLine.arguments.count == 2 else {
  fail("expected one key-code argument")
}

guard let code = UInt16(CommandLine.arguments[1]) else {
  fail("invalid key-code argument: \(CommandLine.arguments[1])")
}

let grab = focusedGrabPoint()

usleep(50_000)
mouse(.leftMouseDown, grab)
for i in 1...5 {
  mouse(.leftMouseDragged, CGPoint(x: grab.x, y: grab.y + Double(i) * 2.0))
  usleep(20_000)
}
key(code, true)
key(code, false)
usleep(200_000)
mouse(.leftMouseUp, CGPoint(x: grab.x, y: grab.y + 10.0))
