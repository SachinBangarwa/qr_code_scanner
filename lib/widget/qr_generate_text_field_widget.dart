import 'package:flutter/material.dart';
import 'package:qr_app/core/app_constant.dart';

class QrGenerateTextFieldWidget extends StatelessWidget {
  const QrGenerateTextFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.inputType,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextInputType inputType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppConstant.customWhite,
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
              style: TextStyle(
                color: AppConstant.customWhite,
                fontFamily: 'NotoSerif',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppConstant.customWhite),
                ),
                contentPadding: const EdgeInsets.only(bottom: 12, left: 14),
                hintStyle: TextStyle(
                  color: AppConstant.lightGrey,
                  fontSize: 10,
                  fontFamily: 'NotoSerif',
                ),
                hintText: hint,
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppConstant.customWhite, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
