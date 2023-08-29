import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/controllers/update_category_controller.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/styles.dart';
import 'package:admin/widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UpdateCategoryPage extends StatefulWidget {
  const UpdateCategoryPage({Key key}) : super(key: key);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.lazyPut(() => UpdateCategoryController(), fenix: true);
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: GetBuilder<UpdateCategoryController>(builder: (_) {
        return CoverWidget(
          widget: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: h * 0.10,
                ),
                Text(
                  'Detalles de la categoría',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'Ingrese el Título Inglés', 'Título Inglés', _.titleCtrl),
                  controller: _.titleCtrl,
                  validator: (value) {
                    if (value.isEmpty) return 'El valor está vacío';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration('Ingrese el Título Español',
                      'Título Español', _.titleSPCtrl),
                  controller: _.titleSPCtrl,
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
                      child: Visibility(
                        visible: _.categoryData.imageBG.isNotEmpty,
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
                              child:
                                  Image.network('${_.categoryData.imageUrl}')),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: Visibility(
                        visible: _.categoryData.imageBG.isNotEmpty,
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
                              child:
                                  Image.network('${_.categoryData.imageBG}')),
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
                              _.uploadFile(result, 0, context);
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
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: Material(
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              _.uploadFile(result, 1, context);
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
                        visible: _.urlICON.isNotEmpty,
                        replacement: SizedBox(
                          height: 120.0,
                        ),
                        child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[200],
                            ),
                            height: 120.0,
                            child: Image.network('${_.urlICON}')),
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: Visibility(
                        visible: _.urlIMGBG.isNotEmpty,
                        replacement: SizedBox(
                          height: 120.0,
                        ),
                        child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[200],
                            ),
                            height: 120.0,
                            child: Image.network('${_.urlIMGBG}')),
                      ),
                    ),
                  ],
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
                              'Subir datos del lugar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              _.handleSubmit(context);
                            })),

                /**/
              ],
            ),
          ),
        );
      }),
    );
  }
}
