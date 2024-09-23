import 'package:flutter/material.dart';
import 'create_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Generator')),
      body: Center(child: Text('Welcome to the Invoice Generator!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateInvoiceScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
