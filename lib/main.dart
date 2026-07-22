hereimport 'package:flutter/material.dart';
import 'http' as http;
import 'convert' as json;

void main() {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List animeList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnime();
  }

  Future<void> fetchAnime() async {
    final response = await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));
    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      setState(() {
        animeList = data['data'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أبرز الأنميات')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          anime['images']['jpg']['image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        child: Text(
                          anime['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
