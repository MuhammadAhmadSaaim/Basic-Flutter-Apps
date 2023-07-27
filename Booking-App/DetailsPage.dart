import 'package:flutter/material.dart';
import 'Database_Helper.dart';
import 'HomePage.dart';
import 'package:flutter/services.dart';
import 'widgets.dart';

class DetailsPage extends StatefulWidget {
  final int pid;
  final int vehicleId;

  DetailsPage({required this.pid, required this.vehicleId});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController priceController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController selectedseatsController = TextEditingController();
  String vehicleName = '';
  int seats = 0;
  double price = 0.0;
  double totalPrice = 0.0;
  int maxAvailableSeats = 0;
  bool seatsEntered = false;
  late int seatLimiter;
  bool areSeatsSelected = false;

  List<int> selectedSeatsnumbers = [];
  late List<int> availableSeatnumbers = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void removeAllFromList(List<int> sourceList, List<int> elementsToRemove) {
    sourceList.removeWhere((element) => elementsToRemove.contains(element));
  }

  void updateSeatSelection(int seatNumber) {
    setState(() {
      if (selectedSeatsnumbers.contains(seatNumber)) {
        selectedSeatsnumbers.remove(seatNumber);
      } else if (selectedSeatsnumbers.length < seatLimiter) {
        selectedSeatsnumbers.add(seatNumber);
      }
      selectedSeatsnumbers.sort();
      print('A List: $availableSeatnumbers');
      print('S List: $selectedSeatsnumbers');
    });
  }

  Future<void> getData() async {
    priceController.text = 'Price: ';
    seats = await DatabaseHelper.getTotalSeats(widget.vehicleId);
    updateSeatsControllerText();
    price = await DatabaseHelper.getPrice(widget.vehicleId);
    vehicleName = await DatabaseHelper.getVehicleName(widget.vehicleId);
    availableSeatnumbers = await DatabaseHelper.getSeatNumbers(widget.vehicleId);
    setState(() {});
  }

  void updateSeatsControllerText() {
    seatsController.text = 'Available Seats: ' + seats.toString();
    calculateTotalPrice(seats.toString());
  }

  void calculateTotalPrice(String value) async {
    final numSeats = int.tryParse(value) ?? 0;
    int seats2 = await DatabaseHelper.getTotalSeats(widget.vehicleId);
    totalPrice = price * (seats2 - numSeats);
    priceController.text = 'Price: ' + totalPrice.toString();
  }

  void addBookings() async {
    if(selectedSeatsnumbers.length == seatLimiter) {
      removeAllFromList(availableSeatnumbers, selectedSeatsnumbers);
      availableSeatnumbers.sort();
      print(('List: $availableSeatnumbers'));

      DatabaseHelper.updateSeatNumbers(widget.vehicleId, availableSeatnumbers);

      final numSeats = int.tryParse(selectedseatsController.text) ?? 0;
      if (numSeats > 0) {
        final bookingId = await DatabaseHelper.addBooking(
            widget.pid, widget.vehicleId, numSeats ,selectedSeatsnumbers);

        if (bookingId != -1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bookings added successfully!',
                  style: TextStyle(color: Colors.white)),
            ),
          );

          final newSeats =
              await DatabaseHelper.getTotalSeats(widget.vehicleId) - numSeats;
          await DatabaseHelper.updateSeats(widget.vehicleId, newSeats);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => Home_page(pid: widget.pid),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking failed. Please try again later.'),
            ),
          );
        }
      }
    }
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  vehicleName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: selectedseatsController,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: 'Enter number of seats: ',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: '1-3',
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[1-3]')),
                    LengthLimitingTextInputFormatter(1),
                  ],
                  onChanged: (value) async {
                    final numSeats = int.tryParse(value) ?? 0;
                    seatLimiter = numSeats;
                    selectedSeatsnumbers.clear();
                    seats = await DatabaseHelper.getTotalSeats(widget.vehicleId) -
                        numSeats;
                    updateSeatsControllerText();
                    setState(() {
                      seatsEntered = numSeats > 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of seats.';
                    }
                    final numSeats = int.tryParse(value);
                    if (numSeats == null || numSeats <= 0) {
                      return 'Please enter a valid number of seats.';
                    }
                    if (numSeats > 3) {
                      return 'You can only buy up to 3 seats.';
                    }
                    if (seats <= 0) {
                      return 'No seats available for booking.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: false,
                  controller: seatsController,
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
                const SizedBox(height: 10,),
                if (seatsEntered)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: availableSeatnumbers.length,
                    itemBuilder: (context, index) {
                      final seatNumber = availableSeatnumbers[index];
                      final isSelected = selectedSeatsnumbers.contains(seatNumber);

                      return GestureDetector(
                        onTap: () {
                          updateSeatSelection(seatNumber);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                            isSelected ? Colors.black : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              seatNumber.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 10,),
                TextFormField(
                  enabled: false,
                  controller: priceController,
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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    addBookings();
                  },
                  child: const Text(
                    'Add Booking',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
