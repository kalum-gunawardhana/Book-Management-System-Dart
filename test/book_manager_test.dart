import 'package:test/test.dart';
import '../lib/book.dart';
import '../lib/textbook.dart';
import '../lib/book_manager.dart';

void main() {
  group('BookManager Tests', () {
    late BookManager manager;

    setUp(() {
      manager = BookManager();
    });

    test('should add books successfully', () {
      Book book = Book('Test Book', 'Author', '978-0-123456-78-9');
      manager.addBook(book);
      
      expect(manager.books.length, equals(1));
      expect(manager.searchByISBN('978-0-123456-78-9'), equals(book));
    });

    test('should prevent duplicate ISBN', () {
      Book book1 = Book('Book 1', 'Author', '978-0-123456-78-9');
      Book book2 = Book('Book 2', 'Author', '978-0-123456-78-9');
      
      manager.addBook(book1);
      expect(() => manager.addBook(book2), 
             throwsA(isA<BookManagementException>()));
    });

    test('should remove books successfully', () {
      Book book = Book('Test Book', 'Author', '978-0-123456-78-9');
      manager.addBook(book);
      
      bool removed = manager.removeBook('978-0-123456-78-9');
      expect(removed, isTrue);
      expect(manager.books.length, equals(0));
    });

    test('should prevent removing borrowed books', () {
      Book book = Book('Test Book', 'Author', '978-0-123456-78-9');
      manager.addBook(book);
      manager.updateBookStatus('978-0-123456-78-9', BookStatus.borrowed);
      
      bool removed = manager.removeBook('978-0-123456-78-9');
      expect(removed, isFalse);
      expect(manager.books.length, equals(1));
    });

    test('should search by title correctly', () {
      manager.addBook(Book('Dart Programming', 'Author 1', '978-0-123456-78-9'));
      manager.addBook(Book('Flutter Development', 'Author 2', '978-0-123456-79-6'));
      manager.addBook(Book('Java Programming', 'Author 3', '978-0-123456-80-2'));
      
      List<Book> results = manager.searchByTitle('Programming');
      expect(results.length, equals(2));
      expect(results.every((book) => book.title.contains('Programming')), isTrue);
    });

    test('should search by author correctly', () {
      manager.addBook(Book('Book 1', 'John Smith', '978-0-123456-78-9'));
      manager.addBook(Book('Book 2', 'Jane Smith', '978-0-123456-79-6'));
      manager.addBook(Book('Book 3', 'Bob Johnson', '978-0-123456-80-2'));
      
      List<Book> results = manager.searchByAuthor('Smith');
      expect(results.length, equals(2));
    });

    test('should filter by status correctly', () {
      Book book1 = Book('Book 1', 'Author', '978-0-123456-78-9');
      Book book2 = Book('Book 2', 'Author', '978-0-123456-79-6');
      
      manager.addBook(book1);
      manager.addBook(book2);
      manager.updateBookStatus('978-0-123456-78-9', BookStatus.borrowed);
      
      List<Book> available = manager.getAvailableBooks();
      List<Book> borrowed = manager.getBorrowedBooks();
      
      expect(available.length, equals(1));
      expect(borrowed.length, equals(1));
    });

    test('should filter textbooks by subject', () {
      manager.addBook(TextBook('Math 1', 'Author', '978-0-123456-78-9', 'Mathematics', 10));
      manager.addBook(TextBook('Science 1', 'Author', '978-0-123456-79-6', 'Science', 10));
      manager.addBook(TextBook('Math 2', 'Author', '978-0-123456-80-2', 'Mathematics', 11));
      
      List<TextBook> mathBooks = manager.filterBySubject('Mathematics');
      expect(mathBooks.length, equals(2));
    });

    test('should perform advanced search correctly', () {
      manager.addBook(TextBook('Math Book', 'John Doe', '978-0-123456-78-9', 'Mathematics', 10));
      manager.addBook(TextBook('Science Book', 'Jane Doe', '978-0-123456-79-6', 'Science', 10));
      manager.updateBookStatus('978-0-123456-79-6', BookStatus.borrowed);
      
      List<Book> results = manager.advancedSearch(
        author: 'Doe',
        status: BookStatus.available,
        gradeLevel: 10,
      );
      
      expect(results.length, equals(1));
      expect(results.first.title, equals('Math Book'));
    });

    test('should generate statistics correctly', () {
      manager.addBook(Book('Regular Book', 'Author', '978-0-123456-78-9'));
      manager.addBook(TextBook('Text Book', 'Author', '978-0-123456-79-6', 'Math', 10));
      manager.updateBookStatus('978-0-123456-78-9', BookStatus.borrowed);
      
      Map<String, int> stats = manager.getStatistics();
      
      expect(stats['total'], equals(2));
      expect(stats['available'], equals(1));
      expect(stats['borrowed'], equals(1));
      expect(stats['textbooks'], equals(1));
    });
  });
}