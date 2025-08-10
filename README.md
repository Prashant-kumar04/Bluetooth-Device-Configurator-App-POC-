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

/*
==========================================================
⚠️ IMPORTANT NOTICE – SIMULATION ONLY ⚠️
==========================================================

This app is a Proof of Concept (POC) and uses **predefined, 
simulated Bluetooth device scanning and network results**.

What this means:
- The "Scan Devices" feature currently shows a FIXED device list.
- No real Bluetooth scanning or WiFi network scanning happens in this POC.

If you want to make this a REAL, working application:

1️⃣ Add the Required Packages:
   Open `pubspec.yaml` and add:
     flutter_blue_plus: ^<latest_version>
     network_info_plus: ^<latest_version>
     ping_discover_network: ^<latest_version>

2️⃣ Configure App Permissions:
   - **Android:** Edit `AndroidManifest.xml` to include Bluetooth, 
     location, and network scanning permissions.
   - **iOS:** Edit `Info.plist` to include Bluetooth usage descriptions.

3️⃣ Replace Simulation Logic:
   - In `DeviceConfigScreen`:
       Replace `_startScan` and `_sendConfiguration` with calls 
       to `flutter_blue_plus` API.
       Use your hardware's **Service UUID** and **Characteristic UUID** 
       to send the WiFi SSID, password, and IP address.
   - In `NetworkScannerScreen`:
       Replace `_scanNetwork` with logic using:
         - `network_info_plus` (to get the subnet)
         - `ping_discover_network` (to find live devices on the network)

4️⃣ Add Error Handling:
   - Handle cases like Bluetooth off, permissions denied, or device not found.
   - Show appropriate error messages to users.

==========================================================
💡 TIP: Keep this comment here so future developers understand 
that this project is a POC and needs real integration work 
before production use.
==========================================================
*/

