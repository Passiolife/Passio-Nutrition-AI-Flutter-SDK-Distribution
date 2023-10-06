import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/food_search/bloc/food_search_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/food_search/widgets/food_search_item_row.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/food_search/widgets/search_widget.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/debouncer.dart';
import 'package:flutter_nutrition_ai_demo/util/keyboard_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

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
  final List<PassioIDAndName> _filteredFoodItems = [];

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
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = _filteredFoodItems.elementAt(index);
                    return FoodSearchItemRow(
                      key: ValueKey(data.passioID),
                      data: data,
                      foodItemsImages: _filteredFoodItemsImages,
                      onTapItem: _handleOnTapFoodItem,
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
    if (text.length > 2 && _searchQuery.toLowerCase() == text.toLowerCase()) {
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
    _filteredFoodItems.addAll(state.data);
  }

  void _handleFoodSearchTypingState({required FoodSearchTypingState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioIDAndName(
      AppConstants.removeIcon,
      context.localization?.keepTyping ?? '',
    ));
  }

  void _handleFoodSearchLoadingState({required FoodSearchLoadingState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioIDAndName(
      AppConstants.searching,
      context.localization?.searching ?? '',
    ));
  }

  void _handleFoodSearchFailureState({required FoodSearchFailureState state}) {
    _filteredFoodItems.clear();
    _filteredFoodItems.add(PassioIDAndName(
      AppConstants.removeIcon,
      '${state.searchQuery} ${context.localization?.noFoodSearchResultMessage ?? ''}',
    ));
  }

  void _handleOnTapFoodItem(PassioIDAndName? data) {
    context.hideKeyboard();
    context.pop(data);
    /*_bloc.add(DoFoodInsertEvent(data: data));

    /// Here, we are hiding the keyboard if open.
    context.hideKeyboard();*/
  }
}
