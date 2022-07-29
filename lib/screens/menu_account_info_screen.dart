import 'package:flutter/material.dart';

import '../utilities/consts.dart';

class MenuAccountInfoScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Bilgileri"),
      ),
      body: Column(),
    );
  }

}