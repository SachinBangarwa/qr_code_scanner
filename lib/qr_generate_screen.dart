import 'package:flutter/material.dart';
import 'package:qr_app/qr_generate_model.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.only(top: 70, bottom: 155),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
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
                        color: Colors.yellow,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: QrGenerateModel.content.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    QrGenerateModel qrModel = QrGenerateModel.content[index];
                    return Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black,
                                border:
                                    Border.all(color: Colors.yellow, width: 2)),
                            alignment: Alignment.center,
                            child: qrModel.icon),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 90, left: 36, right: 36, top: 20),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(2)),
                          alignment: Alignment.center
                          child: Text(
                            qrModel.name,
                            style: const TextStyle(
                              fontFamily: 'NotoSerif',
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
