import 'dart:async';
import 'dart:io';

import 'package:easy_docs_viewer/easy_docs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class PptView extends StatefulWidget {
  const PptView({Key? key}) : super(key: key);

  @override
  _PptViewState createState() => _PptViewState();
}

class _PptViewState extends State<PptView> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pdfFilePath = "";
  Uint8List? pdfFileBytes;

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
    print(fileExt);
    if (fileExt == "pptx") {
      pdfFilePath = file.path.toString();
      // fromAsset("abcd", file).then((value) {
      //   setState(() {
      //     pdfFilePath = file.path.toString();
      //   });
      // });
    }
  }

  // Future fromAsset(String filename, PlatformFile platformfile) async {
  //   Completer<File> completer = Completer();
  //   try {
  //     File file = File(platformfile.path!);
  //     final bytes = await file.readAsBytes();
  //     await file.writeAsBytes(bytes, flush: true);
  //     pdfFileBytes = file.readAsBytesSync();
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PPT Files"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(children: <Widget>[
          SizedBox(width: double.infinity, height: 650, child: EasyDocsViewer(url: pdfFilePath))
        ]));
  }
}
