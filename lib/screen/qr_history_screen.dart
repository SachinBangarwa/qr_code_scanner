import 'package:flutter/material.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/core/storage_helper.dart';
import 'package:qr_app/widget/qr_code_history_widget.dart';

class QrHistoryScreen extends StatefulWidget {
  const QrHistoryScreen({
    super.key,
  });

  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScanHistory();
  }

  Future getScanHistory() async {
    history = await StorageHelper.getHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getScanHistory();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.customBGC,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 140),
        child: Column(
          children: [
            _buildAppBar(size),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.86,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: AppConstant.customBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: size.height / 18,
                      decoration: BoxDecoration(
                          color:AppConstant.customYellow,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child:  Text(
                        'Scan',
                        style: TextStyle(
                          fontFamily: 'NotoSerif',
                          color: AppConstant.customWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: size.height / 18,
                      decoration: BoxDecoration(
                          color: AppConstant.customBlack,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child:  Text(
                        'Create',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'NotoSerif',
                          color: AppConstant.customWhite,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                 reverse: true,
                 padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map = history[index];
                    return QrCodeHistoryWidget(index: index,data: map,);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildAppBar(Size size) {
    return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'History',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'NotoSerif',
                    color: AppConstant.customWhite,
                    fontSize: 22,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppConstant.customYellow,
                        borderRadius: BorderRadius.circular(6)),
                    child:  Icon(
                      Icons.list_outlined,
                      color: AppConstant.customBlack,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
