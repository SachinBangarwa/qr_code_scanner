import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/qr_result_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData = "No Data";
  bool _changeScreen = false;
  bool isFlash = false;
  File? _imageFile;

  late AnimationController animationController;
  late Animation<double> animation;
  double _currentZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();

    requestCameraPermission();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));
  }

  Future<void> requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      print("Camera permission granted");
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _pickImageFromGallery() async {
    controller?.stopCamera();
    await Permission.photos.request();
    if (await Permission.photos.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        _scanQRCodeFromImage(_imageFile!);
      }
    }
  }

  Future<void> _scanQRCodeFromImage(File imageFile) async {
    try {
      setState(() {
        _changeScreen = true;
        scannedData = "Scanned from Image";
      });
    } catch (e) {
      setState(() {
        scannedData = "Error scanning QR code from image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _changeScreen
          ? QrResultScreen(barcode: scannedData ?? "No Data")
          : buildMainScreen(size),
    );
  }

  Stack buildMainScreen(Size size) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.yellow.shade800,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
          ),
        ),
        Positioned(
          top: 70,
          left: 49,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                top: 342 + animation.value * 162,
                left: 72,
                child: Container(
                  width: 250,
                  height: 2,
                  color: Colors.yellow.shade800,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 200,
          left: 55,
          right: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _currentZoomLevel,
                  min: 1.0,
                  max: 10.0,
                  divisions: 6,
                  label: "${_currentZoomLevel.toStringAsFixed(1)}x",
                  activeColor: Colors.yellow.shade800,
                  inactiveColor: Colors.grey,
                  onChanged: (value) async {
                    setState(() {
                      _currentZoomLevel = value;
                    });
                    if (controller != null) {
                    }
                  },
                ),
              ),
              Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: size.height / 14,
              left: size.width / 14,
              right: size.width / 14,
              bottom: size.height / 30),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xE82B2B2C),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width / 16, vertical: size.height * 0.012),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: const Icon(
                    Icons.image_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFlash = !isFlash;
                    });
                    controller?.toggleFlash();
                  },
                  child: Icon(
                    isFlash ? Icons.flash_on : Icons.flash_off,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller?.flipCamera();
                  },
                  child: const Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((barCode) async {
      // Only change screen if QR code is scanned and _changeScreen is false
      if (!_changeScreen && barCode.code != null) {
        setState(() {
          scannedData = barCode.code;
          _changeScreen = true;
        });
      }
    });
    controller.resumeCamera();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    controller?.dispose();
  }
}
