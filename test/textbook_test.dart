import 'package:test/test.dart';
import '../lib/book.dart';
import '../lib/textbook.dart';

void main() {
  group('TextBook Class Tests', () {
    test('should create textbook with valid data', () {
      TextBook textbook = TextBook('Math Book', 'Author', '978-0-123456-78-9', 'Mathematics', 10);
      
      expect(textbook.title, equals('Math Book'));
      expect(textbook.subjectArea, equals('Mathematics'));
      expect(textbook.gradeLevel, equals(10));
      expect(textbook.getAcademicLevel(), equals('High School'));
    });

    test('should throw error for invalid grade level', () {
      expect(() => TextBook('Test', 'Author', '978-0-123456-78-9', 'Math', 0), 
             throwsA(isA<ArgumentError>()));
      expect(() => TextBook('Test', 'Author', '978-0-123456-78-9', 'Math', 13), 
             throwsA(isA<ArgumentError>()));
    });

    test('should throw error for empty subject area', () {
      expect(() => TextBook('Test', 'Author', '978-0-123456-78-9', '', 10), 
             throwsA(isA<ArgumentError>()));
    });

    test('should determine academic level correctly', () {
      TextBook elementary = TextBook('Test', 'Author', '978-0-123456-78-9', 'Math', 3);
      TextBook middle = TextBook('Test', 'Author', '978-0-123456-79-6', 'Math', 7);
      TextBook high = TextBook('Test', 'Author', '978-0-123456-80-2', 'Math', 11);
      
      expect(elementary.getAcademicLevel(), equals('Elementary'));
      expect(middle.getAcademicLevel(), equals('Middle School'));
      expect(high.getAcademicLevel(), equals('High School'));
    });

    test('should check grade suitability correctly', () {
      TextBook textbook = TextBook('Test', 'Author', '978-0-123456-78-9', 'Math', 10);
      
      expect(textbook.isSuitableForGrade(9), isTrue);
      expect(textbook.isSuitableForGrade(10), isTrue);
      expect(textbook.isSuitableForGrade(11), isTrue);
      expect(textbook.isSuitableForGrade(8), isFalse);
      expect(textbook.isSuitableForGrade(12), isFalse);
    });

    test('should convert to map with additional fields', () {
      TextBook textbook = TextBook('Math Book', 'Author', '978-0-123456-78-9', 'Mathematics', 10);
      Map<String, dynamic> map = textbook.toMap();
      
      expect(map['subjectArea'], equals('Mathematics'));
      expect(map['gradeLevel'], equals(10));
      expect(map['type'], equals('TextBook'));
    });

    test('should create from map correctly', () {
      Map<String, dynamic> map = {
        'title': 'Science Book',
        'author': 'Dr. Smith',
        'isbn': '978-0-123456-78-9',
        'status': 'available',
        'subjectArea': 'Physics',
        'gradeLevel': 12
      };
      
      TextBook textbook = TextBook.fromMap(map);
      expect(textbook.subjectArea, equals('Physics'));
      expect(textbook.gradeLevel, equals(12));
      expect(textbook.getAcademicLevel(), equals('High School'));
    });
  });
}