import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Article> get favorites {
    final box = Hive.box('favorites');
    return box.values
        .map((e) => Article.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (res.statusCode == 200) {
        final List jsonData = json.decode(res.body);
        _articles = jsonData.map((e) => Article.fromJson(e)).toList();
      } else {
        _error = 'Error: ${res.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Article> searchArticles(String query) {
    return _articles.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.body.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void toggleFavorite(Article article) {
    final box = Hive.box('favorites'); 

    if (isFavorite(article)) {
      box.delete(article.id);
    } else {
      box.put(article.id, article.toJson()); 
    }
    notifyListeners();
  }

  bool isFavorite(Article article) {
    return Hive.box('favorites').containsKey(article.id);
  }
}
