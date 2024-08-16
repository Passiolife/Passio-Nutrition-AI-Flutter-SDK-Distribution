/// This class holds information about the API name, the budget cap,
/// the tokens used in a certain period, and the total usage for that period.
class PassioTokenBudget {
  /// The name of the API.
  final String apiName;

  /// The maximum budget cap for tokens.
  final int budgetCap;

  /// The amount of tokens used in the current period.
  final int periodUsage;

  /// The total number of tokens used so far.
  final int tokensUsed;

  /// Creates a new instance of [PassioTokenBudget] with the provided values.
  const PassioTokenBudget({
    required this.apiName,
    required this.budgetCap,
    required this.periodUsage,
    required this.tokensUsed,
  });

  /// Creates a [PassioTokenBudget] instance from a JSON map.
  ///
  /// [json] is expected to be a map with string keys and dynamic values.
  factory PassioTokenBudget.fromJson(Map<String, dynamic> json) =>
      PassioTokenBudget(
        apiName: json['apiName'],
        budgetCap: json['budgetCap'],
        periodUsage: json['periodUsage'],
        tokensUsed: json['tokensUsed'],
      );

  /// Converts this [PassioTokenBudget] instance to a JSON map.
  ///
  /// The resulting map can be used to serialize the instance to JSON.
  Map<String, dynamic> toJson() => {
        "apiName": apiName,
        "budgetCap": budgetCap,
        "periodUsage": periodUsage,
        "tokensUsed": tokensUsed,
      };

  @override
  bool operator ==(Object other) {
    // Checks if 'other' is a PassioTokenBudget instance
    if (other is! PassioTokenBudget) return false;

    // Checks if 'this' and 'other' refer to the same instance
    if (identical(this, other)) return true;

    // Compares all properties for equality
    return apiName == other.apiName &&
        budgetCap == other.budgetCap &&
        periodUsage == other.periodUsage &&
        tokensUsed == other.tokensUsed;
  }

  // Computes a hash code based on the properties
  @override
  int get hashCode => Object.hash(apiName, budgetCap, periodUsage, tokensUsed);

  // Provides a string representation of the instance
  @override
  String toString() {
    return 'PassioTokenBudget{apiName: $apiName, budgetCap: $budgetCap, periodUsage: $periodUsage, tokensUsed: $tokensUsed}';
  }

  /// Calculates the percentage of the budget used so far.
  ///
  /// Returns a double representing the ratio of periodUsage to budgetCap.
  double usedPercent() {
    return periodUsage / budgetCap;
  }
}
