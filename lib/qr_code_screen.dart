import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/core/storage_helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_app/qr_result_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData = "No Data";
  bool _changeScreen = false;
  bool isFlash = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
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
          ? QrResultScreen(barcode: scannedData!)
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
            borderColor: Colors.yellow,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
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
                    color: isFlash ? Colors.yellow : Colors.white,
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
      if (!_changeScreen) {
        setState(() {
          scannedData = barCode.code;
          _changeScreen = true;
        });
     await  StorageHelper.saveHistory(scannedData.toString());
      }
    });
    controller.resumeCamera();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    controller?.dispose();
  }
}
