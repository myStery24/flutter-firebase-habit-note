import 'package:flutter/material.dart';
import 'package:habit_note/providers/base_model.dart';
import 'package:habit_note/providers/text_provider.dart';
import 'package:provider/provider.dart';

import 'DisplayText.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
      ),
      body: Consumer<TextViewModel>(
        builder: (_, textProvider, __) =>
        (textProvider.state == CurrentState.idle)
            ? const Center(
          child: Text('Nothing here 😴'),
        )
            : (textProvider.state == CurrentState.error)
            ? const Center(
          child: Text('NO IMAGE TO ANALYZE 😴'),
        )
            : (textProvider.state == CurrentState.loading)
            ? const Center(child: CircularProgressIndicator())
            : Center(child: DisplayText(textProvider)),
      ),
    );
  }
}