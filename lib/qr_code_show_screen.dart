import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/core/app_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeShowScreen extends StatelessWidget {
  const QrCodeShowScreen({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color:  Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width / 14,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(6)),
                        child: const Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    const Text(
                      'QR Code',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'NotoSerif',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.86, // Proper width constraint
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data',
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      barcode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.yellow, width: 3.3)),
                child: QrImageView(
                  data: barcode,
                  version: QrVersions.auto,
                  gapless: false,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _shareQrCodeScanner();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Icon(
                            Icons.share,
                            size: 34,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text('Share',   style: TextStyle(
                          fontFamily: 'NotoSerif', color: Colors.white,fontSize: 16),),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _saveImage(barcode);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Icon(
                            Icons.save,
                            color: Colors.black,
                            size: 34,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text('Save',   style: TextStyle(
                          fontFamily: 'NotoSerif', color: Colors.white,fontSize: 16),),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareQrCodeScanner() async {
    try {
      final qrValidation = QrPainter(
        data: barcode,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/qr_code.png';
      final file = File(imagePath);

      final picData = await qrValidation.toImageData(600);
      if (picData != null) {
        await file.writeAsBytes(picData.buffer.asUint8List());

        await Share.shareFiles([imagePath], text: barcode);
      } else {
        AppUtil.showToast('Failed to generate QR code image.');
      }
    } catch (e) {
      AppUtil.showToast('Error while sharing QR code: $e');
    }
  }


  Future<void> _saveImage(String barcode) async {
    await [Permission.storage].request();

    final qrPainter = QrPainter(
      data: barcode,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    final recorder = PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(const Offset(0, 0), const Offset(400, 400)));

    qrPainter.paint(canvas, const Size(400, 400));
    final picture = recorder.endRecording();
    final img = await picture.toImage(400, 400);

    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: "my_qr_code",
    );

    AppUtil.showToast("Image saved to gallery:");
  }
}
