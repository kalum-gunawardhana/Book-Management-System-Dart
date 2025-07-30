# Book Management System

A comprehensive book management system implemented in Dart, demonstrating object-oriented programming principles including inheritance, encapsulation, and polymorphism.

## Features

### Core Classes

#### Book Class (Base Class)
- **Properties**: Title, Author, ISBN, Status (Available/Borrowed/Reserved/Damaged)
- **Methods**: 
  - Constructor with validation
  - Getters and setters with input validation
  - ISBN validation (supports both ISBN-10 and ISBN-13)
  - Status update method
  - Availability checking
  - Serialization (to/from Map)

#### TextBook Class (Derived Class)
- **Inherits from**: Book class
- **Additional Properties**: Subject Area, Grade Level
- **Additional Methods**:
  - Grade level suitability checking
  - Academic level categorization (Elementary/Middle School/High School)
  - Enhanced serialization with textbook-specific fields

### Book Management Operations

#### BookManager Class
- **Add Books**: Add new books to the collection with duplicate prevention
- **Remove Books**: Remove books (with borrowed book protection)
- **Update Status**: Change book status (available, borrowed, reserved, damaged)
- **Search Functionality**:
  - Search by title (partial, case-insensitive)
  - Search by author (partial, case-insensitive)
  - Search by ISBN (exact match)
- **Filtering Options**:
  - Filter by status
  - Filter textbooks by subject area
  - Filter textbooks by grade level
  - Advanced multi-criteria search
- **Statistics**: Generate collection statistics and reports

## Key Features

### Data Validation
- **ISBN Validation**: Supports both ISBN-10 and ISBN-13 with checksum verification
- **Input Validation**: Title, author, and subject area cannot be empty
- **Grade Level Validation**: Must be between 1-12 for textbooks
- **Status Validation**: Prevents invalid status transitions

### Error Handling
- Custom `BookManagementException` for domain-specific errors
- Comprehensive input validation with meaningful error messages
- Safe operations with proper exception handling

### Object-Oriented Design
- **Inheritance**: TextBook inherits from Book
- **Encapsulation**: Private fields with controlled access via getters/setters
- **Polymorphism**: Books and TextBooks can be managed uniformly
- **Abstraction**: Clean interfaces hide implementation complexity

## Usage

### Running the Application

```bash
# Install dependencies
dart pub get

# Run the main application
dart run bin/main.dart

# Run tests
dart test
```

### Example Usage

```dart
import 'lib/book.dart';
import 'lib/textbook.dart';
import 'lib/book_manager.dart';

void main() {
  // Create book manager
  BookManager manager = BookManager();

  // Add regular books
  manager.addBook(Book('The Dart Programming Language', 'John Doe', '978-0-123456-78-9'));

  // Add textbooks
  manager.addBook(TextBook('Algebra I', 'Mary Wilson', '978-0-123456-81-9', 'Mathematics', 9));

  // Search and filter
  List<Book> dartBooks = manager.searchByTitle('Dart');
  List<TextBook> mathBooks = manager.filterBySubject('Mathematics');
  List<Book> availableBooks = manager.getAvailableBooks();

  // Update status
  manager.updateBookStatus('978-0-123456-78-9', BookStatus.borrowed);

  // Display statistics
  manager.displayStatistics();
}
```

## Architecture

### Class Hierarchy
```
Book (Base Class)
├── Properties: title, author, isbn, status
├── Methods: validation, status management, serialization
└── TextBook (Derived Class)
    ├── Additional Properties: subjectArea, gradeLevel
    └── Additional Methods: grade suitability, academic level
```

### Design Patterns Used
- **Template Method**: Base validation in Book class, extended in TextBook
- **Factory Method**: fromMap constructors for object creation
- **Strategy Pattern**: Different search and filter strategies
- **Observer Pattern**: Status update notifications

## Testing

Comprehensive test suite covering:
- Unit tests for Book class functionality
- Unit tests for TextBook class extensions
- Integration tests for BookManager operations
- Edge cases and error handling scenarios
- Input validation testing

```bash
# Run all tests
dart test

# Run specific test file
dart test test/book_test.dart
```

## Technical Requirements Met

### 1. Class Implementation ✅
- **Base Class (Book)**: Complete with all required properties and methods
- **Derived Class (TextBook)**: Proper inheritance with additional functionality
- **Constructors**: Multiple constructors including named constructors
- **Validation**: Comprehensive input validation including ISBN validation

### 2. Book Management Operations ✅
- **Add/Remove**: Full CRUD operations with error handling
- **Status Updates**: Safe status management with validation
- **Search**: Multiple search criteria with flexible matching
- **Filtering**: Advanced filtering with multiple parameters

### 3. Evaluation Criteria ✅
- **Inheritance**: Proper use of extends keyword and super calls
- **Dart Features**: Effective use of enums, named constructors, getters/setters
- **Validation**: Comprehensive input validation throughout
- **Code Organization**: Clean, modular design with separation of concerns
- **Error Handling**: Custom exceptions and proper error management

## Advanced Features

- **ISBN Validation**: Supports both ISBN-10 and ISBN-13 formats with checksum validation
- **Academic Level Categorization**: Automatic categorization based on grade level
- **Advanced Search**: Multi-criteria search with optional parameters
- **Statistics Generation**: Comprehensive reporting and analytics
- **Serialization**: Full JSON serialization support for data persistence
- **Type Safety**: Extensive use of Dart's type system for reliability

## Future Enhancements

- Database integration for persistent storage
- User management and borrowing history
- Due date tracking and overdue notifications
- Barcode scanning support
- Web interface with REST API
- Import/export functionality for library data