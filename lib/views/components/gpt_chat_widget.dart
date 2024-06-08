import 'package:brainify_flutter/view_models/gpt_viewmodel.dart';
import 'package:brainify_flutter/views/components/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GptViewModel>().addListener(_gptMessageListener);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    context.read<GptViewModel>().removeListener(_gptMessageListener);
    _controller.dispose();
    super.dispose();
  }

  void _gptMessageListener() {
    final gptViewModel = context.read<GptViewModel>();
    if (gptViewModel.chatState == ChatState.success && gptViewModel.gptMessage.isNotEmpty) {
      setState(() {
        _messages.add({
          'user': gptViewModel.currentUserMessage,
          'response': gptViewModel.gptMessage,
        });
      });
    } else if (gptViewModel.chatState == ChatState.error) {
      setState(() {
        _messages.add({
          'user': gptViewModel.currentUserMessage,
          'response': gptViewModel.errorMessage,
        });
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final message = _controller.text;
      context.read<GptViewModel>().setCurrentUserMessage(message);
      _controller.clear();
      await context.read<GptViewModel>().chatBot(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 233, 235),
      body: context.watch<GptViewModel>().chatState == ChatState.loading ?
      const LoadingWidget(message: 'Generating Response') :
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q: ${_messages[index]['user']}',
                            style:  TextStyle(
                              fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,)
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'A: ${_messages[index]['response']}',
                            style:  TextStyle(
                              fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: context.watch<GptViewModel>().chatState == ChatState.loading
                      ? CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                      : Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
