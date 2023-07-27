import 'dart:convert';

import 'package:flutter/material.dart';
import 'database_helper.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<int> numbersList120 = [];
  List<int> numbersList30 = [];

  @override
  void initState() {
    super.initState();
    assignnumbers();
    printData();
  }

  void printData() async{
    final db = await DatabaseHelper.db();

    // Fetch data from the "users" table
    final List<Map<String, dynamic>> users = await db.query('users');

    // Print the data
    print('Users Table Data:');
    users.forEach((user) {
      print('PID: ${user['PID']}');
      print('Email: ${user['Email']}');
      print('Firstname: ${user['Firstname']}');
      print('Lastname: ${user['Lastname']}');
      print('CNIC: ${user['CNIC']}');
      print('PhoneNumber: ${user['PhoneNumber']}');
      print('Country: ${user['Country']}');
      print('Password: ${user['Password']}');
      print('picture: ${user['picture']}');
      print('----------------------');
    });

    final List<Map<String, dynamic>> routes = await db.query('Route');

    print('Route Table Data:');
    routes.forEach((route) {
      print('RID: ${route['RID']}');
      print('ToLocation: ${route['ToLocation']}');
      print('FromLocation: ${route['FromLocation']}');
      print('ToDate: ${route['ToDate']}');
      print('FromDate: ${route['FromDate']}');
      print('FromTime: ${route['FromTime']}');
      print('----------------------');
    });

    final List<Map<String, dynamic>> vehicles = await db.query('Vehicle');

    print('Vehicle Table Data:');
    vehicles.forEach((vehicle) {
      print('VehicleID: ${vehicle['VehicleID']}');
      print('VehicleName: ${vehicle['VehicleName']}');
      print('VehicleType: ${vehicle['VehicleType']}');
      print('Seats: ${vehicle['Seats']}');
      print('Price: ${vehicle['Price']}');
      print('RouteID: ${vehicle['RouteID']}');
      print('CompanyName: ${vehicle['CompanyName']}');
      print('Logo: ${vehicle['Logo']}');
      final seatNumbersJson = vehicle['SeatNumbers'] as String;
      final seatNumbersList = jsonDecode(seatNumbersJson) as List;
      print('SeatNumbers: $seatNumbersList');
      print('----------------------');
    });

    final List<Map<String, dynamic>> bookings = await db.query('Bookings');

    print('Bookings Table Data:');
    bookings.forEach((booking) {
      print('BookingID: ${booking['BookingID']}');
      print('PersonID: ${booking['PersonID']}');
      print('VehicleID: ${booking['VehicleID']}');
      print('NoOFSeats: ${booking['NoOFSeats']}');
      final seatNumbersJson = booking['SeatNumbers'] as String;
      final seatNumbersList = jsonDecode(seatNumbersJson) as List;
      print('SeatNumbers: $seatNumbersList');
      print('----------------------');
    });

    // Close the database
    await db.close();
  }

  void assignnumbers() {
    for (int i = 1; i <= 120; i++) {
      numbersList120.add(i);
    }
    for (int i = 1; i <= 30; i++) {
      numbersList30.add(i);
    }
    setState(() {});
  }

  @override
  void addRouteAndVehicle() async {
    final String piaLogo = "assets/Images/pia.png";
    final String daewooLogo = "assets/Images/daewoo.png";
    final String qatarAirwaysLogo = "assets/Images/qatarairways.png";
    final String skywaysLogo = "assets/Images/skyways.png";

    int routeId1 = await DatabaseHelper.addRoute(
        'Islamabad', 'Lahore', '2023-07-27', '2023-07-27');

    int routeId2 = await DatabaseHelper.addRoute(
        'Islamabad', 'Karachi', '2023-07-27', '2023-07-27');

    int routeId3 = await DatabaseHelper.addRoute(
        'Islamabad', 'Multan', '2023-07-27', '2023-07-27');

    int routeId4 = await DatabaseHelper.addRoute(
        'Karachi', 'Lahore', '2023-07-30', '2023-07-30');

    int routeId5 = await DatabaseHelper.addRoute(
        'Karachi', 'Islamabad', '2023-07-30', '2023-07-30');

    int routeId6 = await DatabaseHelper.addRoute(
        'Karachi', 'Multan', '2023-07-30', '2023-07-30');

    int routeId7 = await DatabaseHelper.addRoute(
        'Lahore', 'Islamabad', '2023-07-27', '2023-07-27');

    int routeId8 = await DatabaseHelper.addRoute(
        'Lahore', 'Karachi', '2023-07-30', '2023-07-30');

    int routeId9 = await DatabaseHelper.addRoute(
        'Lahore', 'Multan', '2023-07-28', '2023-07-28');

    int routeId10 = await DatabaseHelper.addRoute(
        'Multan', 'Lahore', '2023-07-27', '2023-07-27');

    int routeId11 = await DatabaseHelper.addRoute(
        'Multan', 'Karachi', '2023-07-29', '2023-07-29');

    int routeId12 = await DatabaseHelper.addRoute(
        'Multan', 'Islamabad', '2023-07-29', '2023-07-29');



    int vehicleId1 = await DatabaseHelper.addVehicle('DAE-101', 'Bus', 30, 2000.0, routeId1, 'Daewoo', daewooLogo, numbersList30, '12:00');
    int vehicleId2 = await DatabaseHelper.addVehicle('SKY-921', 'Bus', 30, 2000.0, routeId2, 'Skyways', skywaysLogo, numbersList30, '9:30');
    int vehicleId3 = await DatabaseHelper.addVehicle('DAE-110', 'Bus', 30, 4000.0, routeId3, 'Daewoo', daewooLogo, numbersList30, '9:30');
    int vehicleId4 = await DatabaseHelper.addVehicle('SKY-101', 'Bus', 30, 2800.0, routeId4, 'Skyways', skywaysLogo, numbersList30, '17:30');
    int vehicleId5 = await DatabaseHelper.addVehicle('DAE-202', 'Bus', 30, 2200.0, routeId5, 'Daewoo', daewooLogo, numbersList30, '9:00');
    int vehicleId6 = await DatabaseHelper.addVehicle('DAE-222', 'Bus', 30, 3500.0, routeId6, 'Daewoo', daewooLogo, numbersList30, '13:30');
    int vehicleId7 = await DatabaseHelper.addVehicle('DAE-303', 'Bus', 30, 2600.0, routeId7, 'Daewoo', daewooLogo, numbersList30, '10:00');
    int vehicleId8 = await DatabaseHelper.addVehicle('SKY-222', 'Bus', 30, 2900.0, routeId8, 'Skyways', skywaysLogo, numbersList30, '14:00');
    int vehicleId9 = await DatabaseHelper.addVehicle('SKY-333', 'Bus', 30, 2700.0, routeId9, 'Skyways', skywaysLogo, numbersList30, '11:30');
    int vehicleId10 = await DatabaseHelper.addVehicle('SKY-444', 'Bus', 30, 3100.0, routeId10, 'Skyways', skywaysLogo, numbersList30, '15:00');
    int vehicleId11 = await DatabaseHelper.addVehicle('SKY-555', 'Bus', 30, 3000.0, routeId11, 'Skyways', skywaysLogo, numbersList30, '12:30');
    int vehicleId12 = await DatabaseHelper.addVehicle('SKY-666', 'Bus', 30, 3200.0, routeId12, 'Skyways', skywaysLogo, numbersList30, '16:30');
    int vehicleId25 = await DatabaseHelper.addVehicle('SKY-111', 'Bus', 30, 2500.0, routeId1, 'Skyways', skywaysLogo, numbersList30, '14:00');
    int vehicleId26 = await DatabaseHelper.addVehicle('DAE-999', 'Bus', 30, 2600.0, routeId2, 'Daewoo', daewooLogo, numbersList30, '15:30');
    int vehicleId27 = await DatabaseHelper.addVehicle('DAE-777', 'Bus', 30, 2700.0, routeId3, 'Daewoo', daewooLogo, numbersList30, '17:00');
    int vehicleId28 = await DatabaseHelper.addVehicle('SKY-777', 'Bus', 30, 2900.0, routeId4, 'Skyways', skywaysLogo, numbersList30, '14:30');
    int vehicleId29 = await DatabaseHelper.addVehicle('DAE-888', 'Bus', 30, 2400.0, routeId5, 'Daewoo', daewooLogo, numbersList30, '16:00');
    int vehicleId30 = await DatabaseHelper.addVehicle('SKY-888', 'Bus', 30, 3000.0, routeId6, 'Skyways', skywaysLogo, numbersList30, '17:30');
    int vehicleId31 = await DatabaseHelper.addVehicle('DAE-999', 'Bus', 30, 2200.0, routeId7, 'Daewoo', daewooLogo, numbersList30, '19:00');
    int vehicleId32 = await DatabaseHelper.addVehicle('SKY-999', 'Bus', 30, 3100.0, routeId8, 'Skyways', skywaysLogo, numbersList30, '20:30');
    int vehicleId33 = await DatabaseHelper.addVehicle('DAE-777', 'Bus', 30, 2600.0, routeId9, 'Daewoo', daewooLogo, numbersList30, '22:00');
    int vehicleId34 = await DatabaseHelper.addVehicle('SKY-666', 'Bus', 30, 2800.0, routeId10, 'Skyways', skywaysLogo, numbersList30, '23:30');



    int vehicleId13 = await DatabaseHelper.addVehicle('PIA-247', 'Plane', 120, 30000.0, routeId1, 'PIA', piaLogo, numbersList120, '16:00');
    int vehicleId14 = await DatabaseHelper.addVehicle('PIA-250', 'Plane', 120, 45000.0, routeId2, 'PIA', piaLogo, numbersList120, '18:30');
    int vehicleId15 = await DatabaseHelper.addVehicle('QTR-110', 'Plane', 120, 25000.0, routeId3, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '17:00');
    int vehicleId16 = await DatabaseHelper.addVehicle('PIA-229', 'Plane', 120, 28000.0, routeId4, 'PIA', piaLogo, numbersList120, '14:30');
    int vehicleId17 = await DatabaseHelper.addVehicle('PIA-350', 'Plane', 120, 40000.0, routeId5, 'PIA', piaLogo, numbersList120, '10:00');
    int vehicleId18 = await DatabaseHelper.addVehicle('QTR-300', 'Plane', 120, 30000.0, routeId6, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '11:30');
    int vehicleId19 = await DatabaseHelper.addVehicle('PIA-500', 'Plane', 120, 35000.0, routeId7, 'PIA', piaLogo, numbersList120, '16:00');
    int vehicleId20 = await DatabaseHelper.addVehicle('QTR-400', 'Plane', 120, 32000.0, routeId8, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '13:00');
    int vehicleId21 = await DatabaseHelper.addVehicle('PIA-600', 'Plane', 120, 38000.0, routeId9, 'PIA', piaLogo, numbersList120, '15:30');
    int vehicleId22 = await DatabaseHelper.addVehicle('QTR-500', 'Plane', 120, 35000.0, routeId10, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '12:30');
    int vehicleId23 = await DatabaseHelper.addVehicle('PIA-700', 'Plane', 120, 42000.0, routeId11, 'PIA', piaLogo, numbersList120, '19:00');
    int vehicleId24 = await DatabaseHelper.addVehicle('QTR-600', 'Plane', 120, 37000.0, routeId12, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '20:30');
    int vehicleId37 = await DatabaseHelper.addVehicle('QTR-111', 'Plane', 120, 32000.0, routeId1, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '15:00');
    int vehicleId38 = await DatabaseHelper.addVehicle('PIA-999', 'Plane', 120, 40000.0, routeId3, 'PIA', piaLogo, numbersList120, '16:30');
    int vehicleId39 = await DatabaseHelper.addVehicle('QTR-222', 'Plane', 120, 35000.0, routeId2, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '18:00');
    int vehicleId40 = await DatabaseHelper.addVehicle('PIA-777', 'Plane', 120, 38000.0, routeId1, 'PIA', piaLogo, numbersList120, '19:30');
    int vehicleId41 = await DatabaseHelper.addVehicle('QTR-333', 'Plane', 120, 30000.0, routeId6, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '21:00');
    int vehicleId42 = await DatabaseHelper.addVehicle('PIA-888', 'Plane', 120, 42000.0, routeId12, 'PIA', piaLogo, numbersList120, '22:30');
    int vehicleId43 = await DatabaseHelper.addVehicle('QTR-444', 'Plane', 120, 33000.0, routeId11, 'Qatar Airways', qatarAirwaysLogo, numbersList120, '00:00');

  }

  void removeRouteAndVehicle() async {
    DatabaseHelper.deleteAllData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          child: Text('Add Routes'),
          onPressed: addRouteAndVehicle,
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text('Remove all Routes & Vehicles'),
        onPressed: removeRouteAndVehicle,
      ),
    );
  }
}

