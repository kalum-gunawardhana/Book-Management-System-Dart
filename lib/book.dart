// Base Book class with core functionality
enum BookStatus {
  available,
  borrowed,
  reserved,
  damaged
}

class Book {
  String _title;
  String _author;
  String _isbn;
  BookStatus _status;

  // Constructor
  Book(this._title, this._author, this._isbn, [this._status = BookStatus.available]) {
    if (!_isValidISBN(_isbn)) {
      throw ArgumentError('Invalid ISBN format');
    }
  }

  // Named constructor for creating book from map
  Book.fromMap(Map<String, dynamic> map)
      : _title = map['title'] ?? '',
        _author = map['author'] ?? '',
        _isbn = map['isbn'] ?? '',
        _status = _parseStatus(map['status']) {
    if (!_isValidISBN(_isbn)) {
      throw ArgumentError('Invalid ISBN format');
    }
  }

  // Getters
  String get title => _title;
  String get author => _author;
  String get isbn => _isbn;
  BookStatus get status => _status;

  // Setters with validation
  set title(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    _title = title.trim();
  }

  set author(String author) {
    if (author.trim().isEmpty) {
      throw ArgumentError('Author cannot be empty');
    }
    _author = author.trim();
  }

  set isbn(String isbn) {
    if (!_isValidISBN(isbn)) {
      throw ArgumentError('Invalid ISBN format');
    }
    _isbn = isbn;
  }

  set status(BookStatus status) {
    _status = status;
  }

  // ISBN validation method (supports both ISBN-10 and ISBN-13)
  bool _isValidISBN(String isbn) {
    // Remove hyphens and spaces
    String cleanISBN = isbn.replaceAll(RegExp(r'[-\s]'), '');
    
    // Check if it's ISBN-10 or ISBN-13
    if (cleanISBN.length == 10) {
      return _isValidISBN10(cleanISBN);
    } else if (cleanISBN.length == 13) {
      return _isValidISBN13(cleanISBN);
    }
    
    return false;
  }

  // ISBN-10 validation
  bool _isValidISBN10(String isbn) {
    if (!RegExp(r'^\d{9}[\dX]$').hasMatch(isbn)) return false;
    
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(isbn[i]) * (10 - i);
    }
    
    int checkDigit = isbn[9] == 'X' ? 10 : int.parse(isbn[9]);
    return (sum + checkDigit) % 11 == 0;
  }

  // ISBN-13 validation
  bool _isValidISBN13(String isbn) {
    if (!RegExp(r'^\d{13}$').hasMatch(isbn)) return false;
    
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(isbn[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    
    int checkDigit = int.parse(isbn[12]);
    return (sum + checkDigit) % 10 == 0;
  }

  // Status update method
  void updateStatus(BookStatus newStatus) {
    BookStatus oldStatus = _status;
    _status = newStatus;
    print('Book "${_title}" status updated from ${oldStatus.name} to ${newStatus.name}');
  }

  // Helper method to parse status from string
  static BookStatus _parseStatus(dynamic status) {
    if (status is BookStatus) return status;
    if (status is String) {
      return BookStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
        orElse: () => BookStatus.available,
      );
    }
    return BookStatus.available;
  }

  // Check if book is available for borrowing
  bool isAvailable() {
    return _status == BookStatus.available;
  }

  // Convert book to map (useful for serialization)
  Map<String, dynamic> toMap() {
    return {
      'title': _title,
      'author': _author,
      'isbn': _isbn,
      'status': _status.name,
      'type': 'Book'
    };
  }

  @override
  String toString() {
    return 'Book(title: $_title, author: $_author, ISBN: $_isbn, status: ${_status.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other._isbn == _isbn;
  }

  @override
  int get hashCode => _isbn.hashCode;
}