import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Night',
      theme: ThemeData.dark(),
      home: const AnimePlayerScreen(),
    );
  }
}

class AnimePlayerScreen extends StatefulWidget {
  const AnimePlayerScreen({super.key});

  @override
  State<AnimePlayerScreen> createState() => _AnimePlayerScreenState();
}

class _AnimePlayerScreenState extends State<AnimePlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  // رابط الفيديو التجريبي الخفيف من سيرفرات جوجل (صيغة MP4)
  final String videoUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play(); // تشغيل الفيديو أوتوماتيكياً عند الجاهزية
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Anime Night'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // 1. مشغل الفيديو الرئيسي
                    VideoPlayer(_controller),

                    // 2. الشعار التراكبي فوق زاوية الشمال (تغطية الراعي)
                    Positioned(
                      top: 15,
                      left: 15, // زاوية شمال فوق
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.85), // خلفية سوداء لتغطية ما تحتها
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.redAccent, width: 1),
                        ),
                        child: const Text(
                          'Anime Night',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    // 3. أزرار التحكم والتشغيل المدمجة
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _controller.value.isPlaying ? 0.0 : 0.9,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(
                              Icons.play_circle_fill,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 4. شريط تقدم الفيديو (Progress Bar)
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.redAccent,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ],
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.redAccent),
                  SizedBox(height: 15),
                  Text(
                    'جاري تحميل الفيديو...',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
      ),
    );
  }
}
