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

    var tglDataFirebase = todoData["tanggal"];
    String strHari = tampilHari(tglDataFirebase);
    String strTanggal = tampilKataTgl("dd", tglDataFirebase);
    String strBulan = tampilKataTgl("mm", tglDataFirebase);
    String strTahun = tampilKataTgl("yy", tglDataFirebase);

    List items = [];
    List img = [];

    var i = 0;
    for (var element in dataPrint) {
      print("Sedang cetak halaman ke - $i");
      items.add(element.data());
      todoData = dataPrint[i].data();
      img.add(await networkImage(todoData["foto"]));
      i = i + 1;
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            items.length,
            (index) {
              var item = items[index];
              return pw.TableRow(
                children: [
                  // Data No
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Data NAMA DUDI
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      item["nama_dudi"],
                      //textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Data KEGIATAN
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      item["kegiatan"],
                      //textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Data Foto
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Center(
                      child: pw.Image(img[index], height: 100),
                    ),
                  ),
                  // QR Code
                  // pw.Padding(
                  //   padding: const pw.EdgeInsets.all(20),
                  //   child: pw.BarcodeWidget(
                  //     color: PdfColor.fromHex("#000000"),
                  //     barcode: pw.Barcode.qrCode(),
                  //     data: item["kode_inventaris"],
                  //     height: 50,
                  //     width: 50,
                  //   ),
                  // ),
                ],
              );
            },
          );
          return [
            pw.Center(
              child: pw.Text(
                "FOTO BUKTI KEGIATAN MONITORING PRAKERIN",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Center(
              child: pw.Text(
                "${strHari}, ${strTanggal} ${strBulan} ${strTahun}",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Container(
                      width: 50,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            left: 10, top: 10, right: 10, bottom: 10),
                        child: pw.Text(
                          "No",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // NAMA INDUSTRI
                    pw.Container(
                      width: 150,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "NAMA INDUSTRI",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // URAIAN KEGIATAN

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "URAIAN KEGIATAN",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    // FOTO
                    pw.Container(
                      width: 200,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "FOTO",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    // doc.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         // mainAxisAlignment: pw.MainAxisAlignment.start,
    //         // crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           pw.Text('FOTO BUKTI KEGIATAN MONITORING PRAKERIN'),
    //           pw.Text(
    //               '${tampilHari()}, ${tampilKataTgl("dd")} ${tampilKataTgl("mm")} ${tampilKataTgl("yy")}'),
    //           pw.SizedBox(height: 20),

    //           pw.Table.fromTextArray(
    //             context: context,
    //             data: <List<dynamic>>[
    //               <String>[
    //                 'NO',
    //                 'NAMA INDUSTRI',
    //                 'URAIAN KEGIATAN          ',
    //                 'FOTO KEGIATAN   '
    //               ],

    //               // dataPrint.map((val) {
    //               //   var item = val.data();
    //               //   return <String>[
    //               //     "1",
    //               //     "${item["nama_dudi"]}",
    //               //     "${item["kegiatan"]}",
    //               //     "${item["foto"]}",
    //               //   ];
    //               // }).toList(),

    //               // <String>[
    //               //   "1",
    //               //   "${todoData["nama_dudi"]}",
    //               //   "${todoData["kegiatan"]}",
    //               //   "${todoData["foto"]}",
    //               // ],

    //               //}
    //               // <String>['Jane Doe', '25', 'Los Angeles', ''],
    //               // <String>['Jim Doe', '35', 'Chicago', ''],
    //             ],
    //           ),

    //           pw.SizedBox(height: 10),
    //           pw.Row(
    //             children: [
    //               pw.Container(child: pw.Text("  1. "), width: 40),
    //               pw.Container(
    //                   child: pw.Text("${todoData["nama_dudi"]}"), width: 140),
    //               pw.Container(
    //                   child: pw.Text("${todoData["kegiatan"]}"), width: 180),
    //               pw.Container(
    //                   child: pw.Image(netImage, height: 100), width: 150),
    //             ],
    //           ),
    //           pw.SizedBox(height: 10),

    //           // pw.Column(
    //           //   children: dataPrint.map((val) {
    //           //     var item = val.data();
    //           //     return pw.Row(
    //           //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //           //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //           //         children: [
    //           //           //pw.Text(item.),
    //           //           pw.Text(item["nama_dudi"]),
    //           //           pw.Text(item["kegiatan"]),
    //           //         ]);
    //           //   }).toList(),
    //           // ),

    //           //pw.Text("$dataPrint[0].data()"),
    //         ],
    //       );
    //     }));

    var jumData = dataPrint.length;
    //untuk mengecek saja jika halaman lebih dari 6 tambahkan halaman kosong
    if (jumData >= 6) {
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.Text(" "),
            ]);
          }));
    }

    //print(jumData);
    for (int i = 0; i < jumData; i++) {
      var todoData = dataPrint[i].data();
      var netImage = await networkImage(todoData["foto"]);
      var tglDataFirebase = todoData["tanggal"];
      //print(tglDataFirebase);
      String strHari = tampilHari(tglDataFirebase);
      String strTanggal = tampilKataTgl("dd", tglDataFirebase);
      String strBulan = tampilKataTgl("mm", tglDataFirebase);
      String strTahun = tampilKataTgl("yy", tglDataFirebase);

      var no_Surat = "";
      if (todoData["no_surat"] == null) {
        no_Surat = '.........................................';
      } else {
        no_Surat = todoData["no_surat"];
      }

      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Column(
                  // mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('BERITA ACARA',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text('LAPORAN PELAKSANAAN TUGAS',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 20),
                  ],
                ),
                pw.Column(
                  // mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Pada hari ini ${strHari} tanggal ${strTanggal} bulan ${strBulan} tahun ${strTahun}'),
                    pw.Text('Nama       : $logNama'),
                    pw.Text('Jabatan    : $logJabatan'),
                    pw.Text('Instansi    : $logInstansi'),
                    pw.SizedBox(height: 20),
                    pw.Text(
                        'Telah melaksanakan tugas sesuai dengan Surat Tugas No : $no_Surat dari Kepala $logInstansi'),
                    pw.SizedBox(height: 20),
                    pw.Text('Tugas dilaksanakan pada : '),
                    pw.Text(
                        'Hari                 : ${strHari} s/d ${strHari} '),
                    pw.Text(
                        'Tanggal          : ${strTanggal} ${strBulan} ${strTahun} s/d ${strTanggal} ${strBulan} ${strTahun} '),
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
    } // n for

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

  String tampilHari(String tglDataFirebase) {
    var tgl;
    if (tglDataFirebase == "") {
      tgl = DateTime.now();
    } else {
      tgl = DateFormat('dd-MM-yyyy').parse(tglDataFirebase);
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

  String tampilKataTgl(String mode, String tglDataFirebase) {
    var tgl;
    var hasil = "";
    if (tglDataFirebase == "") {
      tgl = DateTime.now();
    } else {
      tgl = DateFormat('dd-MM-yyyy').parse(tglDataFirebase);
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
