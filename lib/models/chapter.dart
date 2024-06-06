class Chapter {
   final String? id;
   final String title;
   final String content;

   Chapter({this.id, required this.title, required this.content});

   factory Chapter.fromJson(Map<String, dynamic> map){
     return Chapter(
         id : map ['id'] ?? '',
         title: map['title'] ?? '',
         content: map['content'] ?? '',
     );
   }

   Map<String, dynamic> toJson(){
     return {
       'id' : id,
       'title' : title,
       'content' : content
     };
   }
}