import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadAndPreview extends StatefulWidget {
  const DownloadAndPreview({Key? key}) : super(key: key);

  @override
  _DownloadAndPreviewState createState() => _DownloadAndPreviewState();
}

class _DownloadAndPreviewState extends State<DownloadAndPreview> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getFile();
    });
  }

  void getFile() async {
    Directory tempDirect = await getTemporaryDirectory();
    String tempPath = tempDirect.path;
    print(tempPath);

    //================================================================
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDirPath = appDocDir.path;
    final file = File('$appDirPath');
    print(appDirPath);

    //================================================================
    Directory? externalStorageDir = await getExternalStorageDirectory();
    String externalFilePath = externalStorageDir!.path;
    print(externalFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Preview"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
