import 'package:article_project/providers/articles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final article = favorites[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                      article.body.length > 50
                          ? '${article.body.substring(0, 50)}...'
                          : article.body,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(article: article),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(
                        provider.isFavorite(article)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: provider.isFavorite(article) ? Colors.red : null,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(article);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
