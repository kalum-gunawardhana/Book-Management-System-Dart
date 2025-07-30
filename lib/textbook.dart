import 'book.dart';

// Derived TextBook class
class TextBook extends Book {
  String _subjectArea;
  int _gradeLevel;

  // Constructor with super call
  TextBook(
    String title,
    String author,
    String isbn,
    this._subjectArea,
    this._gradeLevel,
    [BookStatus status = BookStatus.available]
  ) : super(title, author, isbn, status) {
    _validateGradeLevel(_gradeLevel);
    _validateSubjectArea(_subjectArea);
  }

  // Named constructor from map
  TextBook.fromMap(Map<String, dynamic> map)
      : _subjectArea = map['subjectArea'] ?? '',
        _gradeLevel = map['gradeLevel'] ?? 1,
        super.fromMap(map) {
    _validateGradeLevel(_gradeLevel);
    _validateSubjectArea(_subjectArea);
  }

  // Getters
  String get subjectArea => _subjectArea;
  int get gradeLevel => _gradeLevel;

  // Setters with validation
  set subjectArea(String subjectArea) {
    _validateSubjectArea(subjectArea);
    _subjectArea = subjectArea.trim();
  }

  set gradeLevel(int gradeLevel) {
    _validateGradeLevel(gradeLevel);
    _gradeLevel = gradeLevel;
  }

  // Validation methods
  void _validateSubjectArea(String subjectArea) {
    if (subjectArea.trim().isEmpty) {
      throw ArgumentError('Subject area cannot be empty');
    }
  }

  void _validateGradeLevel(int gradeLevel) {
    if (gradeLevel < 1 || gradeLevel > 12) {
      throw ArgumentError('Grade level must be between 1 and 12');
    }
  }

  // Check if textbook is suitable for grade level
  bool isSuitableForGrade(int grade) {
    return (grade - _gradeLevel).abs() <= 1; // Allow +/- 1 grade level
  }

  // Get academic level category
  String getAcademicLevel() {
    if (_gradeLevel >= 1 && _gradeLevel <= 5) {
      return 'Elementary';
    } else if (_gradeLevel >= 6 && _gradeLevel <= 8) {
      return 'Middle School';
    } else if (_gradeLevel >= 9 && _gradeLevel <= 12) {
      return 'High School';
    }
    return 'Unknown';
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['subjectArea'] = _subjectArea;
    map['gradeLevel'] = _gradeLevel;
    map['type'] = 'TextBook';
    return map;
  }

  @override
  String toString() {
    return 'TextBook(title: $title, author: $author, ISBN: $isbn, '
           'subject: $_subjectArea, grade: $_gradeLevel, status: ${status.name})';
  }
}