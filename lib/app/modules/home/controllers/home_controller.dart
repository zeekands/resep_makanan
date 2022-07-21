import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan/app/data/resep.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('resep');
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController bahanController = TextEditingController();
  TextEditingController langkahController = TextEditingController();

  final image = XFile("").obs;

  Stream<List<Resep>> readResep() => FirebaseFirestore.instance
      .collection('resep')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Resep.fromJson(doc.data())).toList());
  @override
  void onInit() async {
    super.onInit();
    FlutterNativeSplash.remove();
  }

  Future getImage(bool gallery, XFile image) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('resep/${image.path}');
    await storageReference.putFile(image);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> updateResepWithImage(
    String id,
    String nama,
    String bahan,
    String langkah,
    String deskripsi,
    File images,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final resep = Resep(
            id: id,
            nama: nama,
            bahan: bahan,
            langkah: langkah,
            gambar: imageURL,
            deskripsi: deskripsi)
        .toJson();
    refDoc.set(resep);
  }

  Future<void> updateResep(String id, String nama, String bahan, String langkah,
      String deskripsi, String image) async {
    final refDoc = ref.doc(id);
    final resep = Resep(
            id: id,
            nama: nama,
            bahan: bahan,
            langkah: langkah,
            gambar: image,
            deskripsi: deskripsi)
        .toJson();
    refDoc.set(resep);
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }
}
