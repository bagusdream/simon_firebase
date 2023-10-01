import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/edit_todo_controller.dart';

class EditTodoView extends GetView<EditTodoController> {
  const EditTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data Monitoring PKL',
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          CustomInput(
            controller: controller.tanggalC,
            label: 'Tanggal',
            hint: DateTime.now().toString(),
            isDate: true,
          ),
          CustomInput(
            controller: controller.jam_awalC,
            label: 'Jam Awal Monitoring',
            hint: 'Jam Awal Monitoring',
            isTime: true,
          ),
          CustomInput(
            controller: controller.waktuC,
            label: 'Waktu',
            hint: 'Masukkan Lama Monitoring (Menit)',
            isNumber: true,
          ),
          CustomInput(
            controller: controller.no_suratC,
            label: 'Nomor Surat Tugas',
            hint: 'Masukkan Nomor Surat Tugas',
          ),
          CustomInput(
            controller: controller.nama_dudiC,
            label: 'Nama Dudi',
            hint: 'Masukkan Nama Dudi',
          ),
          CustomInput(
            controller: controller.alamat_dudiC,
            label: 'Alamat Dudi',
            hint: 'Masukkan Alamat Dudi',
          ),
          CustomInput(
            controller: controller.jml_siswaC,
            label: 'Jumlah Siswa',
            hint: '2',
            isNumber: true,
          ),
          CustomInput(
            controller: controller.kegiatanC,
            label: 'Kegiatan',
            hint: 'Kegiatan Monitoring Dudi',
            maxLine: 5,
          ),
          CustomInput(
            controller: controller.keteranganC,
            label: 'Keterangan',
            hint: 'Keterangan Siswa Yang Magang',
          ),
          CustomInput(
            controller: controller.fotoC,
            label: 'Foto',
            hint: 'Foto Kegiatan',
          ),
          (controller.file == null)
              ? Image.network(
                  (controller.image != null)
                      ? controller.image
                      : 'https://placehold.co/600x400/png',
                  height: 300,
                )
              : Image.file(controller.file!),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.toCamera(),
                  child: Text(
                    'Kamera',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.pickFile(),
                  child: Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.editTodo();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse)
                      ? 'Edit Data Monitoring PKL'
                      : 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
