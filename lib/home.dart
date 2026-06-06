import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const channel = MethodChannel("launcher_channel");

  List apps = [];

  bool jiggle = false;
  bool search = false;

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  Future<void> loadApps() async {
    final result = await channel.invokeMethod("getApps");
    setState(() => apps = result);
  }

  Future<void> openApp(String pkg) async {
    await channel.invokeMethod("openApp", {"package": pkg});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),

      body: Stack(
        children: [

          // 📱 HOME PAGES (iOS springboard)
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, page) {
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 120),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                ),
                itemCount: apps.length,
                itemBuilder: (context, i) {
                  final app = apps[i];

                  return Draggable(
                    feedback: _icon(app, dragging: true),
                    childWhenDragging: const SizedBox(),
                    child: GestureDetector(
                      onLongPress: () => setState(() => jiggle = true),
                      onTap: () {
                        if (!jiggle) openApp(app["package"]);
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 120),
                        scale: jiggle ? 0.95 : 1.0,
                        child: _icon(app),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // 🔍 SPOTLIGHT SEARCH
          if (search)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search apps...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

          // 📍 PAGE DOTS
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          // 📍 DOCK (iOS style blur + magnification)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    height: 85,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.phone),
                        Icon(Icons.message),
                        Icon(Icons.safari),
                        Icon(Icons.music_note),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(app, {bool dragging = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: const Icon(Icons.apps),
        ),
        const SizedBox(height: 4),
        Text(
          app["label"],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11),
        )
      ],
    );
  }
}