import 'package:brainify_flutter/view_models/gpt_viewmodel.dart';
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
    // Add a listener to the GptViewModel
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
    if (gptViewModel.gptState == GPTState.success &&
        gptViewModel.gptMessage.isNotEmpty) {
      setState(() {
        _messages.add({
          'user': _controller.text,
          'response': gptViewModel.gptMessage,
        });
        _controller.clear();
      });
    } else if (gptViewModel.gptState == GPTState.error) {
      setState(() {
        _messages.add({
          'user': _controller.text,
          'response': gptViewModel.errorMessage,
        });
        _controller.clear();
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      context.read<GptViewModel>().chatBot(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(70, 40, 42, 53),
      body: Column(
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
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(190, 40, 42, 53)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'A: ${_messages[index]['response']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(190, 40, 42, 53)),
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
                    decoration:  const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: context.watch<GptViewModel>().loading
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
