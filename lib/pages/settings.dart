import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/show_message.dart';
import 'package:admin/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    final urlImageCTRL = new TextEditingController();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String urlImageHome =
        'https://firebasestorage.googleapis.com/v0/b/galapagosafeway-305919.appspot.com/o/home%2Ffondo.jpg?alt=media&token=b4af481b-69a8-461a-96ac-a0275b52039d';

    Future saveToDatabase(BuildContext context) async {
      final DocumentReference ref =
          firestore.collection('home').doc('homePage');

      urlImageHome = '${urlImageCTRL.text}';

      var _placeData = {
        'urlImageHome': urlImageHome,
      };

      EasyLoading.show(
          status: 'Cargando...', maskType: EasyLoadingMaskType.black);

      try {
        await ref.update(_placeData).then((value) {
          ShowMessage().success(context);
        });
      } catch (e) {
        print(e);
      }

      EasyLoading.dismiss();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Ajustes',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 5, bottom: 50),
        height: 3,
        width: 50,
        decoration: BoxDecoration(
            color: ThemeColors.secondaryColor,
            borderRadius: BorderRadius.circular(15)),
      ),
      ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.ad_units),
          ),
          title: Text('Ads'),
          trailing: Switch(
            value: context.watch<AdminBloc>().adsEnabled,
            onChanged: (bool value) async {
              if (ab.userType == 'tester') {
                openDialog(context, 'Eres un Tester',
                    'Solo los admin pueden controlar las ads!');
              } else {
                await context
                    .read<AdminBloc>()
                    .controllAds(value, context)
                    .then((value) => context.read<AdminBloc>().getAdsData());
              }
            },
          )),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        decoration: inputDecoration('Ingrese la url de imagen de inicio',
            'Imagen principal', urlImageCTRL),
        controller: urlImageCTRL,
        validator: (value) {
          if (value.isEmpty) return 'El valor está vacío';
          return null;
        },
      ),
      SizedBox(
        height: 50,
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeColors.primaryColor,
          height: 55,
          child: FlatButton(
              child: Text(
                'Actualizar fondo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                saveToDatabase(context);
              })),
    ]);
  }
}
