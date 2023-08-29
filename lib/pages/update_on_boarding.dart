import 'dart:typed_data';

import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/controllers/update_on_boarding_controller.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/show_message.dart';
import 'package:admin/widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateOnBoardingPage extends StatefulWidget {
  UpdateOnBoardingPage({Key key}) : super(key: key);

  @override
  _UpdateOnBoardingPageState createState() => _UpdateOnBoardingPageState();
}

class _UpdateOnBoardingPageState extends State<UpdateOnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.lazyPut(() => UpdateOnBoardingController(), fenix: true);
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: GetBuilder<UpdateOnBoardingController>(builder: (_) {
        return CoverWidget(
          widget: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: h * 0.10,
                ),
                Text(
                  'Imagen de Inicio',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: _.onBoardingData.imageUrl.isNotEmpty,
                        replacement: SizedBox(
                          height: 120.0,
                        ),
                        child: Material(
                          child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[200],
                              ),
                              height: 120.0,
                              child: Image.network(
                                  '${_.onBoardingData.imageUrl}')),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              _.uploadFile(result, context);
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
                                  'Subir Imagen',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
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
                        visible: _.urlIMG.isNotEmpty,
                        replacement: SizedBox(
                          height: 120.0,
                        ),
                        child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[200],
                            ),
                            height: 120.0,
                            child: Image.network('${_.urlIMG}')),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  color: ThemeColors.primaryColor,
                  height: 45,
                  child: _.uploadStarted == true
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
                            'Actualizar Imagen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            _.handleSubmit(context);
                          },
                        ),
                ),

                /**/
              ],
            ),
          ),
        );
      }),
    );
  }
}
