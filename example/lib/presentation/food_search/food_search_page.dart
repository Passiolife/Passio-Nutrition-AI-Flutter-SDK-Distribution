import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';
import 'package:nutrition_ai_example/const/app_constants.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/food_search/bloc/food_search_bloc.dart';
import 'package:nutrition_ai_example/presentation/food_search/widgets/food_search_item_row.dart';
import 'package:nutrition_ai_example/presentation/food_search/widgets/search_widget.dart';
import 'package:nutrition_ai_example/util/debouncer.dart';
import 'package:nutrition_ai_example/util/keyboard_extension.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  /// [_searchController] A controller for an editable text field.
  /// The text field updates value and the controller notifies its listeners
  final TextEditingController _searchController = TextEditingController();

  /// [_searchQuery] we set the search query to this members.
  String _searchQuery = '';

  /// [_filteredFoodItems] list is use to show the filtered food items which will get from the API.
  final List<PassioFoodDataInfo> _filteredFoodItems = [];

  /// [_filteredFoodItemsImages] map is use to store the platform images.
  final Map<String?, PlatformImage?> _filteredFoodItemsImages = {};

  /// [_searchDeBouncer] when user stops typing then waits [500] milliseconds and do the search operation.
  final _searchDeBouncer = DeBouncer(milliseconds: 500);

  /// [FoodSearchBloc] is use to call the events and emitting the states.
  final _bloc = sl<FoodSearchBloc>();

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
        if (state is FoodSearchTypingState) {
          _handleFoodSearchTypingState(state: state);
        } else if (state is FoodSearchLoadingState) {
          _handleFoodSearchLoadingState(state: state);
        } else if (state is FoodSearchSuccessState) {
          _handleFoodSearchSuccessState(state: state);
        } else if (state is FoodSearchFailureState) {
          _handleFoodSearchFailureState(state: state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.searchFieldColor,
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
              /*ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Chip(label: Text(''));
                },
              ),*/
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FoodSearchItemRow(
                      key: UniqueKey(),
                      data: _filteredFoodItems.elementAt(index),
                      foodItemsImages: _filteredFoodItemsImages,
                      onTapItem: (data) async {
                        context.hideKeyboard();
                        context.showSnackbar(
                            text:
                                '${data?.foodName.toTitleCase()} is added to the logs.');
                        if (data != null) {
                          _bloc.add(DoFetchFoodItemEvent(foodInfo: data));
                        }
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

    /// Here calling the [DoFoodSearchEvent] to perform the search related things.
    _bloc.add(DoFoodSearchEvent(searchQuery: _searchQuery));
  }

  void _handleFoodSearchSuccessState({required FoodSearchSuccessState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.addAll(state.results);
  }

  void _handleFoodSearchTypingState({required FoodSearchTypingState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioFoodDataInfo(
      iconID: AppConstants.removeIcon,
      foodName: context.localization?.keepTyping ?? '',
      brandName: '',
      labelId: '',
      nutritionPreview: const PassioSearchNutritionPreview(
        calories: 10,
        carbs: 0,
        fat: 0,
        protein: 0,
        servingUnit: '',
        servingQuantity: 0,
        weightUnit: '',
        weightQuantity: 0,
        fiber: 0,
      ),
      resultId: '',
      scoredName: '',
      score: 0,
      type: '',
      isShortName: false,
      tags: [],
    ));
  }

  void _handleFoodSearchLoadingState({required FoodSearchLoadingState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioFoodDataInfo(
      iconID: AppConstants.searching,
      foodName: context.localization?.searching ?? '',
      brandName: '',
      labelId: '',
      nutritionPreview: const PassioSearchNutritionPreview(
        calories: 10,
        carbs: 0,
        fat: 0,
        protein: 0,
        servingUnit: '',
        servingQuantity: 0,
        weightUnit: '',
        weightQuantity: 0,
        fiber: 0,
      ),
      resultId: '',
      scoredName: '',
      score: 0,
      type: '',
      isShortName: false,
      tags: [],
    ));
  }

  void _handleFoodSearchFailureState({required FoodSearchFailureState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioFoodDataInfo(
      iconID: AppConstants.removeIcon,
      foodName:
          '${state.searchQuery} ${context.localization?.noFoodSearchResultMessage ?? ''}',
      brandName: '',
      labelId: '',
      nutritionPreview: const PassioSearchNutritionPreview(
        calories: 10,
        carbs: 0,
        fat: 0,
        protein: 0,
        servingUnit: '',
        servingQuantity: 0,
        weightUnit: '',
        weightQuantity: 0,
        fiber: 0,
      ),
      resultId: '',
      scoredName: '',
      score: 0,
      type: '',
      isShortName: false,
      tags: [],
    ));
  }
}
