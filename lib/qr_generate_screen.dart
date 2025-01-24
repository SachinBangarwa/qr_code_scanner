import 'package:flutter/material.dart';
import 'package:qr_app/qr_generate_code_screen.dart';
import 'package:qr_app/qr_generate_model.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: Padding(
        padding: const EdgeInsets.only(top: 70, bottom: 155,left: 10,right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Generate QR',
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
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(
                        Icons.list_outlined,
                        color: Color.fromRGBO(253, 182, 35, .9),
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: QrGenerateModel.content.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  QrGenerateModel qrModel = QrGenerateModel.content[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrGenerateCodeScreen(qrModel: qrModel),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18,vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                            border: Border.all(
                              color: const Color.fromRGBO(253, 182, 35, .9),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: IconTheme(
                            data: const IconThemeData(size: 30),
                            child: qrModel.icon,
                          ),
                        ),

                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(253, 182, 35, .9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                qrModel.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'NotoSerif',
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
