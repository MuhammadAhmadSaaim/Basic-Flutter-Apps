import 'LogoutPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'CancelBookingsPage.dart';
import 'package:flutter/material.dart';
import 'BookingsPage.dart';
import 'CategorySelection.dart';
import 'Database_Helper.dart';
import 'widgets.dart';
import 'ProfilePage.dart';

class Home_page extends StatefulWidget {
  final int pid;
  Home_page({required this.pid});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  late int pid;
  String firstName = '';
  String lastName = '';
  int phoneNumber = 0;

  final List<String> carouselItems = [
    'assets/Images/image1.jpg',
    'assets/Images/image2.jpg',
    'assets/Images/image3.jpg',
  ];

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pid = widget.pid;
    getdata();
  }

  Future<void> getdata() async {
    firstName = await DatabaseHelper.getFirstname(pid);
    lastName = await DatabaseHelper.getLastname(pid);
    phoneNumber = await DatabaseHelper.getPhoneNumber(pid);

    nameController.text = firstName + ' ' + lastName;
    phoneNumController.text = '+' + phoneNumber.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LogoutDialog();
          },
        );
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: const Text(
              'BookEase',
              style: TextStyle(fontSize: 30),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        enlargeCenterPage: true,
                      ),
                      items: carouselItems.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners here
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: nameController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: phoneNumController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          buttonText: 'Bookings',
                          iconData: Icons.calendar_month,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BookingsPage(pid: widget.pid),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          buttonText: 'Book Tickets',
                          iconData: Icons.book_online,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Category_Selection_page(pid: widget.pid),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          buttonText: 'Cancel',
                          iconData: Icons.cancel_schedule_send,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CancelBookingsPage(pid: widget.pid),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        CustomButton(
                          buttonText: 'Profile',
                          iconData: Icons.settings,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfilePage(pid: widget.pid),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          buttonText: 'Logout',
                          iconData: Icons.logout,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LogoutDialog();
                              },
                            );
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
