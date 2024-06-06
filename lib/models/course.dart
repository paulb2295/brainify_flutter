class Course {
   final int? id;
   final String courseName;

   Course({this.id, required this.courseName});

   factory Course.fromJson(Map<String, dynamic> map){
     return Course(
         id : map['id'] ?? 0,
         courseName: map['courseName'] ?? ''
     );
   }

   Map<String, dynamic> toJson(){
     return {
       'id' : id,
       'courseName' : courseName
     };
   }
}