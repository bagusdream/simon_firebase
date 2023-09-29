import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/home/views/home_view.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:flutter_crud_firebase/app/utils/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/all_todo_controller.dart';

// var dataPrint;

class AllTodoView extends GetView<AllTodoController> {
  const AllTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String judulNih;

    if (tglPencarian == "") {
      judulNih = "Semua Data Monitoring PKL";
    } else {
      judulNih = "Pencarian Data Monitoring PKL tgl $tglPencarian";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$judulNih',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondaryExtraSoft,
          ),
        ),
      ),
      body: GetBuilder<AllTodoController>(
        builder: (con) {
          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getAllResult(tglPencarian),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  var data = snapshot.data!.docs;
                  controller.dataPrint = data;
                  return ListView.separated(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      var todoData = data[index].data();
                      String desc;
                      return InkWell(
                        onTap: () => {
                          Get.toNamed(
                            Routes.DETAIL_TODO,
                            arguments: {
                              "id": "${todoData["task_id"]}",
                              "tanggal": "${todoData["tanggal"]}",
                              "waktu": "${todoData["waktu"]}",
                              "nama_dudi": "${todoData["nama_dudi"]}",
                              "alamat_dudi": "${todoData["alamat_dudi"]}",
                              "jml_siswa": "${todoData["jml_siswa"]}",
                              "kegiatan": "${todoData["kegiatan"]}",
                              "keterangan": "${todoData["keterangan"]}",
                              "foto": "${todoData["foto"]}",
                              "image": "${todoData["foto"]}",
                            },
                          )
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: AppColor.primaryExtraSoft,
                            ),
                          ),
                          padding: EdgeInsets.only(
                              left: 16, top: 16, right: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network("${todoData["foto"]}",
                                      height: 100),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (todoData["nama_dudi"] == null)
                                            ? "-"
                                            : "${todoData["nama_dudi"]}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${todoData["tanggal"]}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${todoData["kegiatan"]}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                default:
                  return SizedBox();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Get.toNamed(Routes.PDF);
        // },
        onPressed: () => controller.cetakPdf(),
        child: Icon(Icons.print, color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }
}
