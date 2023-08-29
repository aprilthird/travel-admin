

import 'dart:typed_data';

import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/models/category.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UpdateCategoryController extends GetxController{

  final titleCtrl = new TextEditingController();
  final titleSPCtrl = new TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseStorage storage = FirebaseStorage.instance;

  final String collectionName = 'categories';

  Category categoryData = Get.arguments;


  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List paths =[];
  String _helperText = 'Enter paths list to help users to go to the desired destination like : Dhaka to Sylhet by Bus - 200Tk.....';
  bool uploadStarted = false;
  //var stateSelection;
  var categorySelection;

  String urlICON = '';
  String urlIMGBG = '';


  @override
  void onInit() {
    super.onInit();
    getCategoryData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String> uploadFile(FilePickerResult file, int position, BuildContext context) async {

    EasyLoading.show(status: 'Cargando...', maskType: EasyLoadingMaskType.black);

    try {
      if (position == 0){

        Uint8List fileBytes = file.files.first.bytes;
        String fileName = file.files.first.name;

        //String basename = path.basename(file.);
        await storage.ref('categories/icons/$fileName').putData(fileBytes, SettableMetadata(
            contentType: 'image'
        ));

        urlICON = await storage.ref('categories/icons/$fileName').getDownloadURL();

        ShowMessage().success(context);

        update();

      }

      if (position == 1){

        Uint8List fileBytes = file.files.first.bytes;
        String fileName = file.files.first.name;

        //String basename = path.basename(file.);
        await storage.ref('categories/BG/$fileName').putData(fileBytes, SettableMetadata(
            contentType: 'image'
        ));

        urlIMGBG = await storage.ref('categories/BG/$fileName').getDownloadURL();

        ShowMessage().success(context);

        update();
      }


    } on FirebaseException catch (e) {

      ShowMessage().error(context);
      print(e);
    }
    EasyLoading.dismiss();
  }



  void handleSubmit(BuildContext context) async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

      if (ab.userType == 'tester') {
        openDialog(context, 'You are a Tester', 'Only Admin can upload, delete & modify contents');
      } else {
        //setState(()=> uploadStarted = true);
        uploadStarted = true;
        update();
        await saveToDatabase();
        update();
        uploadStarted = false;
        openDialog(context, 'Updated Successfully', '');
        //clearFields();
      }
  }

  Future saveToDatabase() async {
    final DocumentReference ref = firestore.collection(collectionName).doc(categoryData.timestamp);

    var _placeData = {
      'image' : urlICON,
      'imageBG' : urlIMGBG,
      'name' : titleCtrl.text,
      'nameSP': titleSPCtrl.text,
    };

    await ref.update(_placeData)
        .then((value) => {

    });
  }


  Future getCategoryData () async {
    firestore.collection(collectionName).doc(categoryData.timestamp).get().then((DocumentSnapshot snap){

      titleCtrl.text = snap['name'];
      titleSPCtrl.text = snap['nameSP'];
      urlICON = snap['image'];
      urlIMGBG = snap['imageBG'];
      /*var x = snap;
      startpointNameCtrl.text = x['startpoint name'];
      endpointNameCtrl.text = x['endpoint name'];
      startpointLatCtrl.text = x['startpoint lat'].toString();
      startpointLngCtrl.text = x['startpoint lng'].toString();
      endpointLatCtrl.text = x['endpoint lat'].toString();
      endpointLngCtrl.text = x['endpoint lng'].toString();
      priceCtrl.text = x['price'];*/
    });

  }

}