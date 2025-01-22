import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_app/core/app_util.dart';
import 'package:qr_app/dashboard_screen.dart';
import 'package:qr_app/qr_code_show_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrResultScreen extends StatelessWidget {
  const QrResultScreen({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: size.width / 14,

              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => DashboardScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    'Result',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.86,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
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
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                                fontFamily: 'NotoSerif',
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          Text(
                            _buildOnTime(),
                            style: TextStyle(
                                fontFamily: 'NotoSerif',
                                color: Colors.black,
                                fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    barcode.toString(),
                    style: TextStyle(fontFamily: 'NotoSerif', fontSize: 12),
                  ),
                  SizedBox(
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
                            fontFamily: 'NotoSerif', color: Color(0xFFF1A405),fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _shareQrCodeScanner();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
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
                        fontFamily: 'NotoSerif', color: Colors.white,fontSize: 14),),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: ()async{
                      await Clipboard.setData(ClipboardData(text: barcode));
                    AppUtil.showToast('Copied to clipboard');
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
                          Icons.copy_rounded,
                          color: Colors.black,
                          size: 34,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text('Copy',   style: TextStyle(
                        fontFamily: 'NotoSerif', color: Colors.white,fontSize: 14,),),
                  ],
                ),
              ],
            )
          ],
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


  String _buildOnTime() {
    DateTime now = DateTime.now();
    String realTime = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    return realTime;
  }
}
