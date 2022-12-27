import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


//CV Yükleme Sayfası
class UploadFile extends StatelessWidget {
  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    if (file == null) {
      print("Dosya seçilmedi...");
    }

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    .ref()
    .child('files')
    .child('/some-file.pdf'); //veri tabanında kaydedtmesi

    final metadata = firebase_storage.SettableMetadata(
      contentType: 'file.pdf',
      customMetadata: {'picked-file-path' : file.path});
    print("Yükleniyor..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    print("Tamamlandı..");

    return Future.value(uploadTask);
  }
  const UploadFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: ElevatedButton(
        child: Text("Dosya Seçin"),
        onPressed: () async {
          final path = await FlutterDocumentPicker.openDocument();
          print(path);
          File file= File(path!); //ünlem yoktu
          Navigator.pop(context);

        },
      ),
    ));
  }
}
