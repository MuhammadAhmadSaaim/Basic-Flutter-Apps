import 'package:flutter/material.dart';
import 'DBfile.dart';
import 'dart:io';
import 'EditProducts.dart';
import 'Home.dart';
import 'LogoutPage.dart';
import 'Profile.dart';
import 'widgets.dart';

class ProductsPage extends StatefulWidget {
  final int pid;
  ProductsPage({required this.pid});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];
  late int pid;

  String fname = '';
  String lname = '';
  String email = '';
  String picture = '';

  void refreshList() async {
    final data = await DatabaseHelper.getProducts(pid);
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    pid = widget.pid;
    refreshList();
    getdata();
    super.initState();
  }

  Future<void> getdata() async {
    fname = await DatabaseHelper.getFirstName(pid) ?? '';
    lname = await DatabaseHelper.getLastName(pid) ?? '';
    picture = await DatabaseHelper.getImage(pid) ?? '';
    email = await DatabaseHelper.getEmail(pid) ?? '';

    setState(() {});
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  Future<void> deleteitem(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[500],
          title: const CustomLabel(label: 'Delete Item'),
          content: const CustomLabel(label: 'Are you sure you want to delete this item?',),
          actions: [
            TextButton(
              child: const CustomLabel(label: 'Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const CustomLabel(label: 'Delete'),
              onPressed: () async {
                final deletedItem =
                    products.firstWhere((element) => element['Productcode'] == id);

                await DatabaseHelper.deleteProduct(id);
                refreshList();

                final snackBar = SnackBar(
                  content: const CustomLabel(label: 'Item deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.indigo[200],
                    onPressed: () {
                      if (deletedItem != null) {
                        DatabaseHelper.addProduct(deletedItem!['PName'],deletedItem!['PPrice'],deletedItem!['PQuantity'] ,pid);
                        refreshList();
                      }
                    },
                  ),
                  duration: const Duration(seconds: 3),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> itemdialogbox(int? id) async {
    if (id != null) {
      final available_items =
          products.firstWhere((element) => element['Productcode'] == id);
      productNameController.text = available_items['PName'] ?? '';
      productPriceController.text = available_items['PPrice'].toString() ?? '';
    } else {
      productNameController.text = '';
      productPriceController.text = '';
    }

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          EditProducts(itemId: id, pid: pid, products: products),
    ));
    productNameController.text = '';
    productPriceController.text = '';
    refreshList();
  }

  String calculateTotalPrice(String? price, String? quantity) {
    if (price != null && quantity != null) {
      final double totalPrice = double.parse(price) * int.parse(quantity);
      return totalPrice.toStringAsFixed(2);
    }
    return 'NA';
  }

  void Logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('To-Do List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Logout();
              }),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.indigo[100],
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                backgroundImage:
                picture.isNotEmpty ? FileImage(File(picture)) : null,
              ),
              accountName: Text('$fname $lname,'),
              accountEmail: Text(email),
              decoration: BoxDecoration(color: Colors.indigo[200]),
            ),
            CustomListTile(
              label: 'Home',
              icon: Icons.home,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage(pid: pid),
                  ),
                );
              },
            ),
            CustomListTile(
              label: 'Profile',
              icon: Icons.account_box,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Profilepage(pid: pid),
                  ),
                );
              },
            ),
            CustomListTile(
              label: 'Product',
              icon: Icons.square,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductsPage(pid: pid),
                  ),
                );
              },
            ),
            CustomListTile(
              label: 'Close',
              icon: Icons.close,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.indigo[200],
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Center(
              child: Text(
            'Products',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          )),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) => Card(
              color: Colors.indigo[400],
              margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: GestureDetector(
                onTap: () {
                  itemdialogbox(products[index]['Productcode']);
                },
                child: ListTile(
                  title: Text(
                    products[index]['PName'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Rs ${products[index]['PPrice'].toString() ?? 'NA'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Quantity: ${products[index]['PQuantity'].toString() ?? 'NA'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Quantity * Price: ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Rs ${calculateTotalPrice(products[index]['PPrice'].toString(), products[index]['PQuantity'].toString())}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                        ],
                      )
                    ],
                  ),
                  trailing: SizedBox(
                    width: 40,
                    child: IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteitem(products[index]['Productcode']);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          itemdialogbox(null);
        },
        icon: const Icon(Icons.add_task),
        backgroundColor: Colors.indigo,
        label: const Text('Add Product'),
      ),
    );
  }
}
