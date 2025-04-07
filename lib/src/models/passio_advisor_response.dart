import 'package:flutter/foundation.dart';

import '../converter/platform_output_converter.dart';
import 'passio_advisor_food_info.dart';

/// Represents the response from the Passio Advisor.
class PassioAdvisorResponse {
  /// A list of extracted food ingredients.
  final List<PassioAdvisorFoodInfo>? extractedIngredients;

  /// The markup content of the response.
  final String markupContent;

  /// The unique identifier for the message.
  final String messageId;

  /// The raw content of the response.
  final String rawContent;

  /// The unique identifier for the thread.
  final String threadId;

  /// A list of tools used or referenced in the response.
  final List<String>? tools;

  /// Constructs a [PassioAdvisorResponse] instance.
  const PassioAdvisorResponse({
    this.extractedIngredients,
    required this.markupContent,
    required this.messageId,
    required this.rawContent,
    required this.threadId,
    this.tools,
  });

  /// Creates a [PassioAdvisorResponse] instance from a JSON object.
  factory PassioAdvisorResponse.fromJson(Map<String, dynamic> json) =>
      PassioAdvisorResponse(
        extractedIngredients: mapListOfObjectsOptional(
            json['extractedIngredients'], PassioAdvisorFoodInfo.fromJson),
        markupContent: json['markupContent'],
        messageId: json['messageId'],
        rawContent: json['rawContent'],
        threadId: json['threadId'],
        tools: mapDynamicListToListOfString(json['tools']),
      );

  /// Converts the [PassioAdvisorResponse] instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'extractedIngredients':
            extractedIngredients?.map((e) => e.toJson()).toList(),
        'markupContent': markupContent,
        'messageId': messageId,
        'rawContent': rawContent,
        'threadId': threadId,
        'tools': tools,
      };

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (other is! PassioAdvisorResponse) return false;
    if (identical(this, other)) return true;
    return listEquals(extractedIngredients, other.extractedIngredients) &&
        markupContent == other.markupContent &&
        messageId == other.messageId &&
        rawContent == other.rawContent &&
        threadId == other.threadId &&
        listEquals(tools, other.tools);
  }

  /// Overrides the hashCode method.
  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(extractedIngredients ?? []),
        markupContent,
        messageId,
        rawContent,
        threadId,
        Object.hashAllUnordered(tools ?? []),
      );
}
