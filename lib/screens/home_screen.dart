import 'package:article_project/providers/articles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/article_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final articles = searchQuery.isEmpty
        ? provider.articles
        : provider.searchArticles(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search articles...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text(provider.error!))
              : RefreshIndicator(
                  onRefresh: provider.fetchArticles,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20.0),
                          title: Text(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            article.body.length > 80
                                ? '${article.body.substring(0, 80)}...'
                                : article.body,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                provider.isFavorite(article)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: provider.isFavorite(article)
                                    ? Colors.red
                                    : null,
                                key: ValueKey<bool>(
                                    provider.isFavorite(article)),
                              ),
                            ),
                            onPressed: () {
                              provider.toggleFavorite(article);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArticleDetailScreen(article: article),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
