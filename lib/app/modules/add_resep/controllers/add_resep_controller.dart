import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resep_makanan/app/data/resep.dart';

class AddResepController extends GetxController {
  final image = XFile("").obs;

  CollectionReference ref = FirebaseFirestore.instance.collection('resep');
  TextEditingController namaController = TextEditingController();
  TextEditingController bahanController = TextEditingController();
  TextEditingController langkahController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  Future getImage(bool gallery) async {
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
      image.value = pickedFile;
    }
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('resep/${image.path}');
    await storageReference.putFile(image);
    print('File Uploaded');
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> addResep(
    File images,
    String nama,
    String deskripsi,
    String bahan,
    String langkah,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc();
    final resep = Resep(
            id: refDoc.id,
            nama: nama,
            bahan: bahan,
            langkah: langkah,
            gambar: imageURL,
            deskripsi: deskripsi)
        .toJson();
    refDoc.set(resep);
  }

  Future<void> editMenu(
    String id,
    String nama,
    int harga,
    String jenis,
    File images,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL
    };
    refDoc.set(data);
  }
}
