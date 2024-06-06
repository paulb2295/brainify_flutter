class CourseResponse { //?? progress
  final int? id;
  final String courseName;
  final int progress;
  final DateTime? enrollment;

  CourseResponse(
      {this.id,
      required this.courseName,
      required this.progress,
      this.enrollment});

  factory CourseResponse.fromJson(Map<String, dynamic> map) {
    return CourseResponse(
        id: map['id'] ?? 0,
        courseName: map['courseName'] ?? '',
        progress: map['progress'] ?? '',
        enrollment: map['enrollment']);
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'courseName' : courseName,
      'progress' : progress,
      'enrollment' : enrollment
    };
  }
}
