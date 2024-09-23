import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';

class PDFService {
  static Future<void> generatePDF(Invoice invoice, int templateType) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) => (templateType == 1) ? _template1(invoice) : _template2(invoice),
    ));

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _template1(Invoice invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('INVOICE', style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
        pw.Text('Customer: ${invoice.customerName}'),
        pw.Text('Address: ${invoice.customerAddress}'),
        pw.Text('Date: ${invoice.invoiceDate.toLocal()}'),
        pw.Divider(),
        pw.Text('Items:'),
        pw.Table(
          children: [
            pw.TableRow(children: [
              pw.Text('Item Name'),
              pw.Text('Qty'),
              pw.Text('Price per Unit'),
              pw.Text('Total Price')
            ]),
            ...invoice.items.map((item) => pw.TableRow(children: [
              pw.Text(item.name),
              pw.Text('${item.quantity}'),
              pw.Text('\$${item.pricePerUnit}'),
              pw.Text('\$${item.totalPrice}')
            ])),
          ],
        ),
        pw.Divider(),
        pw.Text('Total Amount: \$${invoice.totalAmount}')
      ],
    );
  }

  static pw.Widget _template2(Invoice invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('Modern Invoice', style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
        pw.Text('Customer: ${invoice.customerName}', style: pw.TextStyle(fontSize: 16)),
        pw.Text('Address: ${invoice.customerAddress}', style: pw.TextStyle(fontSize: 16)),
        pw.Text('Date: ${invoice.invoiceDate.toLocal()}', style: pw.TextStyle(fontSize: 16)),
        pw.SizedBox(height: 20),
        pw.Text('Items Purchased:', style: pw.TextStyle(fontSize: 18)),
        pw.ListView.builder(
          itemCount: invoice.items.length,
          itemBuilder: (context, index) {
            final item = invoice.items[index];
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(item.name),
                pw.Text('Qty: ${item.quantity}'),
                pw.Text('Price: \$${item.pricePerUnit}'),
                pw.Text('Total: \$${item.totalPrice}')
              ],
            );
          },
        ),
        pw.SizedBox(height: 20),
        pw.Text('Total Amount: \$${invoice.totalAmount}', style: pw.TextStyle(fontSize: 18))
      ],
    );
  }
}
