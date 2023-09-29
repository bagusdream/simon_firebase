import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfController extends GetxController {
  //TODO: Implement PdfController
  void cetakPdf() async {
    //tidak di pakai
    final doc = pw.Document();
    var list = [1, 2, 3];
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Hello World'),
              pw.Text('Hello World2 nih'),
              pw.Text('Hello World2 nih sfffffffffffff'),
              pw.Column(
                children: list.map((e) {
                  return pw.Text(e.toString());
                }).toList(),
              ),
              pw.Text('Hello World4'),
            ],
          );
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  void displayPdf() {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Text('Hello Sir'),
          ); // Center
        }));
    Get.toNamed(Routes.PREVIEW_SCREEN, arguments: doc);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
