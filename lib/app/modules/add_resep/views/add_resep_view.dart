import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/add_resep_controller.dart';

class AddResepView extends GetView<AddResepController> {
  const AddResepView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Resep'),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.image.value.path != ""
                  ? Image.file(
                      File(controller.image.value.path),
                      height: 300.h,
                      width: 1.sw,
                      fit: BoxFit.cover,
                    )
                  : GestureDetector(
                      onTap: () async {
                        await controller.getImage(true);
                      },
                      child: Container(
                        height: 300.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Tambah Foto"),
                            10.horizontalSpace,
                            const Icon(Icons.add_a_photo_outlined),
                          ],
                        ),
                      ),
                    ),
              10.verticalSpace,
              controller.image.value.path != ""
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 28.r,
                      ),
                      onPressed: () async {
                        controller.image.value = XFile("");
                      },
                    )
                  : const SizedBox(),
              10.verticalSpace,
              Column(
                children: [
                  TextField(
                    controller: controller.namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Resep",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  20.verticalSpace,
                  TextField(
                    controller: controller.deskripsiController,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi Resep",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  20.verticalSpace,
                  TextField(
                    controller: controller.bahanController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Bahan Resep",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  20.verticalSpace,
                  TextField(
                    controller: controller.langkahController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Langkah Resep",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GestureDetector(
                    onTap: () async {
                      await controller.addResep(
                          File(controller.image.value.path),
                          controller.namaController.text,
                          controller.deskripsiController.text,
                          controller.bahanController.text,
                          controller.langkahController.text);
                      Get.back();
                      Get.snackbar("Berhasil", "Resep Baru ditambahkan.",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    },
                    child: Container(
                        width: 1.sw,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text('Tambah Resep',
                                style: TextStyle(color: Colors.white)))),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}
