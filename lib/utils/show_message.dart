
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ShowMessage{

  success(BuildContext context){
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      title: 'Mensaje',
      message: 'Se subíó correctamente la imagen',
      backgroundColor: Colors.green,
      titleColor: Colors.white,
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  error(BuildContext context){
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      title: 'Mensaje',
      message: 'Hubo un error en el sistema',
      backgroundColor: Colors.red,
      titleColor: Colors.white,
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}