class Question {

  final String? id;
  final String? chapterId;
  final String questionBody;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String answerE;
  final List<String> correctAnswers;

  Question({
      this.id,
      this.chapterId,
      required this.questionBody,
      required this.answerA,
      required this.answerB,
      required this.answerC,
      required this.answerD,
      required this.answerE,
      required this.correctAnswers});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<dynamic> responses = json['correctAnswers'];
    List<String> parsedResponses = responses.map((response) => response.toString()).toList();
    return Question(
      id: json['id'] as String?,
      chapterId: json['chapterId'] as String?,
      questionBody: json['questionBody'] as String,
      answerA: json['answerA'] as String,
      answerB: json['answerB'] as String,
      answerC: json['answerC'] as String,
      answerD: json['answerD'] as String,
      answerE: json['answerE'] as String,
      correctAnswers: parsedResponses //List<String>.from(json['correctAnswers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'questionBody': questionBody,
      'answerA': answerA,
      'answerB': answerB,
      'answerC': answerC,
      'answerD': answerD,
      'answerE': answerE,
      'correctAnswers': correctAnswers,
    };
  }
}