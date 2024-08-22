import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:open_file/open_file.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
// import 'package:path_provider/path_provider.dart';

class DownloadAndPreview extends StatefulWidget {
  const DownloadAndPreview({Key? key}) : super(key: key);

  @override
  _DownloadAndPreviewState createState() => _DownloadAndPreviewState();
}

class _DownloadAndPreviewState extends State<DownloadAndPreview> {
  List<String> imgExtensions = ["jpg", "jpeg", "png", "webp", "svg"];
  File? imgFile;
  bool initialized = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      getFile();
    });
  }

  void getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.first;

    final fileExt = file.extension;

    // if (fileExt == "pdf") {
    initPlatformState();
    openDocument(file.path.toString());
    // OpenFile.open(file.path!);
    // }
    // else if (imgExtensions.contains(fileExt)) {
    //   setState(() {
    //     imgFile = File(file.path!);
    //   });
    //   print("image file $fileExt");
    // }
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

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize("demo:1724306290342:7e45a0cf030000000007df7b1b357a8b59f3667fbf12c91fdb2d8f6cb5");
      if (mounted) {
        setState(() {
          initialized = true;
        });
      }
    } on PlatformException {
      // stub
    }
  }

  void openDocument(String document) {
    // configure the viewer by setting the config fields
    Config config = Config();
    PdftronFlutter.openDocument(document, config: config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: Column(
        children: [
          imgFile != null
              ? SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: PhotoView(imageProvider: FileImage(imgFile!)),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
