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


import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// --- Data Models for Simulation ---

// A model for a simulated Bluetooth device
class FakeBluetoothDevice {
  final String name;
  final String id;

  FakeBluetoothDevice({required this.name, required this.id});
}

// A model for a simulated device found on the WiFi network
class FakeNetworkDevice {
  final String ip;
  final String mac;
  final String hostname;

  FakeNetworkDevice({required this.ip, required this.mac, required this.hostname});
}


// --- Main Application Entry Point ---

void main() {
  runApp(const DeviceConfiguratorApp());
}

class DeviceConfiguratorApp extends StatelessWidget {
  const DeviceConfiguratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Configurator POC',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.indigo,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// --- Screen 1: Login Screen ---

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Local validation as requested
    if (_usernameController.text == 'admin' && _passwordController.text == 'password') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHubScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Use admin/password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.lock_outline, size: 80, color: Colors.indigo[200]),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _login,
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// --- Hub Screen to Choose Feature ---

class MainHubScreen extends StatelessWidget {
  const MainHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bluetooth_searching),
                label: const Text('Configure Device (Bluetooth)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeviceConfigScreen()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.wifi_find),
                label: const Text('Scan WiFi Network (Optional)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NetworkScannerScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Screen 2: Device Configuration Screen (Bluetooth) ---

class DeviceConfigScreen extends StatefulWidget {
  const DeviceConfigScreen({super.key});

  @override
  State<DeviceConfigScreen> createState() => _DeviceConfigScreenState();
}

class _DeviceConfigScreenState extends State<DeviceConfigScreen> {
  bool _isScanning = false;
  List<FakeBluetoothDevice> _scanResults = [];
  FakeBluetoothDevice? _selectedDevice;

  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ipController = TextEditingController();

  void _startScan() {
    setState(() {
      _isScanning = true;
      _scanResults = [];
      _selectedDevice = null;
    });

    // Simulate scanning for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _scanResults = [
          FakeBluetoothDevice(name: 'IoT_Weather_Station', id: 'AB:CD:EF:12:34:56'),
          FakeBluetoothDevice(name: 'Smart_Bulb_A4', id: '11:22:33:44:55:66'),
          FakeBluetoothDevice(name: 'Config_Device_001', id: 'FE:DC:BA:98:76:54'),
        ];
        _isScanning = false;
      });
    });
  }
  
  void _sendConfiguration() {
    if (_ssidController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SSID and Password cannot be empty.'), backgroundColor: Colors.orange),
      );
      return;
    }
    
    // In a real app, this is where you'd use flutter_blue_plus to write data
    // to the _selectedDevice's specific GATT characteristic.
    // For now, we just simulate the success.
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simulation Success'),
        content: Text(
          'Data sent to ${_selectedDevice!.name}:\n\n'
          'SSID: ${_ssidController.text}\n'
          'Password: [hidden]\n'
          'IP Address: ${_ipController.text.isEmpty ? "DHCP (default)" : _ipController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Device Configurator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Scan for Bluetooth Devices'),
              onPressed: _isScanning ? null : _startScan,
            ),
            if (_isScanning) const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 10),
            if (_scanResults.isNotEmpty) Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final device = _scanResults[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      onTap: () => setState(() => _selectedDevice = device),
                      selected: _selectedDevice?.id == device.id,
                      selectedTileColor: Colors.indigo.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            if (_selectedDevice != null) Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Configure "${_selectedDevice!.name}"', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 20),
                      TextField(controller: _ssidController, decoration: const InputDecoration(labelText: 'WiFi SSID', border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'WiFi Password', border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: _ipController, decoration: const InputDecoration(labelText: 'IP Address (Optional)', border: OutlineInputBorder(), hintText: 'e.g., 192.168.1.100')),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _sendConfiguration,
                        child: const Text('Send Configuration'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Screen 3: Optional - Network Scanner Screen ---

class NetworkScannerScreen extends StatefulWidget {
  const NetworkScannerScreen({super.key});

  @override
  State<NetworkScannerScreen> createState() => _NetworkScannerScreenState();
}

class _NetworkScannerScreenState extends State<NetworkScannerScreen> {
    bool _isScanning = false;
    List<FakeNetworkDevice> _networkDevices = [];
    
    void _scanNetwork() {
      setState(() {
        _isScanning = true;
        _networkDevices = [];
      });
      
      // Simulate network scanning for 4 seconds
      Future.delayed(const Duration(seconds: 4), () {
        final random = Random();
        setState(() {
          _networkDevices = List.generate(random.nextInt(10) + 5, (index) {
            final ip = '192.168.1.${random.nextInt(253) + 1}';
            final mac = List.generate(6, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
            final hostnames = ['android-device', 'iPhone', 'LAPTOP-XYZ', 'UNKNOWN', 'smart-tv', 'printer'];
            return FakeNetworkDevice(ip: ip, mac: mac, hostname: hostnames[random.nextInt(hostnames.length)]);
          });
          _networkDevices.sort((a,b) => a.ip.compareTo(b.ip)); // Sort by IP
          _isScanning = false;
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('WiFi Network Scanner'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.wifi_tethering),
                label: const Text('Scan Local Network'),
                onPressed: _isScanning ? null : _scanNetwork,
              ),
            ),
            if (_isScanning) const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ) else if (_networkDevices.isEmpty)
              const Expanded(
                child: Center(child: Text('Press "Scan" to discover devices on your WiFi.')),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _networkDevices.length,
                  itemBuilder: (context, index) {
                    final device = _networkDevices[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.computer),
                        title: Text(device.hostname),
                        subtitle: Text('IP: ${device.ip}\nMAC: ${device.mac}'),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    }
}
