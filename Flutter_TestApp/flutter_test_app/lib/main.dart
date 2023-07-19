import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BatteryGalleryScreen(title: 'Native and C++ From Flutter Example'),
    );
  }
}

class BatteryGalleryScreen extends StatefulWidget {
  final String title;

  BatteryGalleryScreen({required this.title});

  @override
  _BatteryGalleryScreenState createState() => _BatteryGalleryScreenState();
}

class _BatteryGalleryScreenState extends State<BatteryGalleryScreen> {
  static const platform = MethodChannel('battery_channel');
  static const galleryChannel = MethodChannel('gallery_channel');
  static const mapChannel = MethodChannel('googleMap_Channel');
  static const nativeChannel = MethodChannel('NativeMessage_Channel');
  static const cPlusPlusChannel = MethodChannel('CPlusPlus_Channel');
  String batteryLevel = 'Battery Level';
  String? recordedVideoPath;
  String? mapStatus = "Map Status";
  String? cPlusPlusMessage = "C++";
  String? nativeMessage = "Native Message";
  bool isVideoPlaying = false;
  bool isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    _updateBatteryLevel();
    _updateMapStatus();
    _openNativeMessage();
    _openCPlusPlus();
  }

  Future<void> _updateBatteryLevel() async {
    try {
      final int batteryPercent = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        batteryLevel = 'Battery Level: $batteryPercent%';
      });
    } on PlatformException catch (e) {
      setState(() {
        batteryLevel = "Failed to get battery level: '${e.message}'.";
      });
    }
  }

  Future<void> _updateMapStatus() async {
    try {
      final String? status = await mapChannel.invokeMethod('openGoogleMap');
      setState(() {
        mapStatus = 'Map Status: $status';
      });
    } on PlatformException catch (e) {
      setState(() {
        mapStatus = "Failed to get map status: '${e.message}'.";
      });
    }
  }

  Future<void> _openNativeMessage() async {
    try {
      final String message =
          await nativeChannel.invokeMethod('openNativeMessage');
      setState(() {
        nativeMessage = 'Native Message: $message';
      });
    } on PlatformException catch (e) {
      setState(() {
        nativeMessage = "Failed to get native message: '${e.message}'.";
      });
    }
  }

  Future<void> _openCPlusPlus() async {
    setState(() {
      isVideoPlaying = false;
      isVideoLoading = true;
    });

    try {
      final String? message =
          await cPlusPlusChannel.invokeMethod('openCplusplus');
      setState(() {
        cPlusPlusMessage = 'C++: $message';
      });
    } on PlatformException catch (e) {
      setState(() {
        cPlusPlusMessage = "C++: ${e.message}";
      });
    }

    setState(() {
      isVideoLoading = false;
    });
  }

  Future<void> _openGallery() async {
    String? base64Image;
    try {
      base64Image = await galleryChannel.invokeMethod('openGallery');
    } on PlatformException catch (e) {
      print("Failed to open gallery: '${e.message}'.");
    }

    setState(() {
      recordedVideoPath = null;
      isVideoPlaying = false;
    });
  }

  Future<void> _openCamera() async {
    String? base64Image;
    try {
      base64Image = await galleryChannel.invokeMethod('openCamera');
    } on PlatformException catch (e) {
      print("Failed to open camera: '${e.message}'.");
    }

    setState(() {
      recordedVideoPath = null;
      isVideoPlaying = false;
    });
  }

  Future<void> _recordVideo() async {
    String? base64Video;
    try {
      base64Video = await galleryChannel.invokeMethod('recordVideo');
    } on PlatformException catch (e) {
      print("Failed to record video: '${e.message}'.");
    }

    setState(() {
      recordedVideoPath = base64Video;
      isVideoPlaying = true;
    });
  }

  Future<void> _openMap() async {
    String? message;
    try {
      message = await mapChannel.invokeMethod('openGoogleMap');
    } on PlatformException catch (e) {
      print("Failed to open map: '${e.message}'.");
    }

    setState(() {
      mapStatus = message;
    });
  }

  Widget _buildVideoPlayer() {
    if (recordedVideoPath != null && isVideoPlaying) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isVideoPlaying = !isVideoPlaying;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.memory(
                base64Decode(recordedVideoPath!),
                fit: BoxFit.cover,
              ),
              Icon(
                isVideoPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              batteryLevel,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              mapStatus!,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              nativeMessage!,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              cPlusPlusMessage!,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVideoLoading ? null : _openCPlusPlus,
              child: Text('Open C++ Code'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVideoLoading ? null : _openNativeMessage,
              child: Text('Native Swift Call'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVideoLoading ? null : _openMap,
              child: Text('Open Map'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBatteryLevel,
              child: Text('Refresh Battery Level'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isVideoLoading ? null : _openGallery,
              icon: Icon(Icons.photo_library),
              label: Text('Open Gallery'),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isVideoLoading ? null : _openCamera,
              icon: Icon(Icons.camera_alt),
              label: Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVideoLoading ? null : _recordVideo,
              child: Text('Record Video'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            if (isVideoLoading) CircularProgressIndicator(),
            _buildVideoPlayer(),
          ],
        ),
      ),
    );
  }
}
