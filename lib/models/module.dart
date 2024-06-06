class Module {
  final int? id;
  String? chapterDocumentId;
  String moduleName;

  Module({this.id, this.chapterDocumentId, required this.moduleName});

  factory Module.fromJson(Map<String, dynamic> map){
    return Module(
      id: map['id'] ?? 0,
      chapterDocumentId: map['chapterDocumentId'] ?? '',
      moduleName: map['moduleName']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'chapterDocumentId' : chapterDocumentId,
      'moduleName' : moduleName
    };
  }
}