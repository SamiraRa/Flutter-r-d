import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/model/media_data.dart';
import 'package:flutter_object_box/model/user_model.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class PptView extends StatefulWidget {
  const PptView({Key? key}) : super(key: key);

  @override
  _PptViewState createState() => _PptViewState();
}

class _PptViewState extends State<PptView> with SingleTickerProviderStateMixin {
  double scale = 1.0;
  late AnimationController controller;
  VideoPlayerController? _videoController;
  List<VideoPlayerController> videoCntrllers = [];

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
  List galleryMedia = [];
  List<String> imgExtensions = ["jpg", "jpeg", "png", "webp"];
  File? svgImageFile;
  File? imgFile;

  DateTime startedPlaying = DateTime.now();
  Duration currentPlayedTime = Duration.zero;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {
          scale = 1 - controller.value;
        });
      });
    // setState(() {
    //   print(duration);
    //   getFile();
    // });
  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController!.dispose();
    }

    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      getFile();
    });
    controller.reverse();
  }

  void _onTapCancel() {
    controller.reverse();
  }

  void getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = result.files.first;
      setState(() {
        galleryMedia.add(file);
      });

      final fileExt = file.extension;

      if (fileExt == "pdf") {
        fromAsset(file.name, file).then((value) {
          setState(() {
            pdfFilePath = file.path.toString();
          });
        });
      } else if (fileExt == "mp4") {
        setState(() {
          videoFile = File(file.path!);
          initializeVideoPlayer(videoFile);
        });
      } else if (imgExtensions.contains(fileExt)) {
        setState(() {
          imgFile = File(file.path!);
        });
      } else if (fileExt == "svg") {
        setState(() {
          svgImageFile = File(file.path!);
        });
      } else {
        OpenFile.open(file.path!);
      }
    }
  }

  void initializeVideoPlayer(File? videoFile) {
    _videoController = VideoPlayerController.file(videoFile!)
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() {
          // _videoController!.play();

          currentPlayedTime += DateTime.now().difference(startedPlaying);
        });
      });
  }

  Future fromAsset(String filename, PlatformFile platformfile) async {
    Completer<File> completer = Completer();
    try {
      File file = File(platformfile.path!);
      final bytes = await file.readAsBytes();
      await file.writeAsBytes(bytes, flush: true);
      pdfFileBytes = file.readAsBytesSync();
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
  }

  void resetFile() {
    // if (_videoController != null) {
    //   _videoController!.dispose();
    //   _videoController = null;
    // }

    if (imgFile != null) {
      imgFile = null;
    }

    if (svgImageFile != null) {
      svgImageFile = null;
    }

    if (pdfFileBytes != null) {
      pdfFileBytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController != null) {
      isMuted = _videoController!.value.volume == 0;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Preview"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addMedia(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Gallery:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            GridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 0,
              ),
              itemCount: galleryMedia.length,
              itemBuilder: (context, index) {
                PlatformFile file = galleryMedia[index];
                if (file.extension == "mp4") {
                  if (_videoController != null && _videoController!.value.isInitialized) {
                    return

                        ///initialize videoCoontroller in here rather then at first
                        Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    );
                  }
                } else if (imgExtensions.contains(file.extension)) {
                  if (imgFile != null) {
                    return SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: PhotoView(imageProvider: FileImage(imgFile!)),
                    );
                  }
                } else if (file.extension == "svg") {
                  return SvgPicture.file(
                    svgImageFile!,
                    height: 400,
                    width: double.infinity,
                  );
                } else if (file.extension == "pdf") {
                  return SizedBox(
                    width: double.infinity,
                    height: 600,
                    child: PDFView(
                      pdfData: pdfFileBytes,
                      defaultPage: currentPage!,
                      fitPolicy: FitPolicy.BOTH,
                      onRender: (p) {
                        setState(() {
                          pages = p;
                          isReady = true;
                        });
                      },
                      // onViewCreated: (PDFViewController pdfViewController) {
                      //   _controller.complete(pdfViewController);
                      // },
                      onLinkHandler: (String? uri) {},
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }

                //  _videoController != null && _videoController!.value.isInitialized

                //     ///initialize videoCoontroller in here rather then at first
                //     ? Container(
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
                //         child: AspectRatio(
                //           aspectRatio: _videoController!.value.aspectRatio,
                //           child: VideoPlayer(_videoController!),
                //         ),
                //       )
                //     :
                // imgFile != null
                //     ? SizedBox(
                //         height: 400,
                //         width: double.infinity,
                //         child: PhotoView(imageProvider: FileImage(imgFile!)),
                //       )
                //     :
                // svgImageFile != null
                //     ? SvgPicture.file(
                //         svgImageFile!,
                //         height: 400,
                //         width: double.infinity,
                //       )
                //     :
                // pdfFileBytes != null
                //     ? SizedBox(
                //         width: double.infinity,
                //         height: 600,
                //         child: PDFView(
                //           pdfData: pdfFileBytes,
                //           defaultPage: currentPage!,
                //           fitPolicy: FitPolicy.BOTH,
                //           onRender: (p) {
                //             setState(() {
                //               pages = p;
                //               isReady = true;
                //             });
                //           },
                //           // onViewCreated: (PDFViewController pdfViewController) {
                //           //   _controller.complete(pdfViewController);
                //           // },
                //           onLinkHandler: (String? uri) {},
                //           onPageChanged: (int? page, int? total) {
                //             setState(() {
                //               currentPage = page;
                //             });
                //           },
                //         ),
                //       )
                //     : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding addMedia() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 8, 10, 0),
      child: InkWell(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(10), // Rounded corners for the shadow
          color: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.2), // Shadow color
          elevation: 8.0, // Elevation for shadow effect
          child: Transform.scale(
            scale: scale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners for the container
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: const EdgeInsets.all(10),
                height: 95,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the container
                  border: Border.all(width: 1, color: Colors.black54),
                  color: Colors.grey[80],
                ),
                child: Image.asset(
                  "assets/icons/cross.png",
                  height: 10,
                  width: 8,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
// Stack(
// children: <Widget>[
// SizedBox(
//     height: 250,
//     width: 80,
//     child: Container(
//       child: Text("FileName"),
//     )),
// _videoController != null && _videoController!.value.isInitialized
// ? SizedBox(
// height: 300,
// child: AspectRatio(
// aspectRatio: _videoController!.value.aspectRatio,
// child: VideoPlayer(_videoController!),
// ),
// )
// : const SizedBox(),
// _videoController != null && _videoController!.value.isInitialized
// ? Positioned(
// bottom: 0, // Position at the bottom
// left: 0, // Ensure it stretches across the width
// right: 0,
// child: VideoProgressIndicator(_videoController!, allowScrubbing: true))
// : const SizedBox(),
// _videoController != null && _videoController!.value.isInitialized
// ? Positioned(
// bottom: 0, // Position at the bottom
// left: 0, // Ensure it stretches across the width
// right: 0,
// child: SizedBox(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// InkWell(
// onTap: () {
// setState(() {
// _videoController!.value.isPlaying
// ? _videoController!.pause()
// : _videoController!.play();
// });
// },
// child: Padding(
// padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
// child: Icon(
// _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
// color: Colors.white,
// size: 30,
// ),
// ),
// ),
// ],
// ),
// Row(
// children: [
// InkWell(
// onTap: () {
// setState(() {
// _videoController!.setVolume(isMuted ? 1 : 0);
// });
// },
// child: Padding(
// padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
// child: Icon(
// _videoController!.value.volume != 0.0 ? Icons.volume_mute : Icons.volume_off,
// color: Colors.white,
// size: 30,
// ),
// ),
// ),
// _videoController != null && _videoController!.value.isInitialized
// ? Padding(
// padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
// child: Text(formatDuration(_videoController!.value.position)))
// : const SizedBox(),
// ],
// )
// ],
// )))
// : const SizedBox(),
// ],
// ),
