class Invoice {
  String invoiceNumber;
  String customerName;
  String customerAddress;
  DateTime invoiceDate;
  List<InvoiceItem> items;

  Invoice({
    required this.invoiceNumber,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceDate,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
}

class InvoiceItem {
  String name;
  int quantity;
  double pricePerUnit;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.pricePerUnit,
  });

  double get totalPrice => quantity * pricePerUnit;
}
