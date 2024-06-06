import '../utils/enums/gpt_actions_enum.dart';

class GPTInput {
  final String input;
  final GptActions? action;
  final int? questionNumber;

  GPTInput({required this.input, this.action, this.questionNumber});


  Map<String, dynamic> toJson(){
    return {
      'input' : input,
      'action' : action?.name,
      'questionNumber' : questionNumber
    };
  }
}
