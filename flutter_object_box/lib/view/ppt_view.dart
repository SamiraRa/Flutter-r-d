import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class PptView extends StatefulWidget {
  const PptView({Key? key}) : super(key: key);

  @override
  _PptViewState createState() => _PptViewState();
}

class _PptViewState extends State<PptView> {
  // final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pdfFilePath = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      getFile();
    });
  }

  void getFile() async {
    final permission = await Permission.storage.request();
    Completer<File> completer = Completer();

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.first;
    final fileExt = file.extension;

    if (permission.isGranted) {
      if (fileExt == "pdf") {
        // fromAsset(file.path.toString(), "abcd", file).then((value) {
        //   setState(() {
        //     pdfFilePath = file.path.toString();
        //   });
        // File newFile = File(pdfFilePath);
        // var data = await rootBundle.load(pdfFilePath);
        // var bytes = data.buffer.asUint8List();
        // newFile.writeAsBytesSync(bytes, flush: true);

        // completer.complete(newFile);
        // });
        // OpenFile.open(file.path!);
      }
    }
  }

  // Future fromAsset(String asset, String filename, PlatformFile platformfile) async {
  //   // To open from assets, you can copy them to the app storage folder, and the access them "locally"
  //   Completer<File> completer = Completer();

  //   try {
  //     // var dir = await getApplicationDocumentsDirectory();
  //     File file = File(platformfile.path!);
  //     var data = await rootBundle.load(platformfile.path!);
  //     var bytes = data.buffer.asUint8List();

  //     await file.writeAsBytes(bytes, flush: true);
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }

  //   // return completer.future;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: pdfFilePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false, // if set to true the link is handled in flutter
            onRender: (p) {
              setState(() {
                pages = p;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            // onViewCreated: (PDFViewController pdfViewController) {
            //   _controller.complete(pdfViewController);
            // },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         label: Text("Go to ${pages! ~/ 2}"),
      //         onPressed: () async {
      //           await snapshot.data!.setPage(pages! ~/ 2);
      //         },
      //       );
      //     }

      //     return Container();
      //   },
      // ),
    );
  }
}
