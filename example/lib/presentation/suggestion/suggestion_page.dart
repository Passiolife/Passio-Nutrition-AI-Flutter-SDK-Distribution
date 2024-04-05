import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/passio_image_widget.dart';
import 'package:nutrition_ai_example/presentation/suggestion/bloc/suggestion_bloc.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';
import 'package:nutrition_ai_example/util/string_extensions.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage>
    with SingleTickerProviderStateMixin {
  final _bloc = SuggestionBloc();

  final List<MealTime> _mealTimeList = MealTime.values;

  late final _controller = TabController(length: 4, vsync: this);

  final List<PassioSearchResult> _resultList = [];

  @override
  void initState() {
    super.initState();
    _doFetchSuggestions();
    _controller.addListener(() {
      _doFetchSuggestions();
    });
  }

  void _doFetchSuggestions() {
    _resultList.clear();
    _bloc.add(FetchSuggestionsEvent(
        mealTime: _mealTimeList.elementAt(_controller.index)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestionBloc, SuggestionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is FetchSuggestionSuccessState) {
          _resultList.clear();
          _resultList.addAll(state.data);
        } else if (state is FetchFoodItemForSuggestionState) {
          context.showSnackbar(text: state.foodItem?.name);
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: _controller,
                labelPadding: EdgeInsets.zero,
                // isScrollable: true,
                tabs: _mealTimeList
                    .map((e) => Tab(
                          child: Text(e.name.toUpperCaseWord),
                        ))
                    .toList(),
              ),
              title: const Text('Suggestions'),
            ),
            body: ListView.separated(
              shrinkWrap: true,
              itemCount: _resultList.length,
              itemBuilder: (context, index) {
                final data = _resultList.elementAt(index);
                return ListTile(
                  tileColor: Colors.black12,
                  leading: PassioImageWidget(iconId: data.iconID),
                  title: Text(data.foodName.toUpperCaseWord),
                  onTap: () {
                    _bloc.add(FetchFoodItemForSuggestionEvent(result: data));
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
        );
      },
    );
  }
}
