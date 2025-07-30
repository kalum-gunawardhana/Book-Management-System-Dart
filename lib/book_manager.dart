import 'dart:collection';
import 'book.dart';
import 'textbook.dart';

// Custom exception for book management operations
class BookManagementException implements Exception {
  final String message;
  BookManagementException(this.message);
  
  @override
  String toString() => 'BookManagementException: $message';
}

// Book Management System class
class BookManager {
  final List<Book> _books = [];
  final Map<String, Book> _isbnIndex = {}; // For faster ISBN lookups

  // Getter for books (returns unmodifiable list)
  UnmodifiableListView<Book> get books => UnmodifiableListView(_books);

  // Add a new book to the collection
  void addBook(Book book) {
    try {
      // Check if book with same ISBN already exists
      if (_isbnIndex.containsKey(book.isbn)) {
        throw BookManagementException('Book with ISBN ${book.isbn} already exists');
      }

      _books.add(book);
      _isbnIndex[book.isbn] = book;
      
      print('Successfully added: ${book.title}');
    } catch (e) {
      print('Error adding book: $e');
      rethrow;
    }
  }

  // Remove a book from the collection
  bool removeBook(String isbn) {
    try {
      if (!_isbnIndex.containsKey(isbn)) {
        throw BookManagementException('Book with ISBN $isbn not found');
      }

      Book bookToRemove = _isbnIndex[isbn]!;
      
      // Check if book is currently borrowed
      if (bookToRemove.status == BookStatus.borrowed) {
        throw BookManagementException('Cannot remove borrowed book: ${bookToRemove.title}');
      }

      _books.remove(bookToRemove);
      _isbnIndex.remove(isbn);
      
      print('Successfully removed: ${bookToRemove.title}');
      return true;
    } catch (e) {
      print('Error removing book: $e');
      return false;
    }
  }

  // Update book status
  bool updateBookStatus(String isbn, BookStatus newStatus) {
    try {
      if (!_isbnIndex.containsKey(isbn)) {
        throw BookManagementException('Book with ISBN $isbn not found');
      }

      Book book = _isbnIndex[isbn]!;
      book.updateStatus(newStatus);
      return true;
    } catch (e) {
      print('Error updating book status: $e');
      return false;
    }
  }

  // Search by title (case-insensitive, partial match)
  List<Book> searchByTitle(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Search title cannot be empty');
    }

    String searchTerm = title.toLowerCase().trim();
    return _books.where((book) => 
      book.title.toLowerCase().contains(searchTerm)
    ).toList();
  }

  // Search by author (case-insensitive, partial match)
  List<Book> searchByAuthor(String author) {
    if (author.trim().isEmpty) {
      throw ArgumentError('Search author cannot be empty');
    }

    String searchTerm = author.toLowerCase().trim();
    return _books.where((book) => 
      book.author.toLowerCase().contains(searchTerm)
    ).toList();
  }

  // Search by ISBN (exact match)
  Book? searchByISBN(String isbn) {
    return _isbnIndex[isbn];
  }

  // Filter books by status
  List<Book> filterByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  // Filter textbooks by subject area
  List<TextBook> filterBySubject(String subjectArea) {
    String searchTerm = subjectArea.toLowerCase().trim();
    return _books.whereType<TextBook>()
                 .where((book) => book.subjectArea.toLowerCase().contains(searchTerm))
                 .toList();
  }

  // Filter textbooks by grade level
  List<TextBook> filterByGradeLevel(int gradeLevel) {
    return _books.whereType<TextBook>()
                 .where((book) => book.gradeLevel == gradeLevel)
                 .toList();
  }

  // Get available books
  List<Book> getAvailableBooks() {
    return filterByStatus(BookStatus.available);
  }

  // Get borrowed books
  List<Book> getBorrowedBooks() {
    return filterByStatus(BookStatus.borrowed);
  }

  // Get all textbooks
  List<TextBook> getAllTextBooks() {
    return _books.whereType<TextBook>().toList();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    Map<String, int> stats = {
      'total': _books.length,
      'available': 0,
      'borrowed': 0,
      'reserved': 0,
      'damaged': 0,
      'textbooks': 0,
    };

    for (Book book in _books) {
      stats[book.status.name] = (stats[book.status.name] ?? 0) + 1;
      if (book is TextBook) {
        stats['textbooks'] = stats['textbooks']! + 1;
      }
    }

    return stats;
  }

  // Advanced search with multiple criteria
  List<Book> advancedSearch({
    String? title,
    String? author,
    BookStatus? status,
    String? subjectArea,
    int? gradeLevel,
  }) {
    List<Book> results = List.from(_books);

    if (title != null && title.isNotEmpty) {
      String searchTerm = title.toLowerCase().trim();
      results = results.where((book) => 
        book.title.toLowerCase().contains(searchTerm)
      ).toList();
    }

    if (author != null && author.isNotEmpty) {
      String searchTerm = author.toLowerCase().trim();
      results = results.where((book) => 
        book.author.toLowerCase().contains(searchTerm)
      ).toList();
    }

    if (status != null) {
      results = results.where((book) => book.status == status).toList();
    }

    if (subjectArea != null && subjectArea.isNotEmpty) {
      String searchTerm = subjectArea.toLowerCase().trim();
      results = results.whereType<TextBook>()
                      .where((book) => book.subjectArea.toLowerCase().contains(searchTerm))
                      .cast<Book>()
                      .toList();
    }

    if (gradeLevel != null) {
      results = results.whereType<TextBook>()
                      .where((book) => book.gradeLevel == gradeLevel)
                      .cast<Book>()
                      .toList();
    }

    return results;
  }

  // Display all books
  void displayAllBooks() {
    if (_books.isEmpty) {
      print('No books in the collection.');
      return;
    }

    print('\n=== Book Collection ===');
    for (int i = 0; i < _books.length; i++) {
      print('${i + 1}. ${_books[i]}');
    }
    print('Total books: ${_books.length}\n');
  }

  // Display statistics
  void displayStatistics() {
    Map<String, int> stats = getStatistics();
    print('\n=== Library Statistics ===');
    stats.forEach((key, value) {
      print('${key.toUpperCase()}: $value');
    });
    print('');
  }
}