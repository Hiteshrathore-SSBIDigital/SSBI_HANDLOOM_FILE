import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nehhdc_app/IOT_Screen/DeviceStatus_Screen.dart';
import 'package:nehhdc_app/IOT_Screen/IOTDevice_Scan.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';

class DeviceList extends StatefulWidget {
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<ScanResult> devicesList = [];
  bool isScanning = false;
  Map<BluetoothDevice, bool> deviceConnectionStatus = {};
  int? connectedDeviceIndex;
  bool isConnecting = false;
  bool isBluetoothOn = true;

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        isBluetoothOn = state == BluetoothAdapterState.on;
      });
    });
  }

  void startScan() {
    setState(() {
      isScanning = true;
      devicesList.clear(); // Clear the existing list
    });

    // Start scanning
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen(
      (results) {
        print('Scan results received');

        // Filter results based on the specific UUID
        List<ScanResult> filteredResults = results.where((result) {
          print(
              'Raw Result: ${result.device.name} - ${result.device.remoteId}');

          // Debug: Print all UUIDs found in the advertisement data
          result.advertisementData.serviceUuids.forEach((uuid) {
            print('Found UUID: ${uuid.toString()}');
          });

          // Convert the UUID to a string and check if it matches (case-insensitive)
          String targetUuid = 'f3641400-00b0-4240-ba50-05ca45bf8abc';
          return result.advertisementData.serviceUuids.any((uuid) =>
              uuid.toString().toLowerCase() == targetUuid.toLowerCase());
        }).toList();

        print('Filtered devices: ${filteredResults.length}');
        filteredResults.forEach((result) {
          print('Filtered Device Name: ${result.device.name}');
          print('Filtered Device ID: ${result.device.remoteId}');
        });

        // Update the state with the filtered results
        setState(() {
          devicesList = filteredResults;
          deviceConnectionStatus.clear();
          for (var result in filteredResults) {
            deviceConnectionStatus[result.device] = false;
          }
        });
      },
      onDone: () {
        // Ensure scanning is stopped after done
        if (isScanning) {
          setState(() {
            isScanning = false;
          });
          print('Scanning done');
        }
      },
      onError: (error) {
        print('Error occurred: $error');
        setState(() {
          isScanning = false;
        });
      },
    );
  }

  void stopScan() {
    setState(() {
      isScanning = false;
    });

    FlutterBluePlus.stopScan();
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      setState(() {
        deviceConnectionStatus[device] = false;
      });
    } catch (e) {
      print('Error disconnecting from device: $e');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      if (!isBluetoothOn) {
        showBluetoothDialog();
        return;
      }

      await device.connect();
      if (mounted) {
        setState(() {
          isConnecting = false;
          deviceConnectionStatus[device] = true;
        });
      }

      await Future.delayed(Duration(seconds: 1));

      List<BluetoothService> services = await device.discoverServices();
      BluetoothService? customService = services.firstWhere(
        (service) =>
            service.uuid.toString() == 'f3641400-00b0-4240-ba50-05ca45bf8abc',
        orElse: () => throw Exception('Custom service with UUID not found'),
      );

      BluetoothCharacteristic? customCharacteristic =
          customService.characteristics.firstWhere(
        (characteristic) => [
          'f3641401-00b0-4240-ba50-05ca45bf8abc',
          'f3641402-00b0-4240-ba50-05ca45bf8abc',
          'f3641403-00b0-4240-ba50-05ca45bf8abc',
          'f3641404-00b0-4240-ba50-05ca45bf8abc',
          'f3641405-00b0-4240-ba50-05ca45bf8abc',
          'f3641406-00b0-4240-ba50-05ca45bf8abc',
          'f3641407-00b0-4240-ba50-05ca45bf8abc',
          'f3641408-00b0-4240-ba50-05ca45bf8abc',
          'f3641409-00b0-4240-ba50-05ca45bf8abc',
          'f364140A-00b0-4240-ba50-05ca45bf8abc',
          'f364140B-00b0-4240-ba50-05ca45bf8abc',
          'f364140C-00b0-4240-ba50-05ca45bf8abc',
          'f364140D-00b0-4240-ba50-05ca45bf8abc'
        ].contains(characteristic.uuid.toString()),
        orElse: () =>
            throw Exception('Custom characteristic with UUID not found'),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Device_Status(
            device: device,
            service: customService,
            characteristic: customCharacteristic,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isConnecting = false;
        });
      }
      print('Error connecting to device: $e');
    }
  }

  void showBluetoothDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Row(
          children: [
            Icon(Icons.bluetooth, color: Colors.grey),
            SizedBox(width: 5),
            Text('Bluetooth Scanner',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey)),
          ],
        ),
        content: Text('Turn on Bluetooth to scan nearby devices.'),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _checkBluetoothStatus() async {
    BluetoothAdapterState state = await FlutterBluePlus.adapterState.first;

    setState(() {
      isBluetoothOn = state == BluetoothAdapterState.on;
      if (isBluetoothOn) {
        startScan();
      } else {
        showBluetoothDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices',
            style: apptextsizemanage.Appbartextstyle()),
        actions: [
          TextButton(
            onPressed: isScanning ? stopScan : startScan,
            child: Text(isScanning ? 'STOP SCANNING' : 'SCAN',
                style: apptextsizemanage.Appbartextstyle()),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal),
      ),
      body: Column(
        children: [
          if (!isBluetoothOn)
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bluetooth is disabled",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _checkBluetoothStatus,
                    child: Text("Enable",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                final result = devicesList[index];
                final isConnectedToDevice =
                    deviceConnectionStatus[result.device] ?? false;

                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        result.device.platformName.isEmpty
                            ? 'Unnamed Device'
                            : result.device.platformName,
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        result.device.remoteId.toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Container(
                        width: 120,
                        child: InkWell(
                          child: Container(
                            height: 30,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isConnectedToDevice
                                  ? Colors.green
                                  : Color(ColorVal),
                            ),
                            child: Center(
                              child:
                                  isConnecting && connectedDeviceIndex == index
                                      ? Text("Please wait...",
                                          style: TextStyle(color: Colors.white))
                                      : Text(
                                          isConnectedToDevice
                                              ? "Connected"
                                              : "Connect",
                                          style: TextStyle(color: Colors.white),
                                        ),
                            ),
                          ),
                          onTap: isConnectedToDevice || isConnecting
                              ? null
                              : () async {
                                  setState(() {
                                    connectedDeviceIndex = index;
                                    isConnecting = true;
                                  });
                                  await connectToDevice(result.device);
                                },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(ColorVal),
        child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        onPressed: () {
          if (isBluetoothOn) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => IOTDevice_Scan()));
          } else {
            showBluetoothDialog();
          }
        },
      ),
    );
  }
}
