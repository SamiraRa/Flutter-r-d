import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
// import 'package:path_provider/path_provider.dart';

class DownloadAndPreview extends StatefulWidget {
  const DownloadAndPreview({Key? key}) : super(key: key);

  @override
  _DownloadAndPreviewState createState() => _DownloadAndPreviewState();
}

class _DownloadAndPreviewState extends State<DownloadAndPreview> {
  List<String> imgExtensions = ["jpg", "jpeg", "png", "webp"];
  File? imgFile;
  File? svgImageFile;
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

    if (fileExt == "pdf") {
      OpenFile.open(file.path!);
    } else if (imgExtensions.contains(fileExt)) {
      setState(() {
        imgFile = File(file.path!);
      });
      print("image file $fileExt");
    } else if (fileExt == "svg") {
      print(fileExt);
      setState(() {
        svgImageFile = File(file.path!);
      });
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
              : svgImageFile != null
                  ? SvgPicture.file(
                      svgImageFile!,
                      height: 400,
                      width: double.infinity,
                    )
                  : const SizedBox()
        ],
      ),
    );
  }
}
