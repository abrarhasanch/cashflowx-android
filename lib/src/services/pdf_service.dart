import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/account.dart';
import '../models/transaction.dart';

// Conditional imports for platform-specific functionality
import 'pdf_service_mobile.dart' if (dart.library.html) 'pdf_service_web.dart' as platform;

class PdfService {
  static Future<void> generateAndShareReport({
    required List<Account> accounts,
    required Map<String, List<AccountTransaction>> transactionsByAccount,
    required DateTime startDate,
    required DateTime endDate,
    required String currency,
  }) async {
    final pdf = pw.Document();

    // Calculate totals
    double totalIncome = 0;
    double totalExpense = 0;

    for (final account in accounts) {
      final transactions = transactionsByAccount[account.id] ?? [];
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.cashIn) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }
    }

    final balance = totalIncome - totalExpense;
    // Show plain amounts (no currency symbol) per request
    const currencySymbol = '';

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            _buildHeader(startDate, endDate),
            pw.SizedBox(height: 24),

            // Summary Section
            _buildSummarySection(
              totalIncome,
              totalExpense,
              balance,
              currencySymbol,
            ),
            pw.SizedBox(height: 24),

            // Accounts Breakdown
            _buildAccountsSection(
              accounts,
              transactionsByAccount,
              currencySymbol,
            ),
            pw.SizedBox(height: 24),

            // Transaction Details
            _buildTransactionsSection(
              accounts,
              transactionsByAccount,
              currencySymbol,
            ),
          ];
        },
      ),
    );

    // Save and share
    await _saveAndSharePdf(pdf, startDate, endDate);
  }

  static pw.Widget _buildHeader(DateTime startDate, DateTime endDate) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Financial Report',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Generated on ${dateFormat.format(DateTime.now())}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey600,
          ),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  static pw.Widget _buildSummarySection(
    double totalIncome,
    double totalExpense,
    double balance,
    String currencySymbol,
  ) {
    String fmt(double v) => NumberFormat('#,##0.00').format(v);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryCard(
                'Total Income',
                '$currencySymbol${fmt(totalIncome)}'.trim(),
                PdfColors.green600,
              ),
              _buildSummaryCard(
                'Total Expense',
                '$currencySymbol${fmt(totalExpense)}'.trim(),
                PdfColors.red600,
              ),
              _buildSummaryCard(
                'Net Balance',
                '$currencySymbol${fmt(balance)}'.trim(),
                balance >= 0 ? PdfColors.blue600 : PdfColors.orange600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryCard(
    String title,
    String value,
    PdfColor color,
  ) {
    return pw.Container(
      width: 160,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#f7f8fa'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        border: pw.Border.all(color: color, width: 1.2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAccountsSection(
    List<Account> accounts,
    Map<String, List<AccountTransaction>> transactionsByAccount,
    String currencySymbol,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Accounts Breakdown',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildTableCell('Account', isHeader: true),
                _buildTableCell('Currency', isHeader: true),
                _buildTableCell('Total In', isHeader: true),
                _buildTableCell('Total Out', isHeader: true),
                _buildTableCell('Balance', isHeader: true),
              ],
            ),
            // Data rows
            ...accounts.map((account) {
              final transactions = transactionsByAccount[account.id] ?? [];
              double totalIn = 0;
              double totalOut = 0;

              for (final transaction in transactions) {
                if (transaction.type == TransactionType.cashIn) {
                  totalIn += transaction.amount;
                } else {
                  totalOut += transaction.amount;
                }
              }

              final balance = totalIn - totalOut;

              return pw.TableRow(
                children: [
                  _buildTableCell(account.title),
                  _buildTableCell(account.currency),
                  _buildTableCell(totalIn.toStringAsFixed(2)),
                  _buildTableCell(totalOut.toStringAsFixed(2)),
                  _buildTableCell(
                    balance.toStringAsFixed(2),
                    color: balance >= 0 ? PdfColors.green : PdfColors.red,
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTransactionsSection(
    List<Account> accounts,
    Map<String, List<AccountTransaction>> transactionsByAccount,
    String currencySymbol,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Recent Transactions',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        ...accounts.map((account) {
          final transactions = transactionsByAccount[account.id] ?? [];
          if (transactions.isEmpty) return pw.SizedBox();

          // Take only first 10 transactions per account
          final displayTransactions = transactions.take(10).toList();

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                account.title,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _buildTableCell('Description', isHeader: true),
                      _buildTableCell('Date', isHeader: true),
                      _buildTableCell('Type', isHeader: true),
                      _buildTableCell('Amount', isHeader: true),
                      _buildTableCell('Status', isHeader: true),
                    ],
                  ),
                  // Data rows
                  ...displayTransactions.map((transaction) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell(transaction.remark ?? 'No description'),
                        _buildTableCell(
                          DateFormat('MMM dd, yyyy').format(transaction.createdAt),
                        ),
                        _buildTableCell(
                          transaction.type == TransactionType.cashIn
                              ? 'Cash In'
                              : 'Cash Out',
                        ),
                        _buildTableCell(
                          transaction.amount.toStringAsFixed(2),
                          color: transaction.type == TransactionType.cashIn
                              ? PdfColors.green
                              : PdfColors.red,
                        ),
                        _buildTableCell(
                          transaction.isPaid ? 'Paid' : 'Pending',
                        ),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
        ),
      ),
    );
  }

  static Future<void> _saveAndSharePdf(
    pw.Document pdf,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Generate PDF bytes
      final bytes = await pdf.save();
      
      final dateFormat = DateFormat('yyyy-MM-dd');
      final fileName =
          'report_${dateFormat.format(startDate)}_${dateFormat.format(endDate)}.pdf';
      
      // Use platform-specific implementation
      await platform.saveAndSharePdf(
        bytes: bytes,
        fileName: fileName,
        subject: 'Financial Report',
        text: 'Financial report from ${dateFormat.format(startDate)} to ${dateFormat.format(endDate)}',
      );
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}
