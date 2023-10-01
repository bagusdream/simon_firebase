import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_toast.dart';

class AddTodoController extends GetxController {
  //TODO: Implement AddTodoController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

// tanggal
// waktu
// nama_dudi
// alamat_dudi
// jml_siswa
// kegiatan
// keterangan
// foto

  TextEditingController tanggalC = TextEditingController();
  TextEditingController jamAwalC = TextEditingController();
  TextEditingController waktuC = TextEditingController();
  TextEditingController no_SuratC = TextEditingController();
  TextEditingController nama_dudiC = TextEditingController();
  TextEditingController alamat_dudiC = TextEditingController();
  TextEditingController jml_siswaC = TextEditingController();
  TextEditingController kegiatanC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();
  TextEditingController fotoC = TextEditingController();
  // TextEditingController titleC = TextEditingController();
  // TextEditingController descriptionC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? file;

  @override
  void onInit() {
    super.onInit();

    tanggalC.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    //tanggalC.text = DateFormat('yyyy-MM-d hh:mm').format(DateTime.now().add(Duration(minutes: 10)));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    // tanggalC.dispose();
    // waktuC.dispose();
    // nama_dudiC.dispose();
    // alamat_dudiC.dispose();
    // jml_siswaC.dispose();
    // kegiatanC.dispose();
    // keteranganC.dispose();
    // fotoC.dispose();
  }

  void increment() => count.value++;

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

  Future<void> addTodo() async {
    if (nama_dudiC.text.isNotEmpty && kegiatanC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await createTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast(
          'Error', 'Kamu harus mengisi semua input form Data Monitoring');
    }
  }

  createTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("users").doc(uid).collection("todos");

      var uuidTodo = Uuid().v1();

      String fileName = file!.path.split('/').last;
      String ext = fileName.split(".").last;
      String upDir = "image/${uuidTodo}.$ext";

      var snapshot =
          await firebaseStorage.ref().child('images/$upDir').putFile(file!);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      var dates = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await childrenCollection.doc(uuidTodo).set({
        "task_id": uuidTodo,
        "tanggal": tanggalC.text,
        "waktu": waktuC.text,
        //"jam_awal": DateFormat('hh:mm').format(DateTime.now()),
        "jam_awal": jamAwalC.text,
        "jam_akhir": DateFormat('hh:mm').format(
            DateTime.parse("$dates ${jamAwalC.text}")
                .add(Duration(minutes: int.parse(waktuC.text)))),
        // "jam_akhir": DateFormat('hh:mm').format(
        //     DateTime.now().add(Duration(minutes: int.parse(waktuC.text)))),
        "no_surat": no_SuratC.text,
        "nama_dudi": nama_dudiC.text,
        "alamat_dudi": alamat_dudiC.text,
        "jml_siswa": jml_siswaC.text,
        "kegiatan": kegiatanC.text,
        "keterangan": keteranganC.text,
        "foto": downloadUrl,
        "created_at": DateTime.now().toIso8601String(),
      });

      Get.back(); //close dialog
      Get.back(); //close form screen
      CustomToast.successToast(
          'Success', 'Berhasil menambahkan Data Monitoring');

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
