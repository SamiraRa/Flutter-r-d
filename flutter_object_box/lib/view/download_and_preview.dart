import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

class DownloadAndPreview extends StatefulWidget {
  const DownloadAndPreview({Key? key}) : super(key: key);

  @override
  _DownloadAndPreviewState createState() => _DownloadAndPreviewState();
}

class _DownloadAndPreviewState extends State<DownloadAndPreview> {
  List<String> imgExtensions = ["jpg", "jpeg", "png", "webp", "svg"];
  File? imgFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      getFile();
    });
  }

  void getFile() async {
    final result = await FilePicker.platform.pickFiles();
    final file = result!.files.first;

    final fileExt = file.extension;

    if (fileExt == "pdf") {
      OpenFile.open(file.path!);
    } else if (imgExtensions.contains(fileExt)) {
      imgFile = File(file.path!);
    }
    // Directory tempDirect = await getTemporaryDirectory();
    // String tempPath = tempDirect.path;
    // print(tempPath);

    // //================================================================
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDirPath = appDocDir.path;
    // final file = File('$appDirPath');
    // print(appDirPath);

    // //================================================================
    // Directory? externalStorageDir = await getExternalStorageDirectory();
    // String externalFilePath = externalStorageDir!.path;
    // print(externalFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Preview"),
      ),
      body: Column(
        children: [
          imgFile != null
              ? SizedBox(
                  child: Text(""),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
