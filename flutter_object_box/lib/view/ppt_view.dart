import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';

class PptView extends StatefulWidget {
  const PptView({Key? key}) : super(key: key);

  @override
  _PptViewState createState() => _PptViewState();
}

class _PptViewState extends State<PptView> {
  VideoPlayerController? _videoController;
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
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() {
          _videoController!.play();
        });
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      });
    // setState(() {
    //   getFile();
    // });
  }

  @override
  void dispose() {
    _videoController!.dispose();
    super.dispose();
  }

  void getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final file = result.files.first;
    final fileExt = file.extension;
    print(fileExt);
    if (fileExt == "pptx") {
      // pdfFilePath = file.path.toString();
      // fromAsset("abcd", file).then((value) {
      setState(() {
        pdfFilePath = file.path.toString();
        print("pdfFilepath $pdfFilePath");
      });
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
    final isMuted = _videoController!.value.volume == 0;
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
      body: Stack(
        children: <Widget>[
          _videoController != null && _videoController!.value.isInitialized
              ? SizedBox(
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              : const SizedBox(),
          _videoController != null && _videoController!.value.isInitialized
              ? Positioned(
                  bottom: 0, // Position at the bottom
                  left: 0, // Ensure it stretches across the width
                  right: 0,
                  child: SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _videoController!.value.isPlaying
                                    ? _videoController!.pause()
                                    : _videoController!.play();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Icon(
                                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _videoController!.setVolume(isMuted ? 1 : 0);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Icon(
                                _videoController!.value.volume != 0.0 ? Icons.volume_mute : Icons.volume_off,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )))
              : const SizedBox(),
          _videoController != null && _videoController!.value.isInitialized
              ? Positioned(
                  bottom: 0, // Position at the bottom
                  left: 0, // Ensure it stretches across the width
                  right: 0,
                  child: VideoProgressIndicator(_videoController!, allowScrubbing: true))
              : const SizedBox()
        ],
      ),
    );
  }
}
