import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/core/storage_helper.dart';
import 'package:qr_app/screen/qr_result_screen.dart';
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

    _requestCameraPermission();

    _animationControllerHandle();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _changeScreen
          ? QrResultScreen(barcode: scannedData ?? "No Data")
          : _buildMainScreen(size),
    );
  }

  void _animationControllerHandle() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.slowMiddle));
  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {}
  }

  Future<void> _pickImageFromGallery() async {
    await Permission.photos.request();
    if (await Permission.photos.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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

  Stack _buildMainScreen(Size size) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            cutOutBottomOffset: 40,
            borderColor: Colors.yellow.shade800,
            borderRadius: 8,
            borderLength: 30,
            borderWidth: 8,
            cutOutSize: 220,
          ),
        ),
        Positioned(
          top: 70,
          left: 49,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                top: 240 + animation.value * 135,
                left: 45,
                right: 45,
                child: Container(
                  width: 250,
                  height: 2,
                  color: AppConstant.customYellow,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 175,
          left: 45,
          right: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove, color: AppConstant.customWhite),
              Expanded(
                child: Slider(
                  value: _currentZoomLevel,
                  min: 1.0,
                  max: 10.0,
                  divisions: 6,
                  label: "${_currentZoomLevel.toStringAsFixed(1)}x",
                  activeColor: AppConstant.customYellow,
                  inactiveColor: Colors.grey,
                  onChanged: (value) async {
                    setState(() {
                      _currentZoomLevel = value;
                    });
                    if (controller != null) {}
                  },
                ),
              ),
              Icon(Icons.add, color: AppConstant.customWhite),
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
                  child: Icon(
                    Icons.image_rounded,
                    color: AppConstant.customWhite,
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
                    color: AppConstant.customWhite,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller?.flipCamera();
                  },
                  child: Icon(
                    Icons.camera_enhance,
                    color: AppConstant.customWhite,
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
      if (!_changeScreen && barCode.code != null) {
        setState(() {
          scannedData = barCode.code;
          _changeScreen = true;
        });
        await StorageHelper.saveHistory(
            scannedData!, barCode.format.formatName);
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
