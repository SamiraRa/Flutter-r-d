import 'package:flutter/material.dart';

class ShowMaterialBanner extends StatefulWidget {
  const ShowMaterialBanner({Key? key}) : super(key: key);

  @override
  _ShowMaterialBannerState createState() => _ShowMaterialBannerState();
}

class _ShowMaterialBannerState extends State<ShowMaterialBanner> {
  static const map = {
    "Coffee": "95 gm",
    "Redbull": "147 gm",
    "Tea": "11 gm",
    "Soda": "21 gm",
  };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearMaterialBanners();
        await Future.delayed(const Duration(milliseconds: 100));

        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
          // appBar: PreferredSize(preferredSize: preferredSize, child: Text("")),
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showMaterialBanner(MaterialBanner(content: const Text("Subscribe"), actions: [
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                          },
                          child: const Text("Dismiss"))
                    ]));
                  }
                },
                child: const Text("Open")),
          )
        ],
      )),
    );
  }

  getCaffeine(type) {
    String caffeine;
    // const map = {
    //     "Coffee": "95 gm",
    //     "Redbull": "147 gm",
    //     "Tea": "11 gm",
    //     "Soda": "21 gm",
    //   };
    caffeine = map[type] ?? "Not Found";
    return caffeine;
  }
}
