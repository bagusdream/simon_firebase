import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data Monitoring',
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
            hint: DateFormat('yyyy-MM-d').format(DateTime.now()),
            isDate: true,
            disabled: true,
          ),
          CustomInput(
            controller: controller.waktuC,
            label: 'Waktu',
            hint: '10',
            isNumber: true,
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
          ),
          CustomInput(
            controller: controller.keteranganC,
            label: 'Keterangan',
            hint: 'Keterangan Siswa Yang Magang',
          ),
          // CustomInput(
          //   controller: controller.fotoC,
          //   label: 'Foto',
          //   hint: 'Foto Kegiatan',
          // ),
          (controller.file != null)
              ? Image.file(controller.file!)
              : const SizedBox(),
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
                    controller.addTodo();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse)
                      ? 'Tambah Data Monitoring'
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
