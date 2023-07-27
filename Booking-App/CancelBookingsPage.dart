import 'package:flutter/material.dart';
import 'Database_Helper.dart';
import 'widgets.dart';

class CancelBookingsPage extends StatefulWidget {
  final int pid;
  CancelBookingsPage({required this.pid});

  @override
  State<CancelBookingsPage> createState() => _CancelBookingsPageState();
}

class _CancelBookingsPageState extends State<CancelBookingsPage> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.getBookingsByPersonId(widget.pid);
    setState(() {
      bookings = result;
    });
  }

  cancelBooking(int bookingId) async {
    await DatabaseHelper.cancelBooking(bookingId);
    _fetchBookings();
  }

  void _showConfirmationDialog(int bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text('Are you sure you want to cancel your booking?', style: TextStyle(fontSize:15,),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                cancelBooking(bookingId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'BookEase',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Text(
                'There are no current bookings available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(booking);
              },
            ),
      bottomNavigationBar: CustomBackButton(),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final int personId = booking['PersonID'] ?? 'NA';
    final int vehicleId = booking['VehicleID'] ?? 'NA';
    final int numberOfSeats = booking['NoOFSeats'] ?? 'NA';

    return Card(
      elevation: 4,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: DatabaseHelper.getFirstname(personId),
              builder: (context, snapshot) {
                final firstname = snapshot.data ?? 'N/A';
                return FutureBuilder<String>(
                  future: DatabaseHelper.getLastname(personId),
                  builder: (context, snapshot) {
                    final lastname = snapshot.data ?? 'N/A';
                    return Center(
                      child: Text(
                        '$firstname $lastname',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<int>(
                  future: DatabaseHelper.getRouteIDFromVehicleID(vehicleId),
                  builder: (context, snapshot) {
                    final routeId = snapshot.data ?? -1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<String>(
                          future: DatabaseHelper.getFromLocation(routeId),
                          builder: (context, snapshot) {
                            final fromLocation = snapshot.data ?? 'N/A';
                            return Text('$fromLocation');
                          },
                        ),
                        const Icon(Icons.arrow_right_alt), // Arrow Icon
                        FutureBuilder<String>(
                          future: DatabaseHelper.getToLocation(routeId),
                          builder: (context, snapshot) {
                            final toLocation = snapshot.data ?? 'N/A';
                            return Text(' $toLocation');
                          },
                        ),
                      ],
                    );
                  },
                ),

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    Text('Seats: $numberOfSeats '),
                    FutureBuilder<List<int>>(
                      future: DatabaseHelper.getSeatNumbersByBookingId(booking['BookingID']),
                      builder: (context, snapshot) {
                        final seatNumber = snapshot.data ?? 'N/A';
                        return Text('$seatNumber');
                      },
                    ),
                  ],
                ),
                const Spacer(),
                FutureBuilder<int>(
                  future: DatabaseHelper.getRouteIDFromVehicleID(vehicleId),
                  builder: (context, snapshot) {
                    final routeId = snapshot.data ?? -1;
                    return FutureBuilder<String>(
                      future: DatabaseHelper.getFromDate(routeId),
                      builder: (context, snapshot) {
                        final fromDate = snapshot.data ?? 'N/A';
                        return Text('$fromDate');
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ID: ${booking['BookingID']}'),
                const Spacer(),
                FutureBuilder<String>(
                  future: DatabaseHelper.getVehicleName(vehicleId),
                  builder: (context, snapshot) {
                    final vehicleName = snapshot.data ?? 'N/A';
                    return Text(
                      '$vehicleName',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    );
                  },
                ),
                const Spacer(),
                FutureBuilder<String>(
                  future: DatabaseHelper.getVehicleType(vehicleId),
                  builder: (context, snapshot) {
                    final vehicleType = snapshot.data ?? 'N/A';
                    if (vehicleType == 'Bus') {
                      return const Icon(Icons.directions_bus,
                          color: Colors.black);
                    } else if (vehicleType == 'Plane') {
                      return const Icon(Icons.airplanemode_active,
                          color: Colors.black);
                    } else {
                      return Text('Vehicle: $vehicleType');
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String>(
                  future: DatabaseHelper.getVehicleLogo(vehicleId), // Fetch the vehicle logo using the vehicleId
                  builder: (context, snapshot) {
                    final logoImagePath = snapshot.data;
                    if (snapshot.hasData && logoImagePath != null) {
                      return Image.asset(
                        logoImagePath,
                        width: 100,
                        height: 50,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomElevatedButton(
              text: 'Cancel Booking',
              onPressed: () {
                _showConfirmationDialog(booking['BookingID']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
