import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';

class DetailTodoController extends GetxController {
  //TODO: Implement DetailTodoController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  TextEditingController tanggalC = TextEditingController();
  TextEditingController waktuC = TextEditingController();
  TextEditingController nama_dudiC = TextEditingController();
  TextEditingController alamat_dudiC = TextEditingController();
  TextEditingController jml_siswaC = TextEditingController();
  TextEditingController kegiatanC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();
  TextEditingController fotoC = TextEditingController();

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  String image = "";
  String imageName = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    tanggalC.text = argsData["tanggal"];
    waktuC.text = argsData["waktu"];
    nama_dudiC.text = argsData["nama_dudi"];
    alamat_dudiC.text = argsData["alamat_dudi"];
    jml_siswaC.text = argsData["jml_siswa"];
    kegiatanC.text = argsData["kegiatan"];
    keteranganC.text = argsData["keterangan"];
    fotoC.text = argsData["foto"];
    image = argsData["foto"];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    // titleC.dispose();
    // descriptionC.dispose();
  }

  void increment() => count.value++;

  Future<void> deleteTodo() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Hapus data Monitoring PKL",
      message: "Apakah anda ingin menghapus data Monitoring PKL ini ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page

        try {
          await firebaseStorage.refFromURL(image).delete();

          String uid = auth.currentUser!.uid;
          await firestore
              .collection('users')
              .doc(uid)
              .collection('todos')
              .doc(argsData['id'])
              .delete();
          CustomToast.successToast(
              'Success', 'Data Monitoring PKL berhasil dihapus');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }
}
