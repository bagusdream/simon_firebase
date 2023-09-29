import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pdf_controller.dart';

class PdfView extends GetView<PdfController> {
  const PdfView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PdfView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => controller.cetakPdf(),
              child: Text("Preview PDF"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () => controller.cetakPdf(),
              child: Text("Cetak PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
