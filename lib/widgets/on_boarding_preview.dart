import 'package:admin/utils/cached_image.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';

Future showOnBoardingPreview(
    context, String thumbnailUrl, String date, String timestamp) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.50,
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child:
                        CustomCacheImage(imageUrl: thumbnailUrl, radius: 0.0),
                  ),
                  Positioned(
                    top: 10,
                    right: 20,
                    child: CircleAvatar(
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      date,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10),
                      height: 3,
                      width: 100,
                      decoration: BoxDecoration(
                        color: ThemeColors.secondaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
