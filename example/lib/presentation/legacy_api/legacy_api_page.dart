import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/presentation/legacy_api/bloc/legacy_api_bloc.dart';

import '../../const/app_colors.dart';
import '../food_search/widgets/search_widget.dart';

class LegacyApiPage extends StatefulWidget {
  const LegacyApiPage({super.key});

  @override
  State<LegacyApiPage> createState() => _LegacyApiPageState();
}

class _LegacyApiPageState extends State<LegacyApiPage> {
  /*
  Visual Recognition:
        1.
                Name: Red Apple
                Passio ID: VEG3319
        2.
                Name: Banana
                Passio ID: VEG0023

Barcode:
        1.
                Name: Food For Life Sprouted Whole Grain Bread
                Passio ID: barcode073472001202
        2.
                Name: Alpro Vanilla Soy Yogurt
                Passio ID: barcode5411188103387

Product/Package Food:
        1.
                Name: Atkins Harvset Trail Vanilla Fruit & Nut Bar
                Passio ID: packagedFoodCode637480045827
        2.
                Name: Clif Shot Energy Gel Vanilla
                Passio ID: packagedFoodCode722252176240
   */
  String result = '';

  final _controller = TextEditingController(text: 'VEG3319');

  final _bloc = LegacyApiBloc();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LegacyApiBloc, LegacyApiState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is FetchLegacySuccessState) {
          result = state.data;
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
                hintText: context.localization?.searchPassioID,
                onSearch: (value) {
                  _bloc.add(DoFetchLegacyEvent(value));
                },
                onTapCancel: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 4),
              Expanded(child: SingleChildScrollView(child: Text(result))),
            ],
          ),
        );
      },
    );
  }
}
