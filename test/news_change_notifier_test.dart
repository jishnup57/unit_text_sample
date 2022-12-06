import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_text_sample/article.dart';
import 'package:unit_text_sample/news_change_notifier.dart';
import 'package:unit_text_sample/news_service.dart';

class BadMockNewsService implements NewsService {
  bool isGetArticleCalled = false;
  @override
  Future<List<Article>> getArticles() async {
    isGetArticleCalled = true;
    return [
      Article(title: "Test 1", content: "Test 1 content"),
      Article(title: "Test 2", content: "Test 2 content"),
      Article(title: "Test 3", content: "Test 3 content"),
      Article(title: "Test 4", content: "Test 4 content"),
    ];
  }
}

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut; //system under test
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test('initial value are correct', () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('getArticles', () {
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer((_) async => [
            Article(title: "Test 1", content: "Test 1 content"),
            Article(title: "Test 2", content: "Test 2 content"),
            Article(title: "Test 3", content: "Test 3 content"),
            Article(title: "Test 4", content: "Test 4 content"),
          ]);
    }

    test('gets articles using the NewsService', () async {
     // when(() => mockNewsService.getArticles()).thenAnswer((_) async => []);
     arrangeNewsServiceReturns3Articles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test("""indicates loading of data,
    sets articles to the ones from the service,
    indicates that data is not being loaded anymore""", () async {
      arrangeNewsServiceReturns3Articles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles,[
      Article(title: "Test 1", content: "Test 1 content"),
      Article(title: "Test 2", content: "Test 2 content"),
      Article(title: "Test 3", content: "Test 3 content"),
      Article(title: "Test 4", content: "Test 4 content"),
    ] );
    expect(sut.isLoading, false);
    });
  });
}
