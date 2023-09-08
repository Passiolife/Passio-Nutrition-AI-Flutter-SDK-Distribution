extension Util on String? {
  String? toCapitalized() => (this?.length ?? 0) > 0
      ? '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}'
      : '';

  String? toTitleCase() => this
      ?.replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String? format(List<String> params) => interpolate(this, params);

  String interpolate(String? string, List<String> params) {
    String? result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result?.replaceAll('%s', params[i - 1]);
    }
    for (int i = 1; i < params.length + 1; i++) {
      result = result?.replaceAll('%$i\$', params[i - 1]);
    }
    return result ?? '';
  }
}
