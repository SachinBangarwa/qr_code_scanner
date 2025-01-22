import 'package:flutter/material.dart';
import 'package:qr_app/qr_code_screen.dart';
import 'package:qr_app/qr_generate_screen.dart';
import 'package:qr_app/qr_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
     QrScannerScreen(),
    QrHistoryScreen(),
    QrGenerateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFDB623).withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: Color(0xFFFDB623).withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 10,
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
          backgroundColor: const Color(0xFFFDB623),
          child: Image.asset(
            'assets/images/Group 10 (1).png',
            fit: BoxFit.cover,
            height: 38,
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens
      )
    );
  }

  Container _bottomBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 8),
      margin: EdgeInsets.only(
        bottom: size.height / 45,
        left: size.width / 14,
        right: size.width / 14,
      ),
      width: double.infinity,
      height: size.height / 10,
      decoration: BoxDecoration(
        color: const Color(0xE82B2B2C),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFDB623),
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
                  color: Colors.white,
                  size: 34,
                ),
                Text(
                  'Generate',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    color: Colors.white,
                    fontSize: 16,
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
              children: const [
                Icon(
                  Icons.history_outlined,
                  color: Colors.white,
                  size: 34,
                ),
                Text(
                  'History',
                  style: TextStyle(
                    fontFamily: 'NotoSerif',
                    color: Colors.white,
                    fontSize: 16,
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
