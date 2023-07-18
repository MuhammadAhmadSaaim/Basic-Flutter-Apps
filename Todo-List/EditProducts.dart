import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DBfile.dart';
import 'widgets.dart';

class EditProducts extends StatefulWidget {
  final int? itemId;
  final int pid;
  List<Map<String, dynamic>> products;

  EditProducts({this.itemId, required this.pid, required this.products});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      final item = widget.products.firstWhere(
              (element) => element['Productcode'] == widget.itemId);
      productNameController.text = item['PName'];
      productPriceController.text = item['PPrice'].toString();
      productQuantityController.text = item['PQuantity'].toString();
    }
  }

  void refreshList() async {
    final data = await DatabaseHelper.getTasks(widget.pid);
    setState(() {
      widget.products = data;
    });
  }

  Future<void> saveitem() async {
    if (productPriceController.text.isNotEmpty &&
        productNameController.text.isNotEmpty) {
      if (widget.itemId == null) {
        double productPrice = double.parse(productPriceController.text);
        int productQuantity = int.parse(productQuantityController.text);
        await DatabaseHelper.addProduct(
            productNameController.text.trim(),
            productPrice,
            productQuantity,
            widget.pid);
      } else {
        double productPrice = double.parse(productPriceController.text);
        int productQuantity = int.parse(productQuantityController.text);
        await DatabaseHelper.updateProduct(
            widget.itemId!,
            productNameController.text.trim(),
            productPrice,
            productQuantity);
      }
      refreshList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.itemId == null ? 'Save' : 'Edit';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.itemId == null ? 'Add Item' : 'Update Item'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[200],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: productNameController,
              labelText: 'Enter Product Name:',
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: productPriceController,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.indigo),
              decoration: CustomTextFieldDecoration.getInputDecoration(
                'Enter Product Price:',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: productQuantityController,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.indigo),
              decoration: CustomTextFieldDecoration.getInputDecoration(
                'Enter Product Quantity:',
              ),
            ),
            CustomElevatedButton(
              text: buttonText,
              onPressed: () {
                saveitem();
              },
            ),
          ],
        ),
      ),
    );
  }
}


