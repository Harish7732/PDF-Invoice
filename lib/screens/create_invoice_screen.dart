import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/pdf_service.dart';

class CreateInvoiceScreen extends StatefulWidget {
  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();

  // Controllers for the item fields
  final itemNameController = TextEditingController();
  final itemQuantityController = TextEditingController();
  final itemPriceController = TextEditingController();

  List<InvoiceItem> items = [];
  DateTime invoiceDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Invoice')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Customer Information
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter a name' : null,
                ),
                TextFormField(
                  controller: customerAddressController,
                  decoration: InputDecoration(labelText: 'Customer Address'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter an address' : null,
                ),

                // Invoice Date Picker
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        invoiceDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Select Date: ${invoiceDate.toLocal()}'),
                ),

                // Item Information
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: itemQuantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: itemPriceController,
                  decoration: InputDecoration(labelText: 'Price per Unit'),
                  keyboardType: TextInputType.number,
                ),

                // Add Item Button
                ElevatedButton(
                  onPressed: () {
                    // Check if input fields are valid and not empty
                    if (itemNameController.text.isNotEmpty &&
                        itemQuantityController.text.isNotEmpty &&
                        itemPriceController.text.isNotEmpty) {

                      // Parse the quantity and price fields
                      int quantity = int.tryParse(itemQuantityController.text) ?? 1;
                      double price = double.tryParse(itemPriceController.text) ?? 0.0;

                      // Add the item to the list
                      setState(() {
                        items.add(InvoiceItem(
                          name: itemNameController.text,
                          quantity: quantity,
                          pricePerUnit: price,
                        ));

                        // Clear input fields
                        itemNameController.clear();
                        itemQuantityController.clear();
                        itemPriceController.clear();
                      });
                    }
                  },
                  child: Text('Add Item'),
                ),

                // Display the added items
                if (items.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text('${item.name}'),
                        subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.pricePerUnit}'),
                        trailing: Text('Total: \$${item.totalPrice}'),
                      );
                    },
                  ),

                // Generate PDF Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && items.isNotEmpty) {
                      final invoice = Invoice(
                        invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
                        customerName: customerNameController.text,
                        customerAddress: customerAddressController.text,
                        invoiceDate: invoiceDate,
                        items: items,
                      );
                      PDFService.generatePDF(invoice, 1); // Pass template type
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Generate PDF'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}