import 'package:flutter/material.dart';
import 'package:unit_text_sample/article.dart';
import 'package:unit_text_sample/news_service.dart';
class NewsChangeNotifier extends ChangeNotifier {
  final NewsService _newsService;

  NewsChangeNotifier(this._newsService);

  List<Article> _articles = [];

  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    _isLoading = true;
   notifyListeners();
    _articles = await _newsService.getArticles();
    _isLoading = false;
    notifyListeners();
  }
}
