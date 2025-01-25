import 'package:flutter/material.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/screen/qr_result_generate_text.dart';
import 'package:qr_app/widget/qr_generate_text_field_widget.dart';
import '../core/form_field.dart';
import '../core/storage_helper.dart';
import '../model/qr_generate_model.dart';


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
    return Scaffold(
      backgroundColor: AppConstant.customBGC,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppConstant.lightBlack,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.symmetric(
                            horizontal: BorderSide(
                          width: 2,
                          color: AppConstant.customYellow,
                        ))),
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
                        _buildTextFormField()
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding:const EdgeInsets.all(6),
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
            widget.qrModel.name,
            style: TextStyle(
              fontFamily: 'NotoSerif',
              color: AppConstant.customWhite,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextFormField() {
    final fields = formFields[widget.qrModel.name] ?? [];
    return Column(
      children: [
        ...fields.asMap().entries.map((entry) {
          int index = entry.key;
          var value = entry.value;

          if (value['isRow'] == true) {
            if (index + 1 < fields.length) {
              return Row(
                children: [
                  Expanded(
                    child: QrGenerateTextFieldWidget(
                      label: value['label'],
                      hint: value['hint'],
                      inputType: value['inputType'],
                      controller: controllers[index],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: QrGenerateTextFieldWidget(
                      label: fields[index + 1]['label'],
                      hint: fields[index + 1]['hint'],
                      inputType: fields[index + 1]['inputType'],
                      controller: controllers[index + 1],
                    ),
                  ),
                ],
              );
            }
          }
          if (index > 0 && fields[index - 1]['isRow'] == true) {
            return const SizedBox();
          }
          return QrGenerateTextFieldWidget(
            label: value['label'],
            hint: value['hint'],
            inputType: value['inputType'],
            controller: controllers[index],
          );
        }),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            _qrGenerateHandle(context);
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppConstant.customYellow,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              child: Text(
                'Generate QR Code',
                style: TextStyle(
                  color: AppConstant.customBlack,
                  fontSize: 12,
                  fontFamily: 'NotoSerif',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _qrGenerateHandle(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 500));

    Map<String, dynamic> formData = {};

    final fields = formFields[widget.qrModel.name] ?? [];
    for (int i = 0; i < fields.length; i++) {
      final value = controllers.length > i ? controllers[i].text : '';
      formData[fields[i]['label']] = value.trim();
    }

    if (formData.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the fields'),
          ),
        );
      }
      return;
    }

    String formattedData = formData.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');

    await StorageHelper.saveHistory(
      formattedData,
      widget.qrModel.name,
    );

    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultGenerateText(
            barcode: formattedData,
          ),
        ),
      );
    }
  }
}
