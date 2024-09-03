import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/model/media_data.dart';
import 'package:flutter_object_box/model/user_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:video_player/video_player.dart';

class PptView extends StatefulWidget {
  const PptView({Key? key}) : super(key: key);

  @override
  _PptViewState createState() => _PptViewState();
}

class _PptViewState extends State<PptView> {
  VideoPlayerController? _videoController;
  // final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pdfFilePath = "";
  Uint8List? pdfFileBytes;
  File? videoFile;
  bool isMuted = false;
  final Box<User> userBox = store.box<User>();
  Duration duration = Duration.zero;

  DateTime startedPlaying = DateTime.now();
  Duration currentPlayedTime = Duration.zero;
  @override
  void initState() {
    super.initState();
    setState(() {
      print(duration);
      getFile();
    });
  }

  @override
  void dispose() {
    _videoController!.dispose();

    super.dispose();
  }

  void getFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        videoFile = File(result.files.single.path!);
        initializeVideoPlayer();
      });
    }
  }

  void initializeVideoPlayer() {
    _videoController = VideoPlayerController.file(videoFile!)
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() {
          _videoController!.play();

          currentPlayedTime += DateTime.now().difference(startedPlaying);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController != null) {
      isMuted = _videoController!.value.volume == 0;
    }

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
          // SizedBox(
          //     height: 250,
          //     width: 80,
          //     child: Container(
          //       child: Text("FileName"),
          //     )),
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
                  child: VideoProgressIndicator(_videoController!, allowScrubbing: true))
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Text(currentPlayedTime.toString()),
                          ),
                        ],
                      )
                    ],
                  )))
              : const SizedBox(),
        ],
      ),
    );
  }
}
