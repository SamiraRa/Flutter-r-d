import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfTronFlutterScreen extends StatefulWidget {
  const PdfTronFlutterScreen({Key? key}) : super(key: key);

  @override
  _PdfTronFlutterScreenState createState() => _PdfTronFlutterScreenState();
}

class _PdfTronFlutterScreenState extends State<PdfTronFlutterScreen> {
  bool initialized = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      getFile();
    });
    // initPlatformState();
    // launchWithPermission();
  }

  getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.first;

    final fileExt = file.extension;
    initPlatformState();
    openDocument(file.path.toString());
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
        body: Column(
      children: [],
    ));
  }

  // Future<void> launchWithPermission() async {
  //   PermissionStatus permission = await Permission.storage.request();
  //   if (permission.isGranted) {
  //     showViewer();
  //   }
  // }

  // void showViewer() async {
  //   String filePathTemp = "";
  //   // Opening without a config file will have all functionality enabled.
  //   // await PdftronFlutter.openDocument(_document);

  //   var config = Config();
  //   // How to disable functionality:
  //   //      config.disabledElements = [Buttons.shareButton, Buttons.searchButton];
  //   //      config.disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
  //   // Other viewer configurations:
  //   //      config.multiTabEnabled = true;
  //   //      config.customHeaders = {'headerName': 'headerValue'};

  //   // An event listener for document loading
  //   var documentLoadedCancel = startDocumentLoadedListener((filePath) {
  //     filePathTemp = filePath;

  //     print("document loaded: $filePath");
  //   });

  //   await PdftronFlutter.openDocument(filePathTemp, config: config);

  //   try {
  //     // The imported command is in XFDF format and tells whether to add,
  //     // modify or delete annotations in the current document.
  //     PdftronFlutter.importAnnotationCommand(
  //         "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n    <xfdf xmlns=\"http://ns.adobe.com/xfdf/\" xml:space=\"preserve\">\n      <add>\n        <square style=\"solid\" width=\"5\" color=\"#E44234\" opacity=\"1\" creationdate=\"D:20200619203211Z\" flags=\"print\" date=\"D:20200619203211Z\" name=\"c684da06-12d2-4ccd-9361-0a1bf2e089e3\" page=\"1\" rect=\"113.312,277.056,235.43,350.173\" title=\"\" />\n      </add>\n      <modify />\n      <delete />\n      <pdf-info import-version=\"3\" version=\"2\" xmlns=\"http://www.pdftron.com/pdfinfo\" />\n    </xfdf>");
  //   } on PlatformException catch (e) {
  //     print("Failed to importAnnotationCommand '${e.message}'.");
  //   }

  //   try {
  //     PdftronFlutter.importBookmarkJson('{"0":"Page 1"}');
  //   } on PlatformException catch (e) {
  //     print("Failed to importBookmarkJson '${e.message}'.");
  //   }

  //   // An event listener for when local annotation changes are committed
  //   // to the document. xfdfCommand is the XFDF Command of the annotation
  //   // that was last changed.
  //   var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
  //     // Local annotation changed.
  //     // Upload XFDF command to server here.
  //     String command = xfdfCommand;
  //     // Dart limits how many characters are printed onto the console.
  //     // The code below ensures that all of the XFDF command is printed.
  //     if (command.length > 1024) {
  //       print("flutter xfdfCommand:\n");
  //       int start = 0;
  //       int end = 1023;
  //       while (end < command.length) {
  //         print(command.substring(start, end) + "\n");
  //         start += 1024;
  //         end += 1024;
  //       }
  //       print(command.substring(start));
  //     } else {
  //       print(command);
  //     }
  //   });

  //   // An event listener for when local bookmark changes are committed to
  //   // the document. bookmarkJson is the JSON string containing all the
  //   // bookmarks that exist when the change was made.
  //   var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
  //     print("flutter bookmark: $bookmarkJson");
  //   });

  //   var path = await PdftronFlutter.saveDocument();
  //   print("flutter save: $path");

  //   // To cancel event:
  //   // annotCancel();
  //   // bookmarkCancel();
  //   // documentLoadedCancel();
  // }
}
