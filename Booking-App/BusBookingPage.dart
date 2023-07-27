import 'package:intl/intl.dart';
import 'widgets.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database_Helper.dart';
import 'DetailsPage.dart';

class BusBookingPage extends StatefulWidget {
  final int pid;
  BusBookingPage({required this.pid});

  @override
  State<BusBookingPage> createState() => _BusBookingPageState();
}

class _BusBookingPageState extends State<BusBookingPage> {
  List<Map<String, dynamic>> availableVehicles = [];

  String? _selectedFromLocation;
  String? _selectedToLocation;

  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  String? _selectedCompany;

  List<String> getAvailableCompanies() {
    return busCompanyNames;
  }

  List<String> getAvailableToLocations() {
    if (_selectedFromLocation != null) {
      return locations
          .where((location) => location != _selectedFromLocation)
          .toList();
    }
    return [];
  }

  Future<void> searchAvailableVehicles() async {
    final String? fromLocation = _selectedFromLocation;
    final String? toLocation = _selectedToLocation;

    if (fromLocation != null &&
        toLocation != null &&
        _selectedFromDate != null &&
        _selectedToDate != null) {
      final Database db = await DatabaseHelper.db();

      final result = await db.rawQuery(
        'SELECT * FROM Route WHERE FromLocation = ? AND ToLocation = ?',
        [fromLocation, toLocation],
      );

      if (result.isNotEmpty) {
        final routeId = result.first['RID'] as int;
        final List<dynamic> args = [
          routeId,
          'Bus',
          DateFormat('yyyy-MM-dd').format(_selectedFromDate!),
          DateFormat('yyyy-MM-dd').format(_selectedToDate!),
        ];

        if (_selectedCompany != null) {
          args.add(_selectedCompany);
        }

        final vehicles = await db.rawQuery(
          'SELECT * FROM Vehicle '
              'INNER JOIN Route ON Vehicle.RouteID = Route.RID '
              'WHERE Route.RID = ? '
              'AND Vehicle.VehicleType = ? '
              'AND Route.FromDate >= ? '
              'AND Route.ToDate <= ? '
              '${_selectedCompany != null ? 'AND Vehicle.CompanyName = ?' : ''}',
          args,
        );

        setState(() {
          availableVehicles = vehicles;
        });
      } else {
        setState(() {
          availableVehicles = [];
        });
      }
    }
  }

  Future<String> getFromDate(int routeId) async {
    final Database db = await DatabaseHelper.db();

    final result = await db.rawQuery(
      'SELECT FromDate FROM Route WHERE RID = ?',
      [routeId],
    );

    if (result.isNotEmpty) {
      final fromDateStr = result.first['FromDate'] as String;
      return fromDateStr;
    }
    return '';
  }

  void _resetToDateDropdown() {
    setState(() {
      _selectedToDate = null;
    });
  }

  Widget buildDatePicker(String label, DateTime? selectedDate, DateTime? minDate, ValueChanged<DateTime?> onChanged) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: minDate ?? DateTime.now(),
          firstDate: minDate ?? DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                primaryColor: Colors.black,
                colorScheme: ColorScheme.dark(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          onChanged(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              selectedDate != null ? dateFormat.format(selectedDate) : label,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVehicleList() {
    if (availableVehicles.isEmpty) {
      return const Center(
        child: Text(
          'No available routes',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: availableVehicles.length,
          itemBuilder: (context, index) {
            final vehicle = availableVehicles[index];
            final vehicleName = vehicle['VehicleName'] as String;
            final seats = vehicle['Seats'] as int;
            final price = vehicle['Price'] as double;
            final vehicleId = vehicle['VehicleID'] as int;
            final routeId = vehicle['RouteID'] as int;
            final logoURL = vehicle['Logo'] as String? ?? '';

            return FutureBuilder<String>(
              future: getFromDate(routeId),
              builder: (context, snapshot) {
                final fromDate = snapshot.data ?? '';
                return FutureBuilder(
                    future: DatabaseHelper.getTime(vehicleId),
                    builder: (context, snapshot) {
                      final fromTime = snapshot.data ?? '';
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              title: Column(
                                 children: [
                                   Row(
                                     children: [
                                       Column(
                                         children: [
                                           Image.asset(
                                             logoURL,
                                             width: 100,
                                             height: 50,
                                             fit: BoxFit.cover,
                                           ),
                                         ],
                                       ),
                                       Spacer(),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.end,
                                         children: [
                                           Text('Vehicle: $vehicleName'),
                                           Text('Price: $price'),
                                         ],
                                       )
                                     ],
                                   ),
                                   SizedBox(height: 10,),
                                   Divider(
                                     thickness: 2,
                                     color: Colors.black,
                                   ),
                                   SizedBox(height: 10,),
                                 ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text('Seats: $seats'),
                                  Spacer(),
                                  Text('Date: $fromDate'),
                                  Spacer(),
                                  Text('Time: $fromTime'),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DetailsPage(
                                      vehicleId: vehicleId,
                                      pid: widget.pid,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });
              },
            );
          },
        ),
      );
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
        actions: [
          Row(
            children: [
              Icon(
                Icons.directions_bus,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFromLocation,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFromLocation = newValue;
                          _selectedToLocation = null;
                        });
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('From'),
                        ),
                        ...locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ],
                      style: const TextStyle(color: Colors.black),
                      decoration:
                          CustomTextFieldDecoration.getInputDecoration('From'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedToLocation,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedToLocation = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('To'),
                        ),
                        ...getAvailableToLocations().map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ],
                      style: const TextStyle(color: Colors.black),
                      decoration:
                          CustomTextFieldDecoration.getInputDecoration('To'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildDatePicker('From Date', _selectedFromDate, null, (date) {
                setState(() {
                  _selectedFromDate = date;
                  _resetToDateDropdown();
                });
              }),
              const SizedBox(height: 10),
              buildDatePicker('To Date', _selectedToDate, _selectedFromDate, (date) {
                setState(() {
                  _selectedToDate = date;
                });
              }),
              const SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCompany,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCompany = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Select Company'),
                    ),
                    ...getAvailableCompanies().map((companyName) {
                      return DropdownMenuItem<String>(
                        value: companyName,
                        child: Text(companyName),
                      );
                    }).toList(),
                  ],
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  searchAvailableVehicles();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text('Search Available Routes'),
              ),
              const SizedBox(height: 20),
              buildVehicleList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
