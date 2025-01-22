import 'package:flutter/material.dart';
import 'package:qr_app/core/storage_helper.dart';

class QrHistoryScreen extends StatefulWidget {
  const QrHistoryScreen({
    super.key,
  });

  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> {
  List<String> scanList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScanHistory();
  }

  Future getScanHistory() async {
    scanList = await StorageHelper.getHistory();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    getScanHistory();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.only(top: 70, bottom: 155),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width / 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'NotoSerif',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(
                        Icons.list_outlined,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.86, // Proper width constraint
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: size.height / 18,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: const Text(
                        'Scan',
                        style: TextStyle(
                          fontFamily: 'NotoSerif',
                          color: Colors.red,
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
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: Text(
                        'Create',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'NotoSerif',
                          color: Colors.red,
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
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemCount: scanList.length,
                  itemBuilder: (context, index) {
                    String entry = scanList[index];
                    int spaceIndex = entry.indexOf(' ');
                    String barcode = 'Unknown';
                    String time = 'Unknown';
                    if (spaceIndex != -1) {
                      barcode = entry.substring(0, spaceIndex);
                      time = entry.substring(spaceIndex + 1);
                    }
                    return Container(
                      margin: EdgeInsets.only(
                        left: size.width / 15,
                        right: size.width / 15,
                        top: size.height / 80,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 16, top: 12, bottom: 12, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/qr_code.png',
                            fit: BoxFit.cover,
                            height: 48,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.55,
                                    height: 25,
                                    child: Text(
                                      barcode,
                                      style: TextStyle(
                                        fontFamily: 'NotoSerif',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await StorageHelper.deleteHistory(index);
                                      setState(() {

                                      });
                                    },
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.yellow,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Data',
                                    maxLines: 1,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: 'NotoSerif',
                                        color: Colors.grey,
                                        fontSize: 10),
                                  ),
                                  SizedBox(
                                    width: size.width / 3.7,
                                  ),
                                  SizedBox(
                                    width: 122,
                                    child: Text(
                                      time,
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NotoSerif',
                                          color: Colors.grey,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
