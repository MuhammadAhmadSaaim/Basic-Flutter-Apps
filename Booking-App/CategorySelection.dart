import 'package:flutter/material.dart';
import 'BusBookingPage.dart';
import 'PlaneBookingPage.dart';
import 'widgets.dart';

class Category_Selection_page extends StatefulWidget {
  final int pid;
  Category_Selection_page({required this.pid});

  @override
  State<Category_Selection_page> createState() =>
      _Category_Selection_pageState();
}

class _Category_Selection_pageState extends State<Category_Selection_page> {
  double scale1 = 1.0;
  double scale2 = 1.0;

  void _onPlanePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PlaneBookingPage(pid: widget.pid),
      ),
    );
    print('Plane pressed');
  }

  void _onBusPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BusBookingPage(pid: widget.pid),
      ),
    );
    print('Bus pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookEase',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                'Select a Category',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 130,
                  height: 130,
                  transform: Matrix4.diagonal3Values(scale1, scale1, 1.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTapDown: (_) {
                      setState(() {
                        scale1 = 0.9;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        scale1 = 1.0;
                      });

                      _onBusPressed();
                    },
                    child: const Icon(
                      Icons.directions_bus,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 130,
                  height: 130,
                  transform: Matrix4.diagonal3Values(scale2, scale2, 1.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTapDown: (_) {
                      setState(() {
                        scale2 = 0.9;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        scale2 = 1.0;
                      });
                      _onPlanePressed();
                    },
                    child: const Icon(
                      Icons.airplanemode_active,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
