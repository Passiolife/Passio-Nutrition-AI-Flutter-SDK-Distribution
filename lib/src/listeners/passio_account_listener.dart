import 'package:nutrition_ai/src/models/passio_token_budget.dart';

/// An abstract interface class for listening to updates on token budgets.
///
/// Implement this interface to handle events related to changes in token budgets.
abstract interface class PassioAccountListener {
  /// Called when the token budget is updated.
  ///
  /// [tokenBudget] provides the updated token budget details.
  /// Implement this method to react to changes in the token budget.
  void onTokenBudgetUpdate(PassioTokenBudget tokenBudget);
}
