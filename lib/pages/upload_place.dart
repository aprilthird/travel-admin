import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/styles.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/widgets/place_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UploadPlace extends StatefulWidget {
  UploadPlace({Key key}) : super(key: key);

  @override
  _UploadPlaceState createState() => _UploadPlaceState();
}

class _UploadPlaceState extends State<UploadPlace> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'places';
  List paths = [];
  final int _loves = 0;
  final int _commentsCount = 0;
  String _date;
  String _timestamp;
  String _helperText =
      'Enter paths list to help users to go to the desired destination like : Dhaka to Sylhet by Bus - 200Tk.....';

  var stateSelection;
  var categorySelection;

  var nameCtrl = TextEditingController();
  var nameSPCtrl = TextEditingController();
  var locationCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var descriptionSPCtrl = TextEditingController();
  var image1Ctrl = TextEditingController();
  var image2Ctrl = TextEditingController();
  var image3Ctrl = TextEditingController();

  var image1GalleryCtrl = TextEditingController();
  var image2GalleryCtrl = TextEditingController();
  var image3GalleryCtrl = TextEditingController();
  var image4GalleryCtrl = TextEditingController();
  var image5GalleryCtrl = TextEditingController();
  var image6GalleryCtrl = TextEditingController();

  var mobilePhoneCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var image4Ctrl = TextEditingController();
  var latCtrl = TextEditingController();
  var lngCtrl = TextEditingController();
  var priceByAppCtrl = TextEditingController();
  var priceByAppSPCtrl = TextEditingController();

  var startpointNameCtrl = TextEditingController();
  var endpointNameCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var startpointLatCtrl = TextEditingController();
  var startpointLngCtrl = TextEditingController();
  var endpointLatCtrl = TextEditingController();
  var endpointLngCtrl = TextEditingController();

  clearFields() {
    nameCtrl.clear();
    nameSPCtrl.clear();
    locationCtrl.clear();
    descriptionCtrl.clear();
    descriptionSPCtrl.clear();
    image1Ctrl.clear();
    image2Ctrl.clear();
    image3Ctrl.clear();
    image4Ctrl.clear();
    image1GalleryCtrl.clear();
    image2GalleryCtrl.clear();
    image3GalleryCtrl.clear();
    image4GalleryCtrl.clear();
    image5GalleryCtrl.clear();
    image6GalleryCtrl.clear();
    mobilePhoneCtrl.clear();
    emailCtrl.clear();
    latCtrl.clear();
    lngCtrl.clear();
    priceByAppCtrl.clear();
    priceByAppSPCtrl.clear();
    startpointNameCtrl.clear();
    endpointNameCtrl.clear();
    priceCtrl.clear();
    startpointLatCtrl.clear();
    startpointLngCtrl.clear();
    endpointLatCtrl.clear();
    endpointLngCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  bool notifyUsers = true;
  bool uploadStarted = false;

  void handleSubmit() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);

    if (stateSelection == null) {
      openDialog(context, 'Select State First', '');
    } else {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        if (ab.userType == 'tester') {
          openDialog(context, 'Eres un Tester',
              'Solo los admin pueden subir, borrar y modificar contenido');
        } else {
          setState(() => uploadStarted = true);
          await getDate().then((_) async {
            await saveToDatabase().then((value) =>
                context.read<AdminBloc>().increaseCount('places_count'));
            setState(() => uploadStarted = false);
            openDialog(context, 'Subido exitosamente', '');
            clearFields();
          });
        }
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
        firestore.collection(collectionName).doc(_timestamp);
    final DocumentReference ref1 = firestore
        .collection(collectionName)
        .doc(_timestamp)
        .collection('travel guide')
        .doc(_timestamp);

    var _placeData = {
      'state': stateSelection,
      'category': categorySelection,
      'place name': nameCtrl.text,
      'place_name_sp': nameSPCtrl.text,
      'location': locationCtrl.text,
      'latitude': double.parse(latCtrl.text),
      'longitude': double.parse(lngCtrl.text),
      'description': descriptionCtrl.text,
      'descriptionSP': descriptionSPCtrl.text,
      'image-1': image1Ctrl.text,
      'image-2': image2Ctrl.text,
      'image-3': image3Ctrl.text,
      'image-4': image4Ctrl.text,
      'gallery-1': image1GalleryCtrl.text,
      'gallery-2': image2GalleryCtrl.text,
      'gallery-3': image3GalleryCtrl.text,
      'gallery-4': image4GalleryCtrl.text,
      'gallery-5': image5GalleryCtrl.text,
      'gallery-6': image6GalleryCtrl.text,
      'mobilePhone': mobilePhoneCtrl.text,
      'email': emailCtrl.text,
      'loves': _loves,
      'comments count': _commentsCount,
      'date': _date,
      'timestamp': _timestamp,
      'priceByApp': priceByAppCtrl.text,
      'priceByAppSP': priceByAppSPCtrl.text
    };

    var _guideData = {
      'endpoint name': endpointNameCtrl.text,
      'endpoint lat': double.parse(endpointLatCtrl.text),
      'endpoint lng': double.parse(endpointLngCtrl.text),
      'price': priceCtrl.text,
      'paths': paths
    };

    await ref.set(_placeData).then((value) => ref1.set(_guideData));
  }

  handlePreview() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (paths.isEmpty) {
        showPlacePreview(
            context,
            nameCtrl.text,
            locationCtrl.text,
            image1Ctrl.text,
            descriptionCtrl.text,
            double.parse(latCtrl.text),
            double.parse(lngCtrl.text),
            endpointNameCtrl.text,
            double.parse(endpointLatCtrl.text),
            double.parse(endpointLngCtrl.text),
            priceCtrl.text,
            paths);
      } else {
        openToast(context, 'Path List is Empty!');
      }
    }
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
                'Detalles del lugar',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              statesDropdown(),
              SizedBox(
                height: 20,
              ),
              categoryDropdown(),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Ingrese nombre del lugar',
                    'Nombre del lugar Inglés', nameCtrl),
                controller: nameCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Ingrese nombre del lugar',
                    'Nombre del lugar Español', nameSPCtrl),
                controller: nameSPCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Ingrese nombre del sitio',
                    'Nombre del sitio', locationCtrl),
                controller: locationCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Ingrese la latitud', 'Latitud', latCtrl),
                      controller: latCtrl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'El valor está vacío';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Ingrese la longitud', 'Longitud', lngCtrl),
                      keyboardType: TextInputType.number,
                      controller: lngCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'El valor está vacío';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Ingrese image url (thumbnail)',
                    'Image1(Thumbnail)', image1Ctrl),
                controller: image1Ctrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    inputDecoration('Ingrese image url', 'Image2', image2Ctrl),
                controller: image2Ctrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    inputDecoration('Ingrese image url', 'Image3', image3Ctrl),
                controller: image3Ctrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    inputDecoration('Ingrese image url', 'Image4', image4Ctrl),
                controller: image4Ctrl,
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
                    'Ingrese un número telefonico', 'Número', mobilePhoneCtrl),
                controller: mobilePhoneCtrl,
                keyboardType: TextInputType.number,
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
                    'Ingrese un correo electronico', 'Correo', emailCtrl),
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'English',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter details of the Place (Html o Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Venue details',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
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
              Text(
                'Español',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Igrese detalles del Lugar (Html o Texto)',
                    border: OutlineInputBorder(),
                    labelText: 'Detalles del Lugar',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
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
                height: 50,
              ),
              Text(
                'Gallery',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Ingrese image url', 'Image gallery 1', image1GalleryCtrl),
                controller: image1GalleryCtrl,
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
                    'Ingrese image url', 'Image gallery 2', image2GalleryCtrl),
                controller: image2GalleryCtrl,
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
                    'Ingrese image url', 'Image gallery 3', image3GalleryCtrl),
                controller: image3GalleryCtrl,
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
                    'Ingrese image url', 'Image gallery 4', image4GalleryCtrl),
                controller: image4GalleryCtrl,
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
                    'Ingrese image url', 'Image gallery 5', image5GalleryCtrl),
                controller: image5GalleryCtrl,
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
                    'Ingrese image url', 'Image gallery 6', image6GalleryCtrl),
                controller: image6GalleryCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Guía de viaje detalles',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration('Ingrese nombre del destino',
                          'Nombre del destino', endpointNameCtrl),
                      controller: endpointNameCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'El valor está vacío';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    inputDecoration('Ingrese precio', 'Precio', priceCtrl),
                keyboardType: TextInputType.number,
                controller: priceCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Enter price with the application',
                    'Price with the app', priceByAppCtrl),
                controller: priceByAppCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Ingrese precio con la app',
                    'Precio con la app', priceByAppSPCtrl),
                controller: priceByAppSPCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'El valor está vacío';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration('Ingrese latitud del destino',
                          'Latitud del destino', endpointLatCtrl),
                      controller: endpointLatCtrl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'El valor está vacío';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Ingrese longitud del destino',
                          'Longitud del destino',
                          endpointLngCtrl),
                      keyboardType: TextInputType.number,
                      controller: endpointLngCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'El valor está vacío';
                        return null;
                      },
                    ),
                  ),
                ],
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
                        'Vista previa',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
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
                            'Subir datos del Lugar',
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

  Widget statesDropdown() {
    final AdminBloc ab = Provider.of(context, listen: false);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                stateSelection = value;
              });
            },
            onSaved: (value) {
              setState(() {
                stateSelection = value;
              });
            },
            value: stateSelection,
            hint: Text('Seleccionar estado'),
            items: ab.states.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }

  Widget categoryDropdown() {
    final AdminBloc ab = Provider.of(context, listen: false);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                categorySelection = value;
              });
            },
            onSaved: (value) {
              setState(() {
                categorySelection = value;
              });
            },
            value: categorySelection,
            hint: Text('Seleccionar categoría'),
            items: ab.categories.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }
}
