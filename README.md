#  Smart Home Bluetooth Control

> An embedded + mobile solution to control home **lighting** and **door locking** over **Bluetooth** using an ESP32/HC-05 module and a Flutter app.

---

##  Overview
This project demonstrates a low-cost smart home system:
- **Flutter mobile app** sends commands via **Bluetooth (BLE/Classic)**.
- **ESP32/Arduino** receives commands and toggles **lights** and a **servo/solenoid door lock**.
- Basic **state feedback** is displayed in the app UI.

---



##  Tech Stack

| Layer | Technologies |
|------|--------------|
| **Mobile App** | Flutter, Dart, `flutter_blue` / `blue_thermal_printer` (for Classic) |
| **MCU** | ESP32 (Arduino Core) or Arduino + HC-05 |
| **Actuators** | Relay module (for light), Servo/Solenoid (for lock) |
| **Tools** | VS Code, PlatformIO/Arduino IDE |

---

##  Features
- ON/OFF control for one or more light channels
- Lock/Unlock door via servo/solenoid
- Auto-reconnect to paired device
- Simple status feedback (LED/Toast/UI badge)

---

##  System Architecture
