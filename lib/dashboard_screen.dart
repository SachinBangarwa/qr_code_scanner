import 'package:flutter/material.dart';
import 'package:qr_app/core/app_constant.dart';
import 'package:qr_app/screen/qr_code_screen.dart';
import 'package:qr_app/screen/qr_generate_screen.dart';
import 'package:qr_app/screen/qr_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const QrScannerScreen(),
    const QrHistoryScreen(),
    const QrGenerateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingButton(),
        bottomNavigationBar: _bottomBar(context),
        body: IndexedStack(index: _currentIndex, children: _screens));
  }

  Widget _floatingButton() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppConstant.customYellow.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 6,
          ),
          BoxShadow(
            color: AppConstant.customYellow,
            blurRadius: 50,
            spreadRadius: 6,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 0;
          });
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: AppConstant.customYellow,
        child: Image.asset(
          'assets/images/Group 10 (1).png',
          fit: BoxFit.cover,
          height: 38,
        ),
      ),
    );
  }

  Container _bottomBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 8),
      margin: EdgeInsets.only(
        bottom: size.height / 45,
        left: size.width / 16,
        right: size.width / 16,
      ),
      width: double.infinity,
      height: size.height / 9.5,
      decoration: BoxDecoration(
        color: const Color(0xE82B2B2C),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          bottom: BorderSide(
            color: AppConstant.customYellow,
            width: 3.3,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: AppConstant.customWhite,
                  size: 32,
                ),
                Text(
                  'Generate',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    color: AppConstant.customWhite,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.history_outlined,
                  color: AppConstant.customWhite,
                  size: 32,
                ),
                Text(
                  'History',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    color: AppConstant.customWhite,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
