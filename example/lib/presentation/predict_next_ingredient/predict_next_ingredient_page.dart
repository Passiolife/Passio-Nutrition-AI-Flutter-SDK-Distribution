import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/passio_image_widget.dart';
import 'package:nutrition_ai_example/presentation/predict_next_ingredient/bloc/predict_next_bloc.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';

import '../food_analysis/widgets/search_widget.dart';

class PredictNextIngredientPage extends StatefulWidget {
  const PredictNextIngredientPage({super.key});

  @override
  State<PredictNextIngredientPage> createState() =>
      _PredictNextIngredientPageState();
}

class _PredictNextIngredientPageState extends State<PredictNextIngredientPage>
    with SingleTickerProviderStateMixin {
  final _bloc = PredictNextIngredientBloc();

  /// [_searchController] A controller for an editable text field.
  /// The text field updates value and the controller notifies its listeners
  final TextEditingController _searchController =
      TextEditingController(text: 'Flour, sugar, eggs');

  final List<PassioFoodDataInfo> _resultList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _doFetchSuggestions();
    });
  }

  void _doFetchSuggestions() {
    _resultList.clear();
    final ingredients =
        _searchController.text.split(',').map((e) => e.trim()).toList();
    _bloc.add(FetchPredictNextIngredientEvent(nextIngredients: ingredients));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            BlocConsumer<PredictNextIngredientBloc, PredictNextIngredientState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is FetchPredictNextIngredientSuccessState) {
              _resultList.clear();
              _resultList.addAll(state.data);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SearchWidget(
                  searchController: _searchController,
                  onTapCancel: () {
                    Navigator.pop(context);
                  },
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _resultList.length,
                  itemBuilder: (context, index) {
                    final data = _resultList.elementAt(index);
                    return ListTile(
                      tileColor: Colors.black12,
                      leading: PassioImageWidget(iconId: data.iconID),
                      title: Text(data.foodName.toUpperCaseWord),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
