import '../lib/book.dart';
import '../lib/textbook.dart';
import '../lib/book_manager.dart';

void main() {
  print('=== Book Management System Demo ===\n');

  // Create book manager instance
  BookManager manager = BookManager();

  try {
    // Demonstrate adding regular books
    print('Adding regular books...');
    manager.addBook(Book('The Dart Programming Language', 'John Doe', '978-0-123456-78-9'));
    manager.addBook(Book('Flutter Development', 'Jane Smith', '978-0-123456-79-6'));
    manager.addBook(Book('Object-Oriented Programming', 'Bob Johnson', '978-0-123456-80-2'));

    // Demonstrate adding textbooks
    print('\nAdding textbooks...');
    manager.addBook(TextBook('Algebra I', 'Mary Wilson', '978-0-123456-81-9', 'Mathematics', 9));
    manager.addBook(TextBook('Biology Basics', 'Dr. Sarah Lee', '978-0-123456-82-6', 'Science', 10));
    manager.addBook(TextBook('World History', 'Prof. Mike Davis', '978-0-123456-83-3', 'History', 11));

    // Display all books
    manager.displayAllBooks();

    // Demonstrate status updates
    print('Updating book statuses...');
    manager.updateBookStatus('978-0-123456-78-9', BookStatus.borrowed);
    manager.updateBookStatus('978-0-123456-81-9', BookStatus.reserved);

    // Demonstrate search functionality
    print('\n=== Search Demonstrations ===');
    
    print('\nSearching by title "Dart":');
    List<Book> titleResults = manager.searchByTitle('Dart');
    titleResults.forEach(print);

    print('\nSearching by author "Jane":');
    List<Book> authorResults = manager.searchByAuthor('Jane');
    authorResults.forEach(print);

    print('\nFiltering by subject "Mathematics":');
    List<TextBook> mathBooks = manager.filterBySubject('Mathematics');
    mathBooks.forEach(print);

    print('\nFiltering by grade level 10:');
    List<TextBook> grade10Books = manager.filterByGradeLevel(10);
    grade10Books.forEach(print);

    print('\nAvailable books:');
    List<Book> availableBooks = manager.getAvailableBooks();
    availableBooks.forEach(print);

    print('\nBorrowed books:');
    List<Book> borrowedBooks = manager.getBorrowedBooks();
    borrowedBooks.forEach(print);

    // Demonstrate advanced search
    print('\n=== Advanced Search ===');
    print('Searching for Science textbooks that are available:');
    List<Book> advancedResults = manager.advancedSearch(
      subjectArea: 'Science',
      status: BookStatus.available,
    );
    advancedResults.forEach(print);

    // Display statistics
    manager.displayStatistics();

    // Demonstrate error handling
    print('=== Error Handling Demonstrations ===');
    
    try {
      // Try to add duplicate ISBN
      manager.addBook(Book('Duplicate Book', 'Test Author', '978-0-123456-78-9'));
    } catch (e) {
      print('Caught expected error: $e');
    }

    try {
      // Try to create book with invalid ISBN
      Book invalidBook = Book('Invalid Book', 'Test Author', '123-invalid-isbn');
    } catch (e) {
      print('Caught expected error: $e');
    }

    try {
      // Try to create textbook with invalid grade level
      TextBook invalidTextbook = TextBook('Invalid Grade', 'Test Author', '978-0-123456-99-9', 'Test', 15);
    } catch (e) {
      print('Caught expected error: $e');
    }

    // Demonstrate removal
    print('\n=== Book Removal ===');
    print('Attempting to remove available book...');
    manager.removeBook('978-0-123456-79-6');

    print('Attempting to remove borrowed book (should fail)...');
    manager.removeBook('978-0-123456-78-9');

    // Final statistics
    print('\n=== Final Statistics ===');
    manager.displayStatistics();

  } catch (e) {
    print('Unexpected error: $e');
  }

  print('\n=== Demo Complete ===');
}

// Additional utility functions for demonstration
void demonstrateTextBookFeatures() {
  print('\n=== TextBook Specific Features ===');
  
  TextBook mathBook = TextBook('Calculus', 'Prof. Newton', '978-0-123456-90-6', 'Mathematics', 12);
  
  print('Book: ${mathBook.title}');
  print('Academic Level: ${mathBook.getAcademicLevel()}');
  print('Suitable for grade 11? ${mathBook.isSuitableForGrade(11)}');
  print('Suitable for grade 9? ${mathBook.isSuitableForGrade(9)}');
}

void demonstrateISBNValidation() {
  print('\n=== ISBN Validation Demonstration ===');
  
  List<String> testISBNs = [
    '978-0-123456-78-9',  // Valid ISBN-13
    '0-123456-789',       // Valid ISBN-10
    '123-invalid-isbn',   // Invalid
    '978-0-123456-78-0',  // Invalid checksum
  ];

  for (String isbn in testISBNs) {
    try {
      Book testBook = Book('Test', 'Test Author', isbn);
      print('$isbn: Valid');
    } catch (e) {
      print('$isbn: Invalid - $e');
    }
  }
}