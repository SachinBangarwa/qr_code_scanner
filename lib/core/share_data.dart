import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'app_constant.dart';
import 'app_util.dart';

class ShareData {
  static Future<void> shareQrCodeScanner(barCode) async {
    try {
      final qrValidation = QrPainter(
        data: barCode.toString(),
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

        await Share.shareFiles([imagePath], text: barCode.toString());
      } else {
        AppUtil.showToast('Failed to generate QR code image.');
      }
    } catch (e) {
      AppUtil.showToast('Error while sharing QR code: $e');
    }
  }
}
