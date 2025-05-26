import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:web_dynamic_form_flutter/Services/repositories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List unsplashData = [];

  bool dashboardLoader = false;

  @override
  void initState() {
    super.initState();
    hiveBox();
  }

  hiveBox() async {
    final box = Hive.box("imageList");
    var a = box.get("imageData");
    // unsplashData = box.toMap().values.toList();
    if (a == null) return;
    for (var ele in a) {
      ele ??= "No Data";
      unsplashData.add(ele);
      setState(() {});

      print("if null aaaaaaaaaaas ${unsplashData.any((element) => element == null)}");
    }
    // unsplashData.where((element) {
    //   return element == null ? element = "No result" : element;
    // });
    print("unsplashData from ${unsplashData.length}");
    print("unsplashData from $unsplashData");
  }

  apicall() async {
    // await Hive.openBox("imageList");

    int pageNumber = 1;
    final box = await Hive.box("imageList");
    var a = box.get("imageData");

    print("x  ${unsplashData.length} $pageNumber");
    for (int i = pageNumber; i < 20; i++) {
      List x = await Repositories().getImageRepo(pageNumber);

      for (var a in x) {
        unsplashData.add(a);
      }

      box.put("imageData", unsplashData);

      pageNumber++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Form"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       Hive.deleteFromDisk();
            //       setState(() {
            //         unsplashData.clear();
            //       });
            //       apicall();
            //       hiveBox();
            //     },
            //     child: Row(
            //       children: [
            //         // Image.asset(
            //         //                 'assets/images/load.gif',
            //         //                 color: Colors.white,
            //         //                 // color: MyColors().white,
            //         //                 width: 18,
            //         //                 height: 18,
            //         //               )

            //         Image.asset(
            //           'assets/icons/reload.png',
            //           color: Colors.white,
            //           // color: MyColors().white,
            //           width: 18,
            //           height: 18,
            //         ),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         const Text("Sync"),
            //       ],
            //     )),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: unsplashData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: unsplashData[index]["urls"]["regular"],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        // Image.network(
                        //   unsplashData[index]["urls"]["regular"],
                        //   fit: BoxFit.cover,
                        //   height: 150,
                        //   width: 150,
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          unsplashData[index]["user"]["name"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
