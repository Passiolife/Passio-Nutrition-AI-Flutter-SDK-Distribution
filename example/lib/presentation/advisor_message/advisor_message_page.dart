import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/constant/app_colors.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/util/keyboard_extension.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';

import '../../common/passio_image_widget.dart';
import 'bloc/advisor_message_bloc.dart';

class AdvisorMessagePage extends StatefulWidget {
  const AdvisorMessagePage({super.key});

  @override
  State<AdvisorMessagePage> createState() => _AdvisorMessagePageState();
}

class _AdvisorMessagePageState extends State<AdvisorMessagePage> {
  String _userQuery = '';
  PassioAdvisorResponse? _response;
  bool _enabled = true;

  final _bloc = AdvisorMessageBloc();

  final TextEditingController _messageController =
      TextEditingController(text: '');

  bool _isLoadingIngredients = false;
  List<PassioAdvisorFoodInfo>? _ingredients;

  @override
  void initState() {
    _bloc.add(const DoInitConversionEvent());
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvisorMessageBloc, AdvisorMessageState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is InitializationSuccessState) {
          _enabled = true;
        } else if (state is InitializationErrorState) {
          context.showSnackbar(text: state.message);
        } else if (state is SendMessageSuccessState) {
          _response = state.data;
        } else if (state is SendMessageErrorState) {
          context.showSnackbar(text: state.message);
        } else if (state is FetchIngredientErrorState) {
          _isLoadingIngredients = false;
          context.showSnackbar(text: state.message);
        } else if (state is FetchIngredientSuccessState) {
          _isLoadingIngredients = false;
          _ingredients = state.response.extractedIngredients;
        } else if (state is FetchIngredientsLoadingState) {
          _isLoadingIngredients = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Advisor'),
          ),
          body: Column(
            children: [
              Container(
                color: AppColors.blue50,
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 24.w, right: 8.w),
                child: Text(
                  _userQuery,
                ),
              ),
              Expanded(
                child: Container(
                  color: AppColors.green100,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 8.w, right: 24.w),
                  child: Markdown(
                    data: _response?.markupContent ?? '',
                  ),
                ),
              ),
              8.verticalSpace,
              Expanded(
                child: Container(
                  color: AppColors.green100,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 8.w, right: 24.w),
                  child: SingleChildScrollView(
                    child: Text(
                      _response?.rawContent ?? '',
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              Expanded(
                child: _isLoadingIngredients
                    ? const Center(child: CircularProgressIndicator())
                    : (_response == null)
                        ? const Text('')
                        : (_ingredients?.isNotEmpty ?? false)
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _ingredients?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final data = _ingredients?.elementAt(index);
                                  return ListTile(
                                    leading: PassioImageWidget(
                                        iconId:
                                            data?.foodDataInfo?.iconID ?? ''),
                                    title: Text(data?.foodDataInfo?.foodName
                                            .toUpperCaseWord ??
                                        ''),
                                  );
                                },
                              )
                            : (_ingredients == null &&
                                    (_response?.tools?.contains(
                                            'SearchIngredientMatches') ??
                                        false))
                                ? Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _bloc.add(DoFetchIngredientEvent(
                                            response: _response));
                                      },
                                      child: const Text('Fetch Ingredients'),
                                    ),
                                  )
                                : const Center(child: Text('No Ingredients')),
              ),
              Padding(
                padding: EdgeInsets.all(8.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: AppColors.indigo100,
                        child: TextFormField(
                          controller: _messageController,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    ElevatedButton(
                      onPressed: _enabled
                          ? () {
                              context.hideKeyboard();
                              _userQuery = _messageController.text;
                              _response = null;
                              _bloc
                                  .add(DoSendMessageEvent(message: _userQuery));
                              _messageController.text = '';
                            }
                          : null,
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
              (context.bottomPadding + 8.h).verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
