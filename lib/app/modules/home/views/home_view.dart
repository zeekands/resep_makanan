import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan/app/data/resep.dart';
import 'package:resep_makanan/app/routes/app_pages.dart';
import 'package:resep_makanan/utils/rounded_textfield.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('3AM Resep Makanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed(Routes.ADD_RESEP);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Resep>>(
          stream: controller.readResep(),
          builder: (context, snapshot) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10.h,
                crossAxisCount: 2,
                childAspectRatio: .7,
              ),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  final image = XFile("").obs;
                  final namaController = TextEditingController();
                  final hargaController = TextEditingController();
                  TextEditingController deskripsiController =
                      TextEditingController();
                  TextEditingController kategoriController =
                      TextEditingController();
                  final langkahController = TextEditingController();
                  final bahanController = TextEditingController();
                  namaController.text = snapshot.data![index].nama.toString();
                  deskripsiController.text =
                      snapshot.data![index].deskripsi.toString();
                  langkahController.text =
                      snapshot.data![index].langkah.toString();
                  bahanController.text = snapshot.data![index].bahan.toString();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Obx(
                      () => Container(
                        height: .968.sh,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(10),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              10.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Edit Menu",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500)),
                                  IconButton(
                                      onPressed: () => Get.back(),
                                      icon: Icon(
                                        Icons.close,
                                        size: 16.sp,
                                        color: Colors.grey[500],
                                      )),
                                ],
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenUtil().setWidth(10),
                                    ),
                                  ),
                                  child: image.value.path == ""
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              snapshot.data?[index].gambar ??
                                                  "",
                                          width: 200.w,
                                          height: 300.h,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(image.value.path),
                                          width: 200.w,
                                          height: 300.h,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              10.verticalSpace,
                              Center(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      ImagePicker picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        image.value = pickedFile;
                                      }
                                    },
                                    child: const Text("Edit Foto")),
                              ),
                              20.verticalSpace,
                              Text(
                                "Nama Menu",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                ),
                              ),
                              10.verticalSpace,
                              RoundedInputField(
                                textEditingController: namaController,
                                hintText: snapshot.data?[index].nama.toString(),
                              ),
                              15.verticalSpace,
                              Text(
                                "Deskripsi",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                ),
                              ),
                              10.verticalSpace,
                              TextFormField(
                                controller: deskripsiController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: snapshot.data?[index].deskripsi
                                      .toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10),
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                "Bahan",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                ),
                              ),
                              10.verticalSpace,
                              TextFormField(
                                controller: bahanController,
                                decoration: InputDecoration(
                                    labelText: "Bahan",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(10),
                                      ),
                                    )),
                                maxLines: 5,
                              ),
                              20.verticalSpace,
                              TextFormField(
                                controller: langkahController,
                                decoration: InputDecoration(
                                  labelText: "Langkah",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10),
                                    ),
                                  ),
                                ),
                                maxLines: 5,
                              ),
                              30.verticalSpace,
                              Row(
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      height: ScreenUtil().setHeight(40),
                                      width: 0.5.sw,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await controller.deleteMenu(
                                              snapshot.data![index].id ?? "");
                                          Get.back();
                                          Get.snackbar(
                                            "Hapus Berhasil",
                                            "Data Telah Berhasil Dihapus",
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        },
                                        child: const Text('Hapus Menu'),
                                      ),
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: SizedBox(
                                      height: ScreenUtil().setHeight(40),
                                      width: 0.5.sw,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                        ),
                                        onPressed: () async {
                                          if (image.value.path.isNotEmpty) {
                                            await controller
                                                .updateResepWithImage(
                                              snapshot.data![index].id ?? "",
                                              namaController.text,
                                              bahanController.text,
                                              langkahController.text,
                                              deskripsiController.text,
                                              File(image.value.path),
                                            );
                                          } else {
                                            await controller.updateResep(
                                              snapshot.data![index].id ?? "",
                                              namaController.text,
                                              bahanController.text,
                                              langkahController.text,
                                              deskripsiController.text,
                                              snapshot.data![index].gambar
                                                  .toString(),
                                            );
                                          }
                                          Get.back();
                                          Get.snackbar(
                                            "Edit Berhasil",
                                            "Data Telah Berhasil Diedit",
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        },
                                        child: const Text('Simpan Menu'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ).paddingSymmetric(vertical: 10.h, horizontal: 20.w),
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data?[index].gambar ?? "",
                        height: 230.h,
                        width: 200.w,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      snapshot.data?[index].nama ?? "",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              itemCount: snapshot.data?.length,
            ).paddingSymmetric(vertical: 20.h, horizontal: 10.w);
          }),
    );
  }
}
