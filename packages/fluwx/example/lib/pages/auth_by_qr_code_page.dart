import 'dart:typed_data';

import 'package:flutter/material.dart';

class AuthByQRCodePage extends StatefulWidget {
  const AuthByQRCodePage({Key? key}) : super(key: key);

  @override
  State<AuthByQRCodePage> createState() => _AuthByQRCodePageState();
}

class _AuthByQRCodePageState extends State<AuthByQRCodePage> {
  final String _status = 'status';
  Uint8List? _image;

  @override
  void initState() {
    super.initState();

//    fluwx.onAuthByQRCodeFinished.listen((data) {
//      setState(() {
//        _status = 'errorCode=>${data.errorCode}\nauthCode=>${data.authCode}';
//      });
//    });
//    fluwx.onAuthGotQRCode.listen((image) {
//      setState(() {
//        _image = image;
//      });
//    });
//
//    fluwx.onQRCodeScanned.listen((scanned) {
//      setState(() {
//        _status = 'scanned';
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AuthByQRCode'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
//              fluwx.authByQRCode(
//                  appId: 'wxd930ea5d5a258f4f',
//                  scope: 'noncestr',
//                  nonceStr: 'nonceStr',
//                  timeStamp: '1417508194',
//                  signature: '429eaaa13fd71efbc3fd344d0a9a9126835e7303');
            },
            child: Text('AUTH NOW'),
          ),
          Text(_status),
          _qrCode()
        ],
      ),
    );
  }

  Widget _qrCode() {
    if (_image == null) {
      return Container();
    } else {
      return Image.memory(_image!);
    }
  }
}
