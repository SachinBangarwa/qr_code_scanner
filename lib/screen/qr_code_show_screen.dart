import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/core/app_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../core/share_data.dart';

class QrCodeShowScreen extends StatelessWidget {
  const QrCodeShowScreen({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: AppConstant.customBGC,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              _buildAppBar(size, context),
              const SizedBox(
                height: 40,
              ),
              _buildContainerData(context),
              const SizedBox(
                height: 60,
              ),
              _buildQrCodeScanner(),
              const SizedBox(
                height: 30,
              ),
              _buildRowContainerHandler()
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRowContainerHandler() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await ShareData.shareQrCodeScanner(barcode);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: AppConstant.customYellow,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
                          Icons.share,
                          size: 34,
                          color: AppConstant.customBlack,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          fontFamily: 'NotoSerif',
                          color: AppConstant.customWhite,
                          fontSize: 16),
                    ),
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
                            color: AppConstant.customYellow,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
                          Icons.save,
                          color: AppConstant.customBlack,
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Save',
                      style: TextStyle(
                          fontFamily: 'NotoSerif',
                          color: AppConstant.customWhite,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            );
  }

  Container _buildQrCodeScanner() {
    return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: AppConstant.customYellow, width: 3.3)),
              child: QrImageView(
                data: barcode,
                version: QrVersions.auto,
                gapless: false,
                size: 200,
                backgroundColor: AppConstant.customWhite,
              ),
            );
  }

  Container _buildContainerData(BuildContext context) {
    return Container(
              width: MediaQuery.of(context).size.width *
                  0.86, // Proper width constraint
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: AppConstant.customWhite,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      color: AppConstant.customBlack,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    barcode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      color: AppConstant.customBlack,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            );
  }

  Padding _buildAppBar(Size size, BuildContext context) {
    return Padding(
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
                  color: AppConstant.customBlack,
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: AppConstant.customYellow,
              ),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Text(
            'QR Code',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'NotoSerif',
              color: AppConstant.customWhite,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }


  Future<void> _saveImage(String barcode) async {
    await [Permission.storage].request();

    final qrPainter = QrPainter(
        data: barcode,
        version: QrVersions.auto,
        gapless: false,
        color: AppConstant.customBlack,
        emptyColor: AppConstant.customWhite);

    final recorder = PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromPoints(const Offset(0, 0), const Offset(400, 400)));

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
