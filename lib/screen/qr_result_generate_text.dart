import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/core/app_util.dart';
import 'package:qr_app/core/share_data.dart';
import 'package:qr_app/dashboard_screen.dart';
import 'package:qr_app/screen/qr_code_show_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrResultGenerateText extends StatelessWidget {
  const QrResultGenerateText({super.key, required this.barcode, this.time});

  final String barcode;
  final String? time;

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
              const SizedBox(height: 30),
              _buildScannerData(context),
              const SizedBox(height: 45),
              buildContainerHandler(),
            ],
          ),
        ),
      ),
    );
  }

  Row buildContainerHandler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                ShareData.shareQrCodeScanner(barcode);
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
            const SizedBox(height: 6),
            Text(
              'Share',
              style: TextStyle(
                  fontFamily: 'NotoSerif',
                  color: AppConstant.customWhite,
                  fontSize: 14),
            ),
          ],
        ),
        const SizedBox(width: 50),
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
            const SizedBox(height: 6),
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

  Container _buildScannerData(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: AppConstant.customWhite,
        borderRadius: BorderRadius.circular(6),
      ),
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
              const SizedBox(width: 16),
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
                   time!=null? time.toString():_buildOnTime(),
                    style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: AppConstant.customBlack,
                        fontSize: 12),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: AppConstant.customBlack),
          Text(
            maxLines: null,
            barcode.toString(),
            style: const TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 15),
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
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildAppBar(Size size, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 14),
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
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: AppConstant.customYellow,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Text(
            'Result',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              color: AppConstant.customWhite,
              fontSize: 22,
            ),
          ),
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
