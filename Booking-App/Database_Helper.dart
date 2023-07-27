import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> db() async {
    return openDatabase('BookEase11', version: 3,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> createTables(Database database) async {
    await database.execute('''
      CREATE TABLE users(
        PID INTEGER PRIMARY KEY,
        Email TEXT NOT NULL UNIQUE,
        Firstname TEXT,
        Lastname TEXT,
        CNIC INTEGER NOT NULL UNIQUE,
        PhoneNumber INTEGER,
        Country TEXT,
        Password TEXT,
        picture TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE Route(
        RID INTEGER PRIMARY KEY,
        ToLocation TEXT,
        FromLocation TEXT,
        ToDate TEXT,
        FromDate TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE Vehicle(
        VehicleID INTEGER PRIMARY KEY,
        VehicleName TEXT,
        VehicleType TEXT,
        Seats INTEGER,
        Price REAL,
        RouteID INTEGER,
        CompanyName TEXT,
        Logo TEXT,
        SeatNumbers TEXT,
        FromTime TEXT,
        FOREIGN KEY(RouteID) REFERENCES Route(RID)
      )
    ''');

    await database.execute('''
    CREATE TABLE Bookings(
      BookingID INTEGER PRIMARY KEY,
      PersonID INTEGER,
      VehicleID INTEGER,
      NoOFSeats INTEGER, 
      SeatNumbers TEXT,
      FOREIGN KEY(PersonID) REFERENCES users(PID) ON DELETE CASCADE, 
      FOREIGN KEY(VehicleID) REFERENCES Vehicle(VehicleID) ON DELETE CASCADE
    )
  ''');
  }

  static Future<int> addUser(
    String email,
    String firstname,
    String lastname,
    int cnic,
    int phoneNumber,
    String country,
    String password,
    String? imagePath,
  ) async {
    final Database db = await DatabaseHelper.db();

    final existingUsers = await db.query(
      'users',
      columns: ['PID'],
      where: 'Email = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      return -1;
    }

    final data = {
      'Email': email,
      'Firstname': firstname,
      'Lastname': lastname,
      'CNIC': cnic,
      'PhoneNumber': phoneNumber,
      'Country': country,
      'Password': password,
      'picture': imagePath,
    };

    final id = await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<void> deleteAccount(int pid) async {
    final Database db = await DatabaseHelper.db();

    final bookings = await db.query(
      'Bookings',
      columns: ['BookingID', 'VehicleID', 'NoOFSeats'],
      where: 'PersonID = ?',
      whereArgs: [pid],
    );

    for (final booking in bookings) {
      final bookingId = booking['BookingID'] as int;
      final vehicleId = booking['VehicleID'] as int;
      final noOfSeats = booking['NoOFSeats'] as int;

      final seatNumbers = await getSeatNumbersByBookingId(bookingId);

      updateVehicleSeatNumbers(vehicleId, seatNumbers);

      final currentSeats = await getTotalSeats(vehicleId);
      final newSeats = currentSeats + noOfSeats;
      await updateSeats(vehicleId, newSeats);
    }


    await db.delete(
      'Bookings',
      where: 'PersonID = ?',
      whereArgs: [pid],
    );

    // Delete the user's account
    await db.delete(
      'users',
      where: 'PID = ?',
      whereArgs: [pid],
    );
  }


  static Future<void> deleteAllUsers() async {
    final Database db = await DatabaseHelper.db();

    await db.delete('Bookings');
    await db.delete('users');
  }

  static Future<Map<String, dynamic>?> checkLogin(
      String email, String password) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['PID', 'Email', 'Password'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final user = result.first;
      if (user['Password'] == password) {
        return user;
      }
    }

    return null;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////
  static Future<String> getEmail(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['Email'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Email'] as String;
    }

    return '';
  }

  static Future<int> getPhoneNumber(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['PhoneNumber'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['PhoneNumber'] as int;
    }

    return -1;
  }

  static Future<String> getFirstname(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['Firstname'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Firstname'] as String;
    }

    return '';
  }

  static Future<String> getLastname(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['Lastname'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Lastname'] as String;
    }

    return '';
  }

  static Future<int> getCNIC(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['CNIC'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['CNIC'] as int;
    }

    return -1;
  }

  static Future<String> getCountry(int pid) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['Country'],
      where: 'PID = ?',
      whereArgs: [pid],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Country'] as String;
    }

    return '';
  }

  static Future<String?> getImage(int userId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'users',
      columns: ['picture'],
      where: 'PID = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['picture'] as String?;
    }

    return null;
  }

  static Future<void> updateProfileData({
    required int pid,
    String? firstName,
    String? lastName,
    int? phoneNumber,
    String? address,
  }) async {
    final Database db = await DatabaseHelper.db();

    final Map<String, dynamic> data = {};

    if (firstName != null) {
      data['Firstname'] = firstName;
    }

    if (lastName != null) {
      data['Lastname'] = lastName;
    }

    if (phoneNumber != null) {
      data['PhoneNumber'] = phoneNumber;
    }

    if (address != null) {
      data['Country'] = address;
    }

    if (data.isNotEmpty) {
      await db.update(
        'users',
        data,
        where: 'PID = ?',
        whereArgs: [pid],
      );
    }
  }

  static Future<void> setImage(int userId, String imagePath) async {
    final Database db = await DatabaseHelper.db();
    await db.update(
      'users',
      {'picture': imagePath},
      where: 'PID = ?',
      whereArgs: [userId],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////

  static Future<int> addRoute(String toLocation, String fromLocation,
      String toDate, String fromDate) async {
    final Database db = await DatabaseHelper.db();

    final data = {
      'ToLocation': toLocation,
      'FromLocation': fromLocation,
      'ToDate': toDate,
      'FromDate': fromDate,
    };

    final id = await db.insert(
      'Route',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<String> getToLocation(int routeId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Route',
      columns: ['ToLocation'],
      where: 'RID = ?',
      whereArgs: [routeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['ToLocation'] as String;
    }

    return '';
  }

  static Future<String> getFromLocation(int routeId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Route',
      columns: ['FromLocation'],
      where: 'RID = ?',
      whereArgs: [routeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['FromLocation'] as String;
    }

    return '';
  }

  static Future<String> getToDate(int routeId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Route',
      columns: ['ToDate'],
      where: 'RID = ?',
      whereArgs: [routeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['ToDate'] as String;
    }

    return '';
  }

  static Future<String> getFromDate(int routeId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Route',
      columns: ['FromDate'],
      where: 'RID = ?',
      whereArgs: [routeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['FromDate'] as String;
    }

    return '';
  }

  static Future<List<String>> getFromLocations() async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query('Route', columns: ['FromLocation']);
    return List.generate(
        result.length, (index) => result[index]['FromLocation'] as String);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  static Future<int> addBooking(
      int personId, int vehicleId, int noOfSeats, List<int> seatNumbers) async {
    final Database db = await DatabaseHelper.db();

    final data = {
      'PersonID': personId,
      'VehicleID': vehicleId,
      'NoOFSeats': noOfSeats,
      'SeatNumbers': jsonEncode(seatNumbers),
    };

    final id = await db.insert(
      'Bookings',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getBookingsByPersonId(
      int personId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Bookings',
      where: 'PersonID = ?',
      whereArgs: [personId],
    );
    return result;
  }


  static Future<void> cancelBooking(int bookingId) async {
    final Database db = await DatabaseHelper.db();

    final numlist = await DatabaseHelper.getSeatNumbersByBookingId(bookingId);

    final booking = await db.query(
      'Bookings',
      where: 'BookingID = ?',
      whereArgs: [bookingId],
      limit: 1,
    );

    if (booking.isNotEmpty) {
      final vehicleId = booking.first['VehicleID'] as int;
      final noOfSeats = booking.first['NoOFSeats'] as int;

      updateVehicleSeatNumbers(vehicleId, numlist);

      final currentSeats = await getTotalSeats(vehicleId);
      final newSeats = currentSeats + noOfSeats;
      await updateSeats(vehicleId, newSeats);

      await db.delete(
        'Bookings',
        where: 'BookingID = ?',
        whereArgs: [bookingId],
      );
    }
  }

  static Future<List<int>> getSeatNumbersByBookingId(int bookingId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Bookings',
      columns: ['SeatNumbers'],
      where: 'BookingID = ?',
      whereArgs: [bookingId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final seatNumbersJson = result.first['SeatNumbers'] as String;
      final seatNumbersList = jsonDecode(seatNumbersJson) as List;
      return seatNumbersList.map((seatNumber) => seatNumber as int).toList();
    }

    return [];
  }


  ///////////////////////////////////////////////////////////////////////////////////////////////
  static Future<int> addVehicle(
      String vehicleName,
      String vehicleType,
      int seats,
      double price,
      int routeId,
      String companyName,
      String logo,
      List<int> seatNumbers,
      String fromTime
      ) async {
    final Database db = await DatabaseHelper.db();

    final data = {
      'VehicleName': vehicleName,
      'VehicleType': vehicleType,
      'Seats': seats,
      'Price': price,
      'RouteID': routeId,
      'CompanyName': companyName,
      'Logo': logo,
      'SeatNumbers': jsonEncode(seatNumbers), // Encoding the list to JSON string
      'FromTime': fromTime,
    };

    final id = await db.insert(
      'Vehicle',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<String> getTime(int routeId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['FromTime'],
      where: 'VehicleID = ?',
      whereArgs: [routeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['FromTime'] as String;
    }

    return '';
  }

  static Future<String> getVehicleName(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['VehicleName'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['VehicleName'] as String;
    }

    return '';
  }

  static Future<String> getVehicleType(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['VehicleType'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['VehicleType'] as String;
    }

    return '';
  }

  static Future<int> getTotalSeats(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['Seats'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Seats'] as int;
    }

    return -1;
  }

  static Future<double> getPrice(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['Price'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Price'] as double;
    }

    return 0.0;
  }

  static Future<String> getCompanyName(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['CompanyName'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['CompanyName'] as String;
    }

    return '';
  }

  static Future<String> getVehicleLogo(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['Logo'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Logo'] as String;
    }

    return '';
  }

  static Future<List<int>> getSeatNumbers(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['SeatNumbers'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final seatNumbersJson = result.first['SeatNumbers'] as String;
      final seatNumbersList = jsonDecode(seatNumbersJson) as List;
      return seatNumbersList.map((seatNumber) => seatNumber as int).toList();
    }

    return [];
  }

  static Future<void> updateSeatNumbers(int vehicleId, List<int> seatNumbers) async {
    final Database db = await DatabaseHelper.db();

    final data = {
      'SeatNumbers': jsonEncode(seatNumbers),
    };

    await db.update(
      'Vehicle',
      data,
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
    );
  }

  static Future<void> updateVehicleSeatNumbers(int vehicleId, List<int> seatNumbers) async {
    final Database db = await DatabaseHelper.db();


    final Map<String, dynamic>? existingData = await db.query(
      'Vehicle',
      columns: ['SeatNumbers'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
    ).then((results) => results.isNotEmpty ? results.first : null);

    List<int> existingSeatNumbers = [];

    if (existingData != null && existingData['SeatNumbers'] != null) {
      List<dynamic> existingSeatNumbersJson = jsonDecode(existingData['SeatNumbers']);
      existingSeatNumbers = existingSeatNumbersJson.cast<int>();
    }

    List<int> combinedSeatNumbers = [...existingSeatNumbers, ...seatNumbers];
    combinedSeatNumbers.sort();

    final data = {
      'SeatNumbers': jsonEncode(combinedSeatNumbers),
    };

    await db.update(
      'Vehicle',
      data,
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
    );
  }

  static Future<void> updateSeats(int vehicleId, int newSeats) async {
    final Database db = await DatabaseHelper.db();

    final data = {
      'Seats': newSeats,
    };

    await db.update(
      'Vehicle',
      data,
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
    );
  }

  static Future<int> getRouteIDFromVehicleID(int vehicleId) async {
    final Database db = await DatabaseHelper.db();
    final result = await db.query(
      'Vehicle',
      columns: ['RouteID'],
      where: 'VehicleID = ?',
      whereArgs: [vehicleId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['RouteID'] as int;
    }

    return -1;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////

  static Future<void> deleteAllData() async {
    final Database db = await DatabaseHelper.db();

    await db.delete('Bookings');
    await db.delete('Vehicle');
    await db.delete('Route');
  }

}
