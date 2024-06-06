import 'module.dart';

class CourseView {
  final int? id;
  final String courseName;
  final Set<Module> modules;

  CourseView({this.id, required this.courseName, required this.modules});

  factory CourseView.fromJson(Map<String, dynamic> map) {
    var modulesJson = map['modules'] as List<dynamic>;
    Set<Module> modulesSet = modulesJson.map((module) => Module.fromJson(module as Map<String, dynamic>)).toSet();
    // dynamic dynamicData = map['modules'];
    // Set<dynamic> dynamicSet = Set.from(dynamicData);
    // Set<Module> modulesSet = dynamicSet.map((module) => Module.fromJson).cast<Module>().toSet();
    return CourseView(
        id: map['id'],
        courseName: map['courseName'],
        modules: modulesSet);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}
