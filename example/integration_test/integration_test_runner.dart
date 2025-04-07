import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

import 'advisor_fetch_ingredients_integration_test.dart'
    as advisor_fetch_ingredients;
import 'advisor_init_conversation_integration_test.dart'
    as advisor_init_conversation;
import 'advisor_send_image_integration_test.dart' as advisor_send_image;
import 'advisor_send_message_integration_test.dart' as advisor_send_message;
import 'configure_sdk_integration_test.dart' as configure_sdk;
import 'fetch_food_item_for_data_info_integration_test.dart'
    as fetch_food_item_for_data_info;
import 'fetch_food_item_for_passio_id_integration_test.dart'
    as fetch_food_item_for_passio_id;
import 'fetch_food_item_for_product_code_integration_test.dart'
    as fetch_food_item_for_product_code;
import 'fetch_food_item_for_ref_code_integration_test.dart'
    as fetch_food_item_for_ref_code;
import 'fetch_food_item_legacy_integration_test.dart' as fetch_food_item_legacy;
import 'fetch_hidden_ingredients_integration_test.dart'
    as fetch_hidden_ingredients;
import 'fetch_icon_for_integration_test.dart' as fetch_icon_for;
import 'fetch_inflammatory_effect_data_integration_test.dart'
    as fetch_inflammatory_effect_data;
import 'fetch_meal_plan_for_day_integration_test.dart'
    as fetch_meal_plan_for_day;
import 'fetch_meal_plans_integration_test.dart' as fetch_meal_plans;
import 'fetch_possible_ingredients_integration_test.dart'
    as fetch_possible_ingredients;
import 'fetch_suggestions_integration_test.dart' as fetch_suggestions;
import 'fetch_tags_for_integration_test.dart' as fetch_tags_for;
import 'fetch_visual_alternatives_integration_test.dart'
    as fetch_visual_alternatives;
import 'icon_url_for_integration_test.dart' as icon_url_for;
import 'lookup_icons_for_integration_test.dart' as lookup_icons_for;
import 'predict_next_ingredients_integration_test.dart'
    as predict_next_ingredients;
import 'recognize_image_remote_integration_test.dart' as recognize_image_remote;
import 'recognize_nutrition_facts_remote_integration_test.dart'
    as recognize_nutrition_facts_remote;
import 'recognize_speech_remote_integration_test.dart'
    as recognize_speech_remote;
import 'report_food_item_integration_test.dart' as report_food_item;
import 'search_for_food_integration_test.dart' as search_for_food;
import 'search_for_food_semantic_integration_test.dart'
    as search_for_food_semantic;
import 'set_account_listener_integration_test.dart' as set_account_listener;
import 'set_passio_status_listener_integration_test.dart'
    as set_passio_status_listener;
import 'shut_down_passio_sdk_integration_test.dart' as shut_down_passio_sdk;
import 'submit_user_created_food_integration_test.dart'
    as submit_user_created_food;
import 'transform_cg_rect_form_integration_test.dart' as transform_cg_rect_form;
import 'update_language_integration_test.dart' as update_language;

Future<void> main() async {
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  advisor_fetch_ingredients.runTests();
  advisor_init_conversation.runTests();
  advisor_send_image.runTests();
  advisor_send_message.runTests();
  configure_sdk.runTests();
  fetch_food_item_for_data_info.runTests();
  fetch_food_item_for_passio_id.runTests();
  fetch_food_item_for_product_code.runTests();
  fetch_food_item_for_ref_code.runTests();
  fetch_food_item_legacy.runTests();
  fetch_hidden_ingredients.runTests();
  fetch_icon_for.runTests();
  fetch_inflammatory_effect_data.runTests();
  fetch_meal_plan_for_day.runTests();
  fetch_meal_plans.runTests();
  fetch_possible_ingredients.runTests();
  fetch_suggestions.runTests();
  fetch_tags_for.runTests();
  fetch_visual_alternatives.runTests();
  icon_url_for.runTests();
  lookup_icons_for.runTests();
  predict_next_ingredients.runTests();
  recognize_image_remote.runTests();
  recognize_nutrition_facts_remote.runTests();
  recognize_speech_remote.runTests();
  report_food_item.runTests();
  search_for_food.runTests();
  search_for_food_semantic.runTests();
  set_account_listener.runTests();
  set_passio_status_listener.runTests();
  shut_down_passio_sdk.runTests();
  submit_user_created_food.runTests();
  transform_cg_rect_form.runTests();
  update_language.runTests();

  tearDownAll(() async {
    // Clean up any resources or configurations if needed.
    await NutritionAI.instance.shutDownPassioSDK();
  });
}

/*
  */
