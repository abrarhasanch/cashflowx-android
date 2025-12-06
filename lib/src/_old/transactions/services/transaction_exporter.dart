import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/book.dart';
import '../../models/transaction.dart';

class TransactionExporter {
  Future<File> export({required Book book, required List<BookTransaction> transactions}) async {
    final doc = pw.Document();
    final sorted = [...transactions]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final currencyCode = book.currency.isEmpty ? 'USD' : book.currency;
    final dateFormat = DateFormat.yMMMd().add_jm();
    final amountFormat = NumberFormat.simpleCurrency(name: currencyCode);

    final totalIn = sorted.where((txn) => txn.type == TransactionType.cashIn).fold<double>(0, (sum, txn) => sum + txn.amount);
    final totalOut = sorted.where((txn) => txn.type == TransactionType.cashOut).fold<double>(0, (sum, txn) => sum + txn.amount);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(32), theme: pw.ThemeData.withFont(base: pw.Font.helvetica(), bold: pw.Font.helveticaBold())),
        build: (context) {
          if (sorted.isEmpty) {
            return [
              pw.Text('CashFlowX Transactions Export', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Book: ${book.title}', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 8),
              pw.Text('No transactions available for the selected filters.', style: const pw.TextStyle(fontSize: 12)),
            ];
          }

          final rows = sorted.map((txn) {
            return [
              dateFormat.format(txn.createdAt),
              txn.remark?.isNotEmpty == true ? txn.remark! : '-',
              txn.category ?? '-',
              txn.paymentMode ?? '-',
              txn.type == TransactionType.cashIn ? 'Cash In' : 'Cash Out',
              amountFormat.format(txn.amount),
            ];
          }).toList();

          return [
            pw.Text('CashFlowX Transactions Export', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Book: ${book.title}', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Generated: ${DateFormat.yMMMMd().add_jm().format(DateTime.now())}', style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 16),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(12),
                color: const PdfColor.fromInt(0xFFEFF6FF),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _summaryBlock('Cash In', amountFormat.format(totalIn)),
                  _summaryBlock('Cash Out', amountFormat.format(totalOut)),
                  _summaryBlock('Net', amountFormat.format(totalIn - totalOut)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: const ['Date', 'Remark', 'Category', 'Payment', 'Type', 'Amount'],
              data: rows,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2563EB)),
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(1.5),
                5: const pw.FlexColumnWidth(1.5),
              },
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final sanitizedTitle = book.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final fileName = 'cashflowx_${sanitizedTitle.isEmpty ? 'book' : sanitizedTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  pw.Widget _summaryBlock(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}
