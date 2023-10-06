import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/dialogs/new_recipe_dialog.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/food_details_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/bloc/multi_food_scan_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/widgets/bottom_sheet_list_row.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/widgets/result_bottom_sheet.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/permission_manager_utility.dart';
import 'package:flutter_nutrition_ai_demo/util/snackbar_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

class MultiFoodScanPage extends StatefulWidget {
  const MultiFoodScanPage({required this.selectedDateTime, super.key});
  final DateTime selectedDateTime;

  @override
  State<MultiFoodScanPage> createState() => _MultiFoodScanPageState();
}

class _MultiFoodScanPageState extends State<MultiFoodScanPage> implements FoodRecognitionListener {
  ///
  final _bloc = sl<MultiFoodScanBloc>();

  /// [detectedList] contains list of [FoodRecord] data.
  final List<FoodRecord?> _detectedList = [];

  /// [_removedList] contains list of [FoodRecord] data which are removed particularly.
  final List<FoodRecord?> _removedList = [];

  /// _listKey
  GlobalKey<AnimatedListState>? _listKey;

  /// [_hasRecordAdded] is by default false. If any record adds into the DB then flag will be true.
  bool _hasRecordAdded = false;

  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _stopFoodDetection();
    _bloc.close();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(_hasRecordAdded);
        return false;
      },
      child: BlocConsumer<MultiFoodScanBloc, MultiFoodScanState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is QuickFoodSuccessState) {
            _handleQuickFoodSuccessState(state: state);
          } else if (state is ShowFoodDetailsViewState) {
            _handleShowFoodDetailsViewState(state: state);
          } else if (state is FoodInsertSuccessState) {
            _handleFoodInsertSuccessState(state: state);
          } else if (state is FoodInsertFailureState) {
            _handleFoodInsertFailureState(state: state);
          }
          // state for DoNewRecipeEvent
          else if (state is NewRecipeSuccessState) {
            _handleNewRecipeAddedState(state: state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                /// [PassioPreview] is to detect the food.
                const PassioPreview(),

                /// Here, we are showing the close button.
                /// When user tap on the icon it will redirect to the previous screen.
                Positioned(
                  top: context.topPadding + Dimens.h24,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.pop(_hasRecordAdded);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: Dimens.w8),
                      child: SvgPicture.asset(
                        AppImages.icCancelCircle,
                        width: Dimens.r22,
                        height: Dimens.r22,
                      ),
                    ),
                  ),
                ),

                /// Here, we are showing the bottom sheet.
                (state is ShowFoodDetailsViewState && state.isVisible)
                    ? Align(
                        alignment: Alignment.center,
                        child: FoodDetailsWidget(
                          visibleFavouriteButton: false,
                          foodRecord: _detectedList.elementAt(state.index),
                          onCancel: () {
                            _bloc.add(ShowFoodDetailsViewEvent(isVisible: false, index: state.index));
                          },
                          onSave: (data) {
                            _bloc.add(ShowFoodDetailsViewEvent(isVisible: false, index: state.index));
                            if (data != null) {
                              _detectedList[state.index] = data;
                            }
                          },
                        ),
                      )
                    : Positioned.fill(
                        child: ResultBottomSheet(
                          detectedList: _detectedList,
                          onAnimationListRender: (key) {
                            _listKey = key;
                          },
                          onTapItem: (index) {
                            _bloc.add(ShowFoodDetailsViewEvent(isVisible: true, index: index));
                          },
                          onTapClearItem: (index, data) {
                            _detectedList.remove(data);
                            _removedList.add(data);
                            _listKey?.currentState
                                ?.removeItem(index, (context, animation) => BottomSheetListRow(foodRecord: data, animation: animation));
                          },
                          onTapClear: () {

                            _bloc.add(DoClearAllEvent());
                            _removedList.clear();
                            _detectedList.clear();
                            _listKey?.currentState?.removeAllItems((context, animation) => const SizedBox.shrink());
                          },
                          onTapAddAll: () {
                            _stopFoodDetection();
                            _hasRecordAdded = true;
                            _bloc.add(DoAddAllEvent(data: _detectedList.toList(), dateTime: widget.selectedDateTime));
                          },
                          onTapNewRecipe: () {
                            _stopFoodDetection();
                            NewRecipeDialog.show(
                              context: context,
                              text: '',
                              onSave: (value) {
                                _hasRecordAdded = true;
                                _bloc.add(DoNewRecipeEvent(data: List.of(_detectedList), name: value, dateTime: widget.selectedDateTime));
                                _detectedList.clear();
                                _listKey?.currentState?.removeAllItems((context, animation) => const SizedBox.shrink());
                                _startFoodDetection();
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _initialize() {
    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _checkPermission();
    });
  }

  Future _checkPermission() async {
    PermissionManagerUtility().request(
      context,
      Permission.camera,
      title: 'Permission',
      message: 'Please allow camera permission access to scan the food.',
      onTapCancelForSettings: () {
        context.pop();
        context.pop();
      },
      onUpdateStatus: (Permission? permission, bool isOpenSettingDialogVisible) async {
        if ((await permission?.isGranted) ?? false) {
          if (isOpenSettingDialogVisible) {
            if (context.mounted) {
              context.pop();
            }
          }
          _startFoodDetection();
        }
      },
    );
  }

  void _onStateChanged(AppLifecycleState value) {
    PermissionManagerUtility().didChangeAppLifecycleState(value);
  }

  @override
  void recognitionResults(FoodCandidates foodCandidates) {
    _bloc.add(RecognitionResultEvent(foodCandidates: foodCandidates, list: _detectedList, removedList: _removedList, dateTime: widget.selectedDateTime));
  }

  void _startFoodDetection() {
    var detectionConfig = FoodDetectionConfiguration(detectBarcodes: true, detectPackagedFood: true);
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  void _stopFoodDetection() {
    NutritionAI.instance.stopFoodDetection();
  }

  void _handleQuickFoodSuccessState({required QuickFoodSuccessState state}) {
    _listKey?.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
    _detectedList.insert(0, state.foodRecord);
  }

  void _handleShowFoodDetailsViewState({required ShowFoodDetailsViewState state}) {
    if (state.isVisible) {
      _stopFoodDetection();
    } else {
      _checkPermission();
    }
  }

  void _handleFoodInsertSuccessState({required FoodInsertSuccessState state}) {
    _checkPermission();
    _removedList.clear();
    _detectedList.clear();
    _listKey?.currentState?.removeAllItems((context, animation) => const SizedBox.shrink());
  }

  void _handleFoodInsertFailureState({required FoodInsertFailureState state}) {
    _checkPermission();
    _removedList.clear();
    _detectedList.clear();
    _listKey?.currentState?.removeAllItems((context, animation) => const SizedBox.shrink());
  }

  void _handleNewRecipeAddedState({required NewRecipeSuccessState state}) {
    context.showSnackbar(text: context.localization?.recipeAddedMessage);
  }

}
