import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/all_todo/views/all_todo_view.dart';
import 'package:flutter_crud_firebase/app/modules/home/views/home_view.dart';
import 'package:flutter_crud_firebase/app/modules/login/bindings/login_binding.dart';
import 'package:get/get.dart';

import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/src/widgets/text_style.dart';

class AllTodoController extends GetxController {
  //TODO: Implement AllTodoController

  final count = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> dataPrint = [];

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

  void increment() => count.value++;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllResult(
      String pencarian) async {
    //print("info nihh $pencarian");
    String uid = auth.currentUser!.uid;
    if (pencarian == "") {
      QuerySnapshot<Map<String, dynamic>> query = await firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .orderBy(
            "created_at",
            descending: true,
          )
          .get();
      return query;
    } else {
      QuerySnapshot<Map<String, dynamic>> query = await firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .where("tanggal", isEqualTo: pencarian)
          .orderBy(
            "created_at",
            descending: true,
          )
          .get();
      return query;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserResult() async {
    //print("info nihh $pencarian");
    String uid = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> query =
        await firestore.collection("users").doc(uid).get();
    return query;
  }

  void cetakPdf() async {
    final doc = pw.Document();
    var list = [1, 2, 3];
    var todoData = dataPrint[0].data();
    var netImage = await networkImage(todoData["foto"]);
    // print("tessss ${dataPrint.length}");
    // for (int i = 0; i < dataPrint.length; i++) {
    //   List<dynamic> printData = dataPrint[0].data();
    // }

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            // mainAxisAlignment: pw.MainAxisAlignment.start,
            // crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('FOTO BUKTI KEGIATAN MONITORING PRAKERIN'),
              pw.Text(
                  '${tampilHari()}, ${tampilKataTgl("dd")} ${tampilKataTgl("mm")} ${tampilKataTgl("yy")}'),
              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                context: context,
                data: <List<dynamic>>[
                  <String>[
                    'NO',
                    'NAMA INDUSTRI',
                    'URAIAN KEGIATAN          ',
                    'FOTO KEGIATAN   '
                  ],

                  // dataPrint.map((val) {
                  //   var item = val.data();
                  //   return <String>[
                  //     "1",
                  //     "${item["nama_dudi"]}",
                  //     "${item["kegiatan"]}",
                  //     "${item["foto"]}",
                  //   ];
                  // }).toList(),

                  // <String>[
                  //   "1",
                  //   "${todoData["nama_dudi"]}",
                  //   "${todoData["kegiatan"]}",
                  //   "${todoData["foto"]}",
                  // ],

                  //}
                  // <String>['Jane Doe', '25', 'Los Angeles', ''],
                  // <String>['Jim Doe', '35', 'Chicago', ''],
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Container(child: pw.Text("  1. "), width: 40),
                  pw.Container(
                      child: pw.Text("${todoData["nama_dudi"]}"), width: 140),
                  pw.Container(
                      child: pw.Text("${todoData["kegiatan"]}"), width: 180),
                  pw.Container(
                      child: pw.Image(netImage, height: 100), width: 150),
                ],
              ),
              pw.SizedBox(height: 10),

              // pw.Column(
              //   children: dataPrint.map((val) {
              //     var item = val.data();
              //     return pw.Row(
              //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: pw.CrossAxisAlignment.start,
              //         children: [
              //           //pw.Text(item.),
              //           pw.Text(item["nama_dudi"]),
              //           pw.Text(item["kegiatan"]),
              //         ]);
              //   }).toList(),
              // ),

              //pw.Text("$dataPrint[0].data()"),
            ],
          );
        }));

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Column(
                // mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('BERITA ACARA'),
                  pw.Text('LAPORAN PELAKSANAAN TUGAS'),
                  pw.SizedBox(height: 20),
                ],
              ),
              pw.Column(
                // mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                      'Pada hari ini ${tampilHari()} tanggal ${tampilKataTgl("dd")} bulan ${tampilKataTgl("mm")} tahun ${tampilKataTgl("yy")}'),
                  pw.Text('Nama       : $logNama'),
                  pw.Text('Jabatan    : $logJabatan'),
                  pw.Text('Instansi    : $logInstansi'),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Telah melaksanakan tugas sesuai dengan Surat Tugas No : ......................................... dari Kepala $logInstansi'),
                  pw.SizedBox(height: 20),
                  pw.Text('Tugas dilaksanakan pada : '),
                  pw.Text(
                      'Hari                 : ${tampilHari()} s/d ${tampilHari()} '),
                  pw.Text(
                      'Tanggal          : ${tampilKataTgl("dd")} ${tampilKataTgl("mm")} ${tampilKataTgl("yy")} s/d ${tampilKataTgl("dd")} ${tampilKataTgl("mm")} ${tampilKataTgl("yy")} '),
                  pw.Text(
                      'Waktu             : ${todoData["jam_awal"]} s/d ${todoData["jam_akhir"]}'),
                  pw.Text('Nama Dudi     : ${todoData["nama_dudi"]} '),
                  pw.Text('Alamat Dudi    : ${todoData["alamat_dudi"]} '),
                  pw.Text('Jumlah Siswa : ${todoData["jml_siswa"]} Orang'),
                  pw.SizedBox(height: 20),
                  pw.Text('Dengan hasil sebagai berikut : '),
                  pw.Text('${todoData["kegiatan"]} '),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Demikian Berita Acara Laporan Pelaksanaan Tugas ini saya buat dengan sebenarnya sebagai pertanggung jawaban saya selama melaksanakan tugas.'),
                  pw.SizedBox(height: 30),
                  pw.Text(
                      '                                                                   Yang Membuat Berita Acara'),
                  pw.SizedBox(height: 70),
                  pw.Text(
                      '                                                                   $logNama'),
                  pw.Text(
                      '                                                                   NIP. $logNIP'),
                ],
              ),
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

  String tampilHari() {
    var tgl;
    if (tglPencarian == "") {
      tgl = DateTime.now();
    } else {
      tgl = DateFormat('dd-MM-yyyy').parse(tglPencarian);
    }

    String hari = DateFormat('EEEE').format(tgl);
    String hariIndo = "";
    if (hari.toLowerCase() == "sunday") {
      hariIndo = "Minggu";
    } else if (hari.toLowerCase() == "monday") {
      hariIndo = "Senin";
    } else if (hari.toLowerCase() == "tuesday") {
      hariIndo = "Selasa";
    } else if (hari.toLowerCase() == "wednesday") {
      hariIndo = "Rabu";
    } else if (hari.toLowerCase() == "thursday") {
      hariIndo = "Kamis";
    } else if (hari.toLowerCase() == "friday") {
      hariIndo = "Jumat";
    } else if (hari.toLowerCase() == "saturday") {
      hariIndo = "Sabtu";
    }
    return hariIndo;
  }

  String tampilKataTgl(String mode) {
    var tgl;
    var hasil = "";
    if (tglPencarian == "") {
      tgl = DateTime.now();
    } else {
      tgl = DateFormat('dd-MM-yyyy').parse(tglPencarian);
    }
    if (mode == "dd") {
      hasil = DateFormat('dd').format(tgl);
    } else if (mode == "mm") {
      hasil = DateFormat('MM').format(tgl);
      if (hasil == "01") {
        hasil = "Januari";
      } else if (hasil == "02") {
        hasil = "Februari";
      } else if (hasil == "03") {
        hasil = "Maret";
      } else if (hasil == "04") {
        hasil = "April";
      } else if (hasil == "05") {
        hasil = "Mei";
      } else if (hasil == "06") {
        hasil = "Juni";
      } else if (hasil == "07") {
        hasil = "Juli";
      } else if (hasil == "08") {
        hasil = "Agustus";
      } else if (hasil == "09") {
        hasil = "September";
      } else if (hasil == "10") {
        hasil = "Oktober";
      } else if (hasil == "11") {
        hasil = "November";
      } else if (hasil == "12") {
        hasil = "Desember";
      }
    } else if (mode == "yy") {
      hasil = DateFormat('yyyy').format(tgl);
    }
    return hasil;
  }
}
