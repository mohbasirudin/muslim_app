import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quran/baseurl/base_app.dart';
import 'package:quran/baseurl/base_asset.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Size.size16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 200,
                        color: Colors.blue,
                        foregroundDecoration: BoxDecoration(
                            image: DecorationImage(
                                image: ExactAssetImage(BaseAsset.bgPicture),
                                fit: BoxFit.cover)),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              width: 50,
                              alignment: Alignment.center,
                              height: 50,
                              color: Colors.grey.withOpacity(0.1),
                              child: Center(
                                child: Image.asset(BaseAsset.ppProfil),
                              ),
                            ),
                          ),
                        )),
                    Text('mo')
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
