import 'dart:io';
import 'dart:typed_data';

import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/show_message.dart';
import 'package:admin/utils/styles.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UploadCategory extends StatefulWidget {
  UploadCategory({Key key}) : super(key: key);

  @override
  _UploadCategoryState createState() => _UploadCategoryState();
}

class _UploadCategoryState extends State<UploadCategory> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  var formKey = GlobalKey<FormState>();
  var titleCtrl = TextEditingController();
  var titleSPCtrl = TextEditingController();
  /*var imageUrlCtrl = TextEditingController();
  var imageBGUrlCtrl = TextEditingController();*/
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool notifyUsers = true;
  bool uploadStarted = false;
  String _timestamp;
  String _date;
  //List<String> _listIMG = [];
  String _urlICON = '';
  String _urlIMGBG = '';
  var _categoryData;

  void handleSubmit() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ab.userType == 'tester') {
        openDialog(context, 'Eres un Tester',
            'Solo el admin puede subir, borrar y modificar contenido');
      } else {
        setState(() => uploadStarted = true);
        await getDate().then((_) async {
          await saveToDatabase().then((value) =>
              context.read<AdminBloc>().increaseCount('categories_count'));
          setState(() => uploadStarted = false);
          openDialog(context, 'Subido exitosamente', '');
          clearTextFeilds();
        });
      }
    }
  }

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _timestamp = _t;
      _date = _d;
    });
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection('categories').doc(_timestamp);
    _categoryData = {
      'name': titleCtrl.text,
      'nameSP': titleSPCtrl.text,
      'image': _urlICON,
      'imageBG': _urlIMGBG,
      'date': _date,
      'timestamp': _timestamp
    };
    await ref.set(_categoryData);
  }

  clearTextFeilds() {
    titleCtrl.clear();
    titleSPCtrl.clear();
    /*imageUrlCtrl.clear();
    imageBGUrlCtrl.clear();*/
    _urlICON = '';
    _urlIMGBG = '';
    setState(() {});
    FocusScope.of(context).unfocus();
  }

  /*Future<String> uploadFile(XFile xfile, int position) async {
    try {
      if (position == 0){

        //var file = File.fromRawPath(fileBytes);
        await storage.ref('$fileName').putFile();
        _urlICON = await storage.ref('$fileName').getDownloadURL();

      } if (position == 1){

        await storage.ref('$fileName').putData(fileBytes);
        _urlIMGBG = await storage.ref('$fileName').getDownloadURL();

      }


    } on FirebaseException catch (e) {
      print(e);
    }
  }*/

  Future<String> uploadFile(FilePickerResult file, int position) async {
    EasyLoading.show(
        status: 'Cargando...', maskType: EasyLoadingMaskType.black);

    try {
      if (position == 0) {
        Uint8List fileBytes = file.files.first.bytes;
        String fileName = file.files.first.name;

        //String basename = path.basename(file.);
        await storage
            .ref('categories/icons/$fileName')
            .putData(fileBytes, SettableMetadata(contentType: 'image'));

        _urlICON =
            await storage.ref('categories/icons/$fileName').getDownloadURL();

        ShowMessage().success(context);

        setState(() {});
      }

      if (position == 1) {
        Uint8List fileBytes = file.files.first.bytes;
        String fileName = file.files.first.name;

        //String basename = path.basename(file.);
        await storage
            .ref('categories/BG/$fileName')
            .putData(fileBytes, SettableMetadata(contentType: 'image'));
        _urlIMGBG =
            await storage.ref('categories/BG/$fileName').getDownloadURL();

        ShowMessage().success(context);

        setState(() {});
      }
    } on FirebaseException catch (e) {
      ShowMessage().error(context);
      print(e);
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: h * 0.10,
              ),
              Text(
                'Detalles de categoría',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Ingrese el Título Inglés', 'Título Inglés', titleCtrl),
                controller: titleCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Ingrese el Título Español', 'Título Español', titleSPCtrl),
                controller: titleSPCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          uploadFile(result, 0);
                        }
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                        ),
                        height: 120.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              color: Colors.grey[300],
                              size: 50,
                            ),
                            Text(
                              'Subir icono',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          uploadFile(result, 1);
                        }
                      },
                      borderRadius: BorderRadius.circular(10.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                        ),
                        height: 120.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              color: Colors.grey[300],
                              size: 50,
                            ),
                            Text(
                              'Subir imagen',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: _urlICON.isNotEmpty,
                      replacement: SizedBox(
                        height: 120.0,
                      ),
                      child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[200],
                          ),
                          height: 120.0,
                          child: Image.network('$_urlICON')),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: Visibility(
                      visible: _urlIMGBG.isNotEmpty,
                      replacement: SizedBox(
                        height: 120.0,
                      ),
                      child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[200],
                          ),
                          height: 120.0,
                          child: Image.network('$_urlIMGBG')),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  color: ThemeColors.primaryColor,
                  height: 45,
                  child: uploadStarted == true
                      ? Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: ThemeColors.secondaryColor,
                            ),
                          ),
                        )
                      : FlatButton(
                          child: Text(
                            'Subir Categoría',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            handleSubmit();
                          })),
              SizedBox(
                height: 200,
              ),
            ],
          )),
    );
  }
}
