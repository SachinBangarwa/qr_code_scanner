import 'package:flutter/material.dart';
import 'package:qr_app/qr_generate_model.dart';
import 'package:qr_app/qr_result_screen2.dart';

import 'core/form_field.dart';
import 'core/storage_helper.dart';

class QrGenerateCodeScreen extends StatefulWidget {
  const QrGenerateCodeScreen({super.key, required this.qrModel});

  final QrGenerateModel qrModel;

  @override
  State<QrGenerateCodeScreen> createState() => _QrGenerateCodeScreenState();
}

class _QrGenerateCodeScreenState extends State<QrGenerateCodeScreen> {
  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllerHandle();
  }

  void controllerHandle() {
    final fields = formFields[widget.qrModel.name] ?? [];
    controllers.addAll(fields.map((_) => TextEditingController()));
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = formFields[widget.qrModel.name] ?? [];
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Color.fromRGBO(253, 182, 35, .9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      widget.qrModel.name,
                      style: const TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                        border: const Border.symmetric(
                            horizontal: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(253, 182, 35, .9),
                            ))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: IconTheme(
                            data: const IconThemeData(
                              size: 50,
                            ),
                            child: widget.qrModel.icon,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            ...fields
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              var value = entry.value;

                              if (value['isRow'] == true) {
                                if (index + 1 < fields.length) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          label: value['label'],
                                          hint: value['hint'],
                                          inputType: value['inputType'],
                                          controller: controllers[index],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _buildTextField(
                                          label: fields[index + 1]['label'],
                                          hint: fields[index + 1]['hint'],
                                          inputType: fields[index +
                                              1]['inputType'],
                                          controller: controllers[index + 1],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                              if (index > 0 &&
                                  fields[index - 1]['isRow'] == true) {
                                return const SizedBox();
                              }
                              return _buildTextField(
                                label: value['label'],
                                hint: value['hint'],
                                inputType: value['inputType'],
                                controller: controllers[index],
                              );
                            }),
                           const SizedBox(height: 10,),
                            GestureDetector(
                              onTap:(){ _qrGenerateHandle(context);},
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color.fromRGBO(253, 182, 35, .9),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 12,
                                  ),
                                  child: const Text(
                                    'Generate QR Code',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'NotoSerif',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _qrGenerateHandle(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(seconds: 1));
    Map<String, String> formData = {};
    final fields = formFields[widget.qrModel.name] ?? [];
    for (int i = 0; i < controllers.length; i++) {
      formData[fields[i]['label']] = controllers[i].text;
    }

    if (formData.values.any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QrResultScreen2(
              barcode: formData.toString(),
            ),
      ),
    );
    await StorageHelper.saveHistory(formData.toString());
  }
}

Widget _buildTextField({
  required String label,
  required String hint,
  required TextInputType inputType,
  required TextEditingController controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'NotoSerif',
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 35,
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'NotoSerif',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.only(bottom: 12, left: 14),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'NotoSerif',
              ),
              hintText: hint,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
