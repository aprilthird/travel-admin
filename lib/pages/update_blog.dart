import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/models/blog.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/styles.dart';
import 'package:admin/widgets/blog_preview.dart';
import 'package:admin/widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBlog extends StatefulWidget {
  final Blog blogData;
  UpdateBlog({Key key, @required this.blogData}) : super(key: key);

  @override
  _UpdateBlogState createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();
  var titleCtrl = TextEditingController();
  var titleSPCtrl = TextEditingController();
  var imageUrlCtrl = TextEditingController();
  var sourceCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var descriptionSPCtrl = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //bool notifyUsers = true;
  bool uploadStarted = false;

  void handleSubmit() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ab.userType == 'tester') {
        openDialog(context, 'Eres un Tester',
            'Solo los admin pueden subir, borrar y modificar contenido');
      } else {
        setState(() => uploadStarted = true);
        await updateDatabase();
        setState(() => uploadStarted = false);
        openDialog(context, 'Actualizado exitosamente', '');
      }
    }
  }

  Future updateDatabase() async {
    final DocumentReference ref =
        firestore.collection('blogs').doc(widget.blogData.timestamp);
    var _blogData = {
      'title': titleCtrl.text,
      'titleSP': titleSPCtrl.text,
      'description': descriptionCtrl.text,
      'descriptionSP': descriptionSPCtrl.text,
      'image url': imageUrlCtrl.text,
      'source': sourceCtrl.text,
    };
    await ref.update(_blogData);
  }

  clearTextFeilds() {
    titleCtrl.clear();
    titleSPCtrl.clear();
    descriptionCtrl.clear();
    descriptionSPCtrl.clear();
    imageUrlCtrl.clear();
    sourceCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  handlePreview() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await showBlogPreview(
          context,
          titleCtrl.text,
          descriptionCtrl.text,
          imageUrlCtrl.text,
          widget.blogData.loves,
          sourceCtrl.text,
          widget.blogData.date);
    }
  }

  initBlogData() {
    Blog d = widget.blogData;
    titleCtrl.text = d.title;
    titleSPCtrl.text = d.titleSP;
    descriptionCtrl.text = d.description;
    descriptionSPCtrl.text = d.descriptionSP;
    imageUrlCtrl.text = d.thumbnailImagelUrl;
    sourceCtrl.text = d.sourceUrl;
  }

  @override
  void initState() {
    super.initState();
    initBlogData();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(),
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CoverWidget(
          widget: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: h * 0.10,
                  ),
                  Text(
                    'Actualizar detalles del Blog',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    decoration: inputDecoration(
                        'Ingrese Título (Inglés)', 'Título Inglés', titleCtrl),
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
                    decoration: inputDecoration('Ingrese Título (Español)',
                        'Título Español', titleSPCtrl),
                    controller: titleSPCtrl,
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
                        'Ingrese Image Url', 'Image', imageUrlCtrl),
                    controller: imageUrlCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'El valor está vacíoy';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: inputDecoration(
                        'Ingrese Source Url', 'Source Url', sourceCtrl),
                    controller: sourceCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'El valor está vacío';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText:
                            'Ingrese la descripción (Html o Texto) (Inglés)',
                        border: OutlineInputBorder(),
                        labelText: 'Descripción Inglés',
                        contentPadding: EdgeInsets.only(
                            right: 0, left: 10, top: 15, bottom: 5),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                                icon: Icon(Icons.close, size: 15),
                                onPressed: () {
                                  descriptionCtrl.clear();
                                }),
                          ),
                        )),
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'El valor está vacío';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText:
                            'Ingrese la descripción (Html o Texto) (Español)',
                        border: OutlineInputBorder(),
                        labelText: 'Descripción Español',
                        contentPadding: EdgeInsets.only(
                            right: 0, left: 10, top: 15, bottom: 5),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                                icon: Icon(Icons.close, size: 15),
                                onPressed: () {
                                  descriptionSPCtrl.clear();
                                }),
                          ),
                        )),
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionSPCtrl,
                    validator: (value) {
                      if (value.isEmpty) return 'El valor está vacío';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton.icon(
                          icon: Icon(
                            Icons.remove_red_eye,
                            size: 25,
                            color: Colors.blueAccent,
                          ),
                          label: Text(
                            'Preview',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            handlePreview();
                          })
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                                'Subir Blog',
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
        ));
  }
}
