import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/constant/app_colors.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/presentation/nutrition_facts/bloc/nutrition_facts_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class NutritionFactsPage extends StatefulWidget {
  const NutritionFactsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NutritionFactsPageState();
}

class _NutritionFactsPageState extends State<NutritionFactsPage>
    implements NutritionFactsRecognitionListener {
  final _bloc = NutritionFactsBloc();

  PassioNutritionFacts? nutritionFacts;
  String? text;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutritionFactsBloc, NutritionFactsState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SearchingState) {
          _onSearchingState(state);
        } else if (state is UpdateNutritionFactsState) {
          _handleUpdateNutritionFactsState(state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Passio Preview'),
          ),
          body: Stack(
            children: [
              const PassioPreview(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  color: AppColors.white.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text('Text: $text'),
                      Expanded(
                        child: NutritionFactsWidget(
                          nutritionFacts: nutritionFacts,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.bottomPadding),
                  child: ElevatedButton(
                    onPressed: () async {
                      await NutritionAI.instance.stopNutritionFactsDetection();
                    },
                    child: Text(context.localization?.stopDetection ?? ''),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onSearchingState(SearchingState state) {}

  void _handleUpdateNutritionFactsState(UpdateNutritionFactsState state) {
    // text = state.text;
    nutritionFacts = state.nutritionFacts;
  }

  void _checkPermission() async {
    if (await Permission.camera.request().isGranted) {
      _startNutritionFactsDetection();
    }
  }

  void _startNutritionFactsDetection() {
    NutritionAI.instance.startNutritionFactsDetection(this);
  }

  @override
  void dispose() {
    NutritionAI.instance.stopFoodDetection();
    super.dispose();
  }

  @override
  void onNutritionFactsRecognized(
      PassioNutritionFacts? nutritionFacts, String? text) {
    _bloc.add(NutritionFactsRecognizedEvent(
        text: text, nutritionFacts: nutritionFacts));
  }
}

class NutritionFactsWidget extends StatelessWidget {
  final PassioNutritionFacts? nutritionFacts;

  const NutritionFactsWidget({super.key, required this.nutritionFacts});

  Widget _buildNutritionRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$title :',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNutritionRow(
                'Added Sugar', nutritionFacts?.addedSugar?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Calcium', nutritionFacts?.calcium?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Calories', nutritionFacts?.calories?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Carbs', nutritionFacts?.carbs?.toString() ?? 'N/A'),
            _buildNutritionRow('Cholesterol',
                nutritionFacts?.cholesterol?.toString() ?? 'N/A'),
            _buildNutritionRow('Dietary Fiber',
                nutritionFacts?.dietaryFiber?.toString() ?? 'N/A'),
            _buildNutritionRow('Fat', nutritionFacts?.fat?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Ingredients', nutritionFacts?.ingredients ?? 'N/A'),
            _buildNutritionRow(
                'Iron', nutritionFacts?.iron?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Potassium', nutritionFacts?.potassium?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Protein', nutritionFacts?.protein?.toString() ?? 'N/A'),
            _buildNutritionRow('Saturated Fat',
                nutritionFacts?.saturatedFat?.toString() ?? 'N/A'),
            _buildNutritionRow('Serving Size',
                nutritionFacts?.servingSize?.toString() ?? 'N/A'),
            _buildNutritionRow('Serving Size Quantity',
                nutritionFacts?.servingSizeQuantity?.toString() ?? 'N/A'),
            _buildNutritionRow('Serving Size Unit Name',
                nutritionFacts?.servingSizeUnitName?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Sodium', nutritionFacts?.sodium?.toString() ?? 'N/A'),
            _buildNutritionRow('Sugar Alcohol',
                nutritionFacts?.sugarAlcohol?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Sugars', nutritionFacts?.sugars?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Trans Fat', nutritionFacts?.transFat?.toString() ?? 'N/A'),
            _buildNutritionRow(
                'Vitamin D', nutritionFacts?.vitaminD?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}
