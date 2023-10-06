import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/favourite/bloc/favourite_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/favourite/dialogs/no_favorites_data_dialog.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/favourite/widgets/favorite_list_row.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_nutrition_ai_demo/router/routes.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/snackbar_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final _bloc = sl<FavouriteBloc>();

  List<FoodRecord?>? _foodRecordList = [];

  // [_hasFoodLogged] flag will update when any food is added to the log. so based on this we will update the log screen.
  bool _hasFoodLogged = false;

  @override
  void initState() {
    _bloc.add(GetAllFavoritesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(_hasFoodLogged);
        return false;
      },
      child: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is GetAllFavouritesSuccessState) {
            _handleGetAllFavouritesSuccessState(state: state);
          }
          // States for [DoFavoriteDeleteEvent]
          else if (state is FavoriteDeleteFailureState) {
            _handleFavoriteDeleteFailureState(state: state);
          }
          // States for [DoLogEvent]
          else if (state is FoodRecordLogSuccessState) {
            _handleFoodRecordLogSuccessState(state: state);
          }else if (state is FoodRecordLogFailureState) {
            _handleFoodRecordLogFailureState(state: state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: context.localization?.myFavorites ?? '',
              titleColor: AppColors.blackColor,
              isBackVisible: true,
              backPageName: context.localization?.back ?? '',
              backPageNameColor: AppColors.blackColor,
              onBackTap: () {
                context.pop(_hasFoodLogged);
              },
              leadingWidth: Dimens.w92,
            ),
            body: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: _foodRecordList?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = _foodRecordList?.elementAt(index);
                  return FavoriteListRow(
                    key: ValueKey(data?.passioID),
                    index: index,
                    data: data,
                    isAddToLogLoading: (state is FoodRecordLogLoadingState) && state.index==index,
                    onEditItem: _handleOnEditItem,
                    onDeleteItem: _handleOnDeleteItem,
                    onAddToLog: _handleOnAddToLog,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleGetAllFavouritesSuccessState({required GetAllFavouritesSuccessState state}) {
    _foodRecordList = state.data;
    if(_foodRecordList?.isEmpty ?? true) {
      _showNoDataFoundDialog();
    }
  }

  Future<void> _handleOnEditItem(int index, FoodRecord? data) async {
    // Opening edit food page and awaiting for the result from edit page based on user action if action is save or favourite then perform action.
    (String? action, FoodRecord? foodRecord)? result = await context
        .pushNamed(Routes.editFoodPage, extra: {AppConstants.index: index, AppConstants.data: data, AppConstants.visibleFavouriteButton: false});
    // Checking result is null or not.
    if (result != null && result.$1 != null) {
      // Extracting food record data from [result].
      FoodRecord? foodRecord = result.$2;
      if (foodRecord != null) {
        // Checking the context is mounted or alive.
        if (context.mounted) {
          // Checking the action performed by the user.
          if (result.$1 == context.localization?.save) {
            // Updating id because [editFoodPage] converts [data] to new object so model class have include false so id will be null.
            foodRecord.id = data?.id;
            // Checking [foodRecord] is null or not.
            // If not null then update the record in [_foodRecordsList].
            _foodRecordList?[index] = foodRecord;
            // Firing bloc event to update the food record in local DB.
            _bloc.add(DoFavoriteUpdateEvent(data: foodRecord));
          }
        }
      }
    }
  }

  /// Favorite Delete Flow.
  void _handleOnDeleteItem(int index, FoodRecord? data) {
    _foodRecordList?.removeAt(index);
    _bloc.add(DoFavoriteDeleteEvent(data: data));
    // Here if no any data in screen then pop then show the dialog
    if(_foodRecordList?.isEmpty ?? true) {
      _showNoDataFoundDialog();
    }
  }

  void _handleFavoriteDeleteFailureState({required FavoriteDeleteFailureState state}) {
    context.showSnackbar(text: state.message);
  }
  /// END: Favorite Delete Flow.

  void _showNoDataFoundDialog() {
    NoFavoritesDataDialog.show(
      context: context,
      title: context.localization?.noFavoriteTitle,
      message: context.localization?.noFavoriteDescription,
      positiveButtonText: context.localization?.ok,
      onTapPositive: (){
        context.pop();
        context.pop();
      }
    );
  }

  /// Add Log Flow.
  void _handleOnAddToLog(int index, FoodRecord? data) {
    _hasFoodLogged = true;
    _bloc.add(DoLogEvent(data: data, index: index));
  }

  void _handleFoodRecordLogFailureState({required FoodRecordLogFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  void _handleFoodRecordLogSuccessState({required FoodRecordLogSuccessState state}) {
    context.showSnackbar(text: context.localization?.logSuccessMessage);
  }


}
