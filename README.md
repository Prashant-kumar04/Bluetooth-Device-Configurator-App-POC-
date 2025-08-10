Bluetooth Device Configurator App (POC)
A Flutter proof-of-concept mobile app that simulates configuring IoT devices over Bluetooth and optionally scanning the connected Wi-Fi network to list all devices.

🎯 Objective
Allow a user to scan Bluetooth devices, select one, and send Wi-Fi credentials (SSID, Password, and optional IP Address) to it.

Optionally scan the current Wi-Fi network to detect all connected devices (similar to the Fing app).

🛠 Features & Requirements
1. Login Screen
Simple login form with Username and Password fields.

Local validation (no backend).

2. Device Configuration Screen
Scan for available Bluetooth devices (simulation).

Select a device from the scan results.

Enter:

Wi-Fi SSID

Wi-Fi Password

(Optional) IP Address

Send configuration (simulated with confirmation dialog/log).

3. Optional Feature – Wi-Fi Network Scan (Bonus)
Scan the current Wi-Fi network for connected devices.

Display results in a list:

Device Name

IP Address

MAC Address

Simulation allowed or integrate with an open-source scanning library.

📱 Tech Stack
Flutter (cross-platform mobile development)

Dart (programming language)

Material Design UI

🚀 Getting Started
bash
Copy
Edit
# Clone the repository
git clone https://github.com/Prashant-kumar04/bluetooth-device-configurator.git
cd bluetooth-device-configurator

# Install dependencies
flutter pub get

# Run the app
flutter run
📌 Demo Flow
Login → Local username/password check.

Main Menu → Choose Bluetooth Configuration or Wi-Fi Network Scan.

Bluetooth Config → Scan, select, and send credentials.

Wi-Fi Scan → View connected devices list.

📸 Screenshots
(Add your screenshots here after running the app)

⚠️ Disclaimer
This is a proof-of-concept app — Bluetooth and Wi-Fi scanning are simulated for demonstration purposes. In a real-world scenario, platform-specific plugins and permissions will be required.
