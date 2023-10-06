import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/food_details_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/quick_food_scan/bloc/quick_food_scan_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/quick_food_scan/widgets/food_result_searching_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/quick_food_scan/widgets/food_result_widget.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/permission_manager_utility.dart';
import 'package:flutter_nutrition_ai_demo/util/snackbar_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

class QuickFoodScanPage extends StatefulWidget {
  const QuickFoodScanPage({required this.selectedDateTime,super.key});
  final DateTime selectedDateTime;

  @override
  State<QuickFoodScanPage> createState() => _QuickFoodScanPageState();
}

class _QuickFoodScanPageState extends State<QuickFoodScanPage> implements FoodRecognitionListener {
  /// [_displayedFood] is currently visible to user when found any result in recognition.
  String? _displayedFood;

  /// [_foodRecord] is food data which we get from SDK.
  FoodRecord? _foodRecord;

  /// [_bloc] is
  final _bloc = sl<QuickFoodScanBloc>();

  /// [_hasRecordAdded] is by default false. If any record adds into the DB then flag will be true.
  /// If flag is true then we will refresh the dashboard page to fetch the data from DB.
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
      child: BlocConsumer<QuickFoodScanBloc, QuickFoodScanState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is QuickFoodLoadingState) {
            _foodRecord = null;
            _displayedFood = null;
          } else if (state is QuickFoodSuccessState) {
            _handleQuickFoodSuccessState(state: state);
          } else if (state is ShowFoodDetailsViewState) {
            _handleShowFoodDetailsViewState(state: state);
          } else if(state is FavoriteSuccessState) {
            context.showSnackbar(text: context.localization?.favoriteSuccessMessage);
          } else if(state is FavoriteFailureState) {
            context.showSnackbar(text: state.message);
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

                if (state is ShowFoodDetailsViewState && state.isVisible)
                  Align(
                    alignment: Alignment.center,
                    child: FoodDetailsWidget(
                      foodRecord: _foodRecord,
                      saveButtonText: context.localization?.log,
                      onCancel: () {
                        _bloc.add(ShowFoodDetailsViewEvent(isVisible: false));
                      },
                      onSave: (foodRecord) {
                        _hasRecordAdded = true;
                        _bloc.add(DoLogEvent(data: foodRecord));
                        _bloc.add(ShowFoodDetailsViewEvent(isVisible: false));
                        context.showSnackbar(text: context.localization?.logSuccessMessage ?? '');
                      },
                      onFavourite: (foodRecord) {
                        _bloc.add(DoFavouriteEvent(data: foodRecord, dateTime: DateTime.now()));
                      },
                    ),
                  )
                else
                  Positioned(
                    bottom: Dimens.h40,
                    left: Dimens.w8,
                    right: Dimens.w8,
                    child: _foodRecord != null
                        ? FoodResultWidget(
                            key: ValueKey(_foodRecord?.passioID ?? ''),
                            title: _foodRecord?.name,
                            subTitle: _foodRecord?.ingredients?.firstOrNull?.name ?? '',
                            passioID: _foodRecord?.passioID ?? '',
                            entityType: _foodRecord?.entityType ?? PassioIDEntityType.item,
                            onTapResult: () {
                              _bloc.add(ShowFoodDetailsViewEvent(isVisible: true));
                            },
                          )
                        : const FoodResultSearchingWidget(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void recognitionResults(FoodCandidates foodCandidates) {
    _bloc.add(RecognitionResultEvent(foodCandidates: foodCandidates, displayedResult: _displayedFood, dateTime: widget.selectedDateTime));
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

  void _startFoodDetection() {
    var detectionConfig = FoodDetectionConfiguration(detectBarcodes: true, detectPackagedFood: true);
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  Future<void> _stopFoodDetection() async {
    await NutritionAI.instance.stopFoodDetection();
  }

  void _handleQuickFoodSuccessState({required QuickFoodSuccessState state}) {
    _displayedFood = state.data;
    _foodRecord = state.foodRecord;
  }

  void _handleShowFoodDetailsViewState({required ShowFoodDetailsViewState state}) {
    if (state.isVisible) {
      _stopFoodDetection();
    } else {
      _checkPermission();
    }
  }
}
