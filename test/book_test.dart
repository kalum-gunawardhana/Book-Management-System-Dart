import 'package:test/test.dart';
import '../lib/book.dart';

void main() {
  group('Book Class Tests', () {
    test('should create a book with valid data', () {
      Book book = Book('Test Book', 'Test Author', '978-0-123456-78-9');
      
      expect(book.title, equals('Test Book'));
      expect(book.author, equals('Test Author'));
      expect(book.isbn, equals('978-0-123456-78-9'));
      expect(book.status, equals(BookStatus.available));
    });

    test('should throw error for invalid ISBN', () {
      expect(() => Book('Test', 'Author', 'invalid-isbn'), 
             throwsA(isA<ArgumentError>()));
    });

    test('should validate ISBN-10 correctly', () {
      expect(() => Book('Test', 'Author', '0-306-40615-2'), 
             returnsNormally);
    });

    test('should validate ISBN-13 correctly', () {
      expect(() => Book('Test', 'Author', '978-0-306-40615-7'), 
             returnsNormally);
    });

    test('should update status correctly', () {
      Book book = Book('Test', 'Author', '978-0-123456-78-9');
      book.updateStatus(BookStatus.borrowed);
      
      expect(book.status, equals(BookStatus.borrowed));
    });

    test('should check availability correctly', () {
      Book book = Book('Test', 'Author', '978-0-123456-78-9');
      
      expect(book.isAvailable(), isTrue);
      
      book.updateStatus(BookStatus.borrowed);
      expect(book.isAvailable(), isFalse);
    });

    test('should handle title setter validation', () {
      Book book = Book('Test', 'Author', '978-0-123456-78-9');
      
      expect(() => book.title = '', throwsA(isA<ArgumentError>()));
      expect(() => book.title = '   ', throwsA(isA<ArgumentError>()));
      
      book.title = '  New Title  ';
      expect(book.title, equals('New Title'));
    });

    test('should convert to map correctly', () {
      Book book = Book('Test Book', 'Test Author', '978-0-123456-78-9');
      Map<String, dynamic> map = book.toMap();
      
      expect(map['title'], equals('Test Book'));
      expect(map['author'], equals('Test Author'));
      expect(map['isbn'], equals('978-0-123456-78-9'));
      expect(map['status'], equals('available'));
      expect(map['type'], equals('Book'));
    });

    test('should create from map correctly', () {
      Map<String, dynamic> map = {
        'title': 'Test Book',
        'author': 'Test Author',
        'isbn': '978-0-123456-78-9',
        'status': 'borrowed'
      };
      
      Book book = Book.fromMap(map);
      expect(book.title, equals('Test Book'));
      expect(book.status, equals(BookStatus.borrowed));
    });
  });
}