import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/passio_image_widget.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/presentation/recognize_speech/bloc/recognize_speech_bloc.dart';

import '../../const/app_colors.dart';
import '../food_search/widgets/search_widget.dart';

class RecognizeSpeechPage extends StatefulWidget {
  const RecognizeSpeechPage({super.key});

  @override
  State<RecognizeSpeechPage> createState() => _RecognizeSpeechPageState();
}

class _RecognizeSpeechPageState extends State<RecognizeSpeechPage> {
  final _controller = TextEditingController(text: '');

  final _bloc = RecognizeSpeechBloc();

  final List<PassioSpeechRecognitionModel> result = [];

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecognizeSpeechBloc, RecognizeSpeechState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SpeechRecognitionSuccessState) {
          result.clear();
          result.addAll(state.data);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.searchFieldColor,
          body: Column(
            children: [
              SizedBox(height: context.topPadding),
              SearchWidget(
                searchController: _controller,
                hintText: context.localization?.enterText,
                onSearch: (value) {
                  _bloc.add(DoRecognizeEvent(value));
                },
                onTapCancel: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    final data = result.elementAt(index);
                    return ListTile(
                      leading: PassioImageWidget(
                          iconId: data.advisorInfo.foodDataInfo?.iconID ?? ''),
                      title: Text(data.advisorInfo.foodDataInfo?.foodName
                              .toUpperCaseWord ??
                          ''),
                      subtitle: Text(
                          '${data.mealTime?.name.toUpperCaseWord ?? ''} | ${data.date} | ${data.action?.name.toUpperCaseWord ?? ''}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
