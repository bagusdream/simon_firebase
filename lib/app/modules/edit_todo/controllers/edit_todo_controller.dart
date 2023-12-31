import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/custom_toast.dart';

class EditTodoController extends GetxController {
  //TODO: Implement EditTodoController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  String image = "";
  File? file;

  TextEditingController tanggalC = TextEditingController();
  TextEditingController jam_awalC = TextEditingController();
  TextEditingController waktuC = TextEditingController();
  TextEditingController no_suratC = TextEditingController();
  TextEditingController nama_dudiC = TextEditingController();
  TextEditingController alamat_dudiC = TextEditingController();
  TextEditingController jml_siswaC = TextEditingController();
  TextEditingController kegiatanC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();
  TextEditingController fotoC = TextEditingController();

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();

    tanggalC.text = argsData["tanggal"];
    jam_awalC.text = argsData["jam_awal"];
    waktuC.text = argsData["waktu"];
    no_suratC.text = argsData["no_surat"];
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

    titleC.dispose();
    descriptionC.dispose();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path ?? '');
    } else {
      // User canceled the picker
    }
    update();
  }

  void toCamera() {
    Get.to(CameraView())!.then((result) {
      file = result;
      update();
    });
  }

  Future<void> editTodo() async {
    if (nama_dudiC.text.isNotEmpty && kegiatanC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await editTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast(
          'Error', 'Kamu harus mengisi semua isian di dalam form');
    }
  }

  editTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("users").doc(uid).collection("todos");

      var dates = DateFormat('yyyy-MM-dd').format(DateTime.now());

      DocumentReference todo = await firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(argsData["id"]);

      if (file == null) {
        await childrenCollection.doc(argsData["id"]).update({
          "tanggal": tanggalC.text,
          "jam_awal": jam_awalC.text,
          "jam_akhir": DateFormat('hh:mm').format(
              DateTime.parse("$dates ${jam_awalC.text}")
                  .add(Duration(minutes: int.parse(waktuC.text)))),
          "waktu": waktuC.text,
          "no_surat": no_suratC.text,
          "nama_dudi": nama_dudiC.text,
          "alamat_dudi": alamat_dudiC.text,
          "jml_siswa": jml_siswaC.text,
          "kegiatan": kegiatanC.text,
          "keterangan": keteranganC.text,
          "foto": fotoC.text,
        });
      } else {
        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "image/${argsData["id"]}.$ext";

        var snapshot =
            await firebaseStorage.ref().child('images/$upDir').putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        await childrenCollection.doc(argsData["id"]).update({
          "tanggal": tanggalC.text,
          "jam_awal": jam_awalC.text,
          "jam_akhir": DateFormat('hh:mm').format(
              DateTime.parse("$dates ${jam_awalC.text}")
                  .add(Duration(minutes: int.parse(waktuC.text)))),
          "waktu": waktuC.text,
          "no_surat": no_suratC.text,
          "nama_dudi": nama_dudiC.text,
          "alamat_dudi": alamat_dudiC.text,
          "jml_siswa": jml_siswaC.text,
          "kegiatan": kegiatanC.text,
          "keterangan": keteranganC.text,
          "foto": fotoC.text,
          "image": downloadUrl,
        });
      }

      Get.back(); //close dialog
      Get.back(); //close form screen
      CustomToast.successToast(
          'Success', 'Berhasil memperbarui data Monitoring PKL');

      isLoadingCreateTodo.value = false;
    } on FirebaseAuthException catch (e) {
      isLoadingCreateTodo.value = false;
      CustomToast.errorToast('Error', 'error : ${e.code}');
    } catch (e) {
      isLoadingCreateTodo.value = false;
      CustomToast.errorToast('Error', 'error : ${e.toString()}');
    }
  }
}
