import 'dart:io';
import 'package:kgl_express/models/order_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TicketExportService {
  static Future<File> generateTicketPdf(BusTicketModel ticket) async {
    final pdf = pw.Document();

    // Helper to split name for PDF (same logic as your UI)
    final nameParts = ticket.passengerName.trim().split(' ');
    final firstName = nameParts[0].toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : "";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6, // Small ticket size
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("KGL EXPRESS TICKET", style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Passenger Section
              pw.Text("PASSENGER", style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              pw.Text(firstName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              if (lastName.isNotEmpty)
                pw.Text(lastName, style: pw.TextStyle(fontSize: 14, color: PdfColors.grey900)),

              pw.SizedBox(height: 20),

              // Car Plate Highlight
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("CAR PLATE", style: pw.TextStyle(fontSize: 8)),
                        pw.Text(ticket.carPlate, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("OPERATOR", style: pw.TextStyle(fontSize: 8)),
                        pw.Text(ticket.operator, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.Spacer(),
              pw.Center(
                child: pw.Text("TICKET ID: ${ticket.activityId}", style: pw.TextStyle(fontSize: 8)),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: ticket.activityId,
                  width: 60,
                  height: 60,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ticket_${ticket.activityId}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}