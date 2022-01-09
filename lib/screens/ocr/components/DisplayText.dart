import 'package:flutter/material.dart';
import 'package:habit_note/providers/text_provider.dart';

class DisplayText extends StatelessWidget {
  final TextViewModel? textProvider;
  const DisplayText(this.textProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Found ${textProvider!.processedTexts!.length} items from image',
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: textProvider!.processedTexts!.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (_, index) {
              return Center(
                child: ListTile(
                    title: Center(
                      child: SelectableText(
                          '${index + 1}: ${textProvider!.processedTexts![index].block}'),
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
}