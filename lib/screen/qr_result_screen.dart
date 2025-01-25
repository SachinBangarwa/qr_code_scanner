import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/core/app_util.dart';
import 'package:qr_app/dashboard_screen.dart';
import 'package:qr_app/screen/qr_code_show_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrResultScreen extends StatelessWidget {
  const QrResultScreen({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            buildAppBar(context),
            const SizedBox(
              height: 30,
            ),
            _buildContainerResult(context),
            const SizedBox(
              height: 45,
            ),
            _buildRowContainerHandlers()
          ],
        ),
      ),
    );
  }

  Row _buildRowContainerHandlers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                _shareQrCodeScanner();
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
                  fontSize: 14),
            ),
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: barcode));
                AppUtil.showToast('Copied to clipboard');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppConstant.customYellow,
                    borderRadius: BorderRadius.circular(6)),
                child: Icon(
                  Icons.copy_rounded,
                  color: AppConstant.customBlack,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Copy',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                color: AppConstant.customWhite,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _buildContainerResult(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: AppConstant.customWhite,
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/qr_code.png',
                fit: BoxFit.cover,
                height: 50,
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: AppConstant.customBlack,
                        fontSize: 18),
                  ),
                  Text(
                    _buildOnTime(),
                    style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: AppConstant.customBlack,
                        fontSize: 12),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: AppConstant.customBlack,
          ),
          Text(
            barcode.toString(),
            style: const TextStyle(fontFamily: 'NotoSerif', fontSize: 12),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => QrCodeShowScreen(
                              barcode: barcode,
                            )));
              },
              child: Text(
                'ShowQrCode',
                style: TextStyle(
                    fontFamily: 'NotoSerif',
                    color: AppConstant.customYellow,
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _shareQrCodeScanner() async {
    try {
      final qrValidation = QrPainter(
        data: barcode,
        version: QrVersions.auto,
        gapless: false,
        color: AppConstant.customBlack,
        emptyColor: AppConstant.customWhite,
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

  Widget buildAppBar(context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()));
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
            'Result',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              color: AppConstant.customWhite,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }

  String _buildOnTime() {
    DateTime now = DateTime.now();
    String realTime = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    return realTime;
  }
}
