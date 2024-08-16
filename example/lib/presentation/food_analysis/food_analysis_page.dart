import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/presentation/food_analysis/bloc/food_analysis_bloc.dart';
import 'package:nutrition_ai_example/util/keyboard_extension.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';

import '../../common/constant/app_colors.dart';
import '../../util/debouncer.dart';
import '../food_search/widgets/search_widget.dart';
import 'widgets/food_search_item_row.dart';

class FoodAnalysisPage extends StatefulWidget {
  const FoodAnalysisPage({super.key});

  @override
  State<FoodAnalysisPage> createState() => _FoodAnalysisPageState();
}

class _FoodAnalysisPageState extends State<FoodAnalysisPage> {
  /// [_searchController] A controller for an editable text field.
  /// The text field updates value and the controller notifies its listeners
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<PassioAdvisorFoodInfo> _filteredFoodItems = [];

  final _searchDeBouncer = DeBouncer(milliseconds: 500);

  final _bloc = FoodAnalysisBloc();

  final List<String> _types = [
    'fetchHiddenIngredients',
    'fetchVisualAlternatives',
    'fetchPossibleIngredients'
  ];
  String _selectedType = '';

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    /// Here, we are disposing the [_searchController].
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        /// Here we will manage the listener related things.
        if (state is FoodAnalysisTypingState) {
          _handleFoodSearchTypingState(state: state);
        } else if (state is FoodAnalysisLoadingState) {
          _handleFoodSearchLoadingState(state: state);
        } else if (state is FoodAnalysisSuccessState) {
          _handleFoodSearchSuccessState(state: state);
        } else if (state is FoodAnalysisFailureState) {
          _handleFoodSearchFailureState(state: state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.blue50,
          body: Column(
            children: [
              SizedBox(height: context.topPadding),
              SearchWidget(
                searchController: _searchController,
                onTapCancel: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 4),
              SegmentedButton(
                segments: _types
                    .map((e) => ButtonSegment<String>(
                          value: e,
                          label: Text(e),
                        ))
                    .toList(),
                selected: {_selectedType},
                onSelectionChanged: (value) {
                  _selectedType = value.first;
                  _doSearchCall();
                },
              ),
              const SizedBox(height: 4),
              Expanded(
                child: state is FoodAnalysisLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FoodSearchItemRow(
                            key: UniqueKey(),
                            data: _filteredFoodItems.elementAt(index),
                            onTapItem: (data) {
                              context.hideKeyboard();
                              context.showSnackbar(
                                  text:
                                      '${data?.foodDataInfo?.foodName.toTitleCase()} is added to the logs.');
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        itemCount: _filteredFoodItems.length,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    _selectedType = _types.first;
    _searchController.addListener(() {
      /// Here, managing the debounce, so it will wait until user stops the typing.
      _searchDeBouncer.run(() {
        _doSearch(_searchController.text);
      });
    });
  }

  Future<void> _doSearch(String text) async {
    /// Here, we are checking is there any search text changed
    /// If not then do nothing, else do search related operations.
    if (_searchQuery.toLowerCase() == text.toLowerCase()) {
      return;
    }
    _searchQuery = text.trim();

    /// Here, we are clearing out list to empty so based on search result we will add the data.
    _filteredFoodItems.clear();

    _doSearchCall();
  }

  void _handleFoodSearchSuccessState(
      {required FoodAnalysisSuccessState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.addAll(state.results);
  }

  void _handleFoodSearchTypingState({required FoodAnalysisTypingState state}) {
    _filteredFoodItems.clear();
  }

  void _handleFoodSearchLoadingState(
      {required FoodAnalysisLoadingState state}) {
    _filteredFoodItems.clear();
  }

  void _handleFoodSearchFailureState(
      {required FoodAnalysisFailureState state}) {
    _filteredFoodItems.clear();
    context.showSnackbar(text: state.message);
  }

  void _doSearchCall() {
    /// Here calling the [DoFoodSearchEvent] to perform the search related things.
    _bloc.add(DoFoodSearchEvent(foodName: _searchQuery, type: _selectedType));
  }
}
