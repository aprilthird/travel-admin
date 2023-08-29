import 'dart:js';
import 'dart:typed_data';

import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/models/on_boarding_image.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateOnBoardingController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseStorage storage = FirebaseStorage.instance;

  final String collectionName = 'on_boarding';

  final String docName = 'image';

  OnBoardingImage onBoardingData = Get.arguments;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List paths = [];
  String _helperText =
      'Enter paths list to help users to go to the desired destination like : Dhaka to Sylhet by Bus - 200Tk.....';
  bool uploadStarted = false;
  var dataSelection;

  String urlIMG = '';
  String date = '';
  String timestamp = '';

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String> uploadFile(FilePickerResult file, BuildContext context) async {
    EasyLoading.show(
        status: 'Cargando...', maskType: EasyLoadingMaskType.black);

    try {
      Uint8List fileBytes = file.files.first.bytes;
      String fileName = file.files.first.name;

      await storage
          .ref('on_boarding/images/$fileName')
          .putData(fileBytes, SettableMetadata(contentType: 'image'));
      urlIMG =
          await storage.ref('on_boarding/images/$fileName').getDownloadURL();

      ShowMessage().success(context);

      update();
    } on FirebaseException catch (e) {
      ShowMessage().error(context);
      print(e);
    }
    EasyLoading.dismiss();
  }

  void handleSubmit(BuildContext context) async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

    if (ab.userType == 'tester') {
      openDialog(context, 'You are a Tester',
          'Only Admin can upload, delete & modify contents');
    } else {
      //setState(()=> uploadStarted = true);
      uploadStarted = true;
      final now = DateTime.now();
      date = DateFormat('dd MMMM yy').format(now);
      timestamp = DateFormat('yyyyMMddHHmmss').format(now);
      update();
      await saveToDatabase();
      update();
      uploadStarted = false;
      openDialog(context, 'Updated Successfully', '');
    }
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(docName);

    var _placeData = {
      'url': urlIMG,
      'timestamp': timestamp,
      'date': date,
    };

    await ref.update(_placeData).then((value) => {});
  }

  Future getData() async {
    firestore
        .collection(collectionName)
        .doc(docName)
        .get()
        .then((DocumentSnapshot snap) {
      urlIMG = snap['url'];
      date = snap['date'];
      timestamp = snap['timestamp'];
    });
  }
}
