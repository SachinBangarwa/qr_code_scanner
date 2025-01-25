import 'package:flutter/material.dart';
import 'package:qr_app/screen/qr_result_generate_text.dart';
import '../core/app_constant.dart';
import '../core/share_data.dart';
import '../core/storage_helper.dart';

class QrCodeHistoryWidget extends StatefulWidget {
  const QrCodeHistoryWidget(
      {super.key, required this.index, required this.data});

  final int index;
  final Map<String, dynamic> data;

  @override
  State<QrCodeHistoryWidget> createState() => _QrCodeHistoryWidgetState();
}

class _QrCodeHistoryWidgetState extends State<QrCodeHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppConstant.customAlert,
                content: SizedBox(
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => QrResultGenerateText(
                                        barcode: widget.data.toString(),
                                        time: widget.data['time'],
                                      )));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image,
                              size: 28, // Icon size
                              color: AppConstant.customBlack,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'QR Code View',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.customBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppConstant.customBlack,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await ShareData.shareQrCodeScanner(widget.data);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.share,
                              size: 28, // Icon size
                              color: AppConstant.customBlack,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Share Code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.customBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.only(
          left: size.width / 15,
          right: size.width / 15,
          top: size.height / 70,
        ),
        padding: const EdgeInsets.all(10),
        width: size.width,
        decoration: BoxDecoration(
          color: AppConstant.customBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QR Code Image
            Image.asset(
              'assets/images/qr_code.png',
              fit: BoxFit.cover,
              height: 48,
              width: 48,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.data['barCode'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            color: AppConstant.customWhite,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await StorageHelper.deleteHistory(widget.index);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.data['label'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            color: AppConstant.lightGrey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.data["time"],
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NotoSerif',
                            color: AppConstant.lightGrey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
