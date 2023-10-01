import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/detail_todo_controller.dart';

class DetailTodoView extends GetView<DetailTodoController> {
  const DetailTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Monitoring PKL',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.EDIT_TODO, arguments: controller.argsData);
            },
            child: Text('Edit'),
            style: TextButton.styleFrom(
              primary: AppColor.primary,
            ),
          ),
        ],
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
            hint: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            //isDate: true,
            disabled: true,
          ),
          CustomInput(
            controller: controller.jamAwalC,
            label: 'Jam Awal Monitoring',
            hint: 'Jam Awal Monitoring',
            isTime: true,
            disabled: true,
          ),
          CustomInput(
            controller: controller.waktuC,
            label: 'Waktu',
            hint: 'Masukkan Lama Monitoring (Menit)',
            isNumber: true,
            disabled: true,
          ),
          CustomInput(
            controller: controller.no_suratC,
            label: 'Nomor Surat Tugas',
            hint: 'Masukkan Nomor Surat Tugas',
            disabled: true,
          ),
          CustomInput(
            controller: controller.nama_dudiC,
            label: 'Nama Dudi',
            hint: 'Masukkan Nama Dudi',
            disabled: true,
          ),
          CustomInput(
            controller: controller.alamat_dudiC,
            label: 'Alamat Dudi',
            hint: 'Masukkan Alamat Dudi',
            disabled: true,
          ),
          CustomInput(
            controller: controller.jml_siswaC,
            label: 'Jumlah Siswa',
            hint: '2',
            isNumber: true,
            disabled: true,
          ),
          CustomInput(
            controller: controller.kegiatanC,
            label: 'Kegiatan',
            hint: 'Kegiatan Monitoring Dudi',
            disabled: true,
            maxLine: 5,
          ),
          CustomInput(
            controller: controller.keteranganC,
            label: 'Keterangan',
            hint: 'Keterangan Siswa Yang Magang',
            disabled: true,
          ),
          CustomInput(
            controller: controller.fotoC,
            label: 'Foto',
            hint: 'Foto Kegiatan',
            disabled: true,
          ),
          Image.network(controller.image, height: 300),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteTodo();
            },
            child: Text(
              'Delete Data Monitoring PKL',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: AppColor.warning,
              padding: EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
