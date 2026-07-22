import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Anime App Test',
    home: AnimePlayerScreen(),
  ));
}

class AnimePlayerScreen extends StatefulWidget {
  const AnimePlayerScreen({super.key});

  @override
  State<AnimePlayerScreen> createState() => _AnimePlayerScreenState();
}

class _AnimePlayerScreenState extends State<AnimePlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  // رابط فيديو "تست" خفيف جداً ومباشر من جوجل (صيغة MP4)
  final String videoUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    // 1. تهيئة مشغل الفيديو
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoPlayerController.initialize();

    // 2. تهيئة تحكمات Chewie مع الشعار التراكبي
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      
      // الشعار التراكبي (المربع الذي يغطي الشعار الأصلي)
      overlay: Stack(
        children: [
          Positioned(
            top: 20, // المسافة من الأعلى
            left: 20, // تعديل سابق: زاوية شمال فوق
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8), // خلفية سوداء شبه شفافة
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Anime Night', // التعديل الجديد: النص المطلوب
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // 3. تحديث واجهة المستخدم بعد جاهزية المشغل
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('مشاهدة تجريبية'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(controller: _chewieController!),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري تحميل الفيديو...', style: TextStyle(color: Colors.white)),
                ],
              ),
      ),
    );
  }
}
