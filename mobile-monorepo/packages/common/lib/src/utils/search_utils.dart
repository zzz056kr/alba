typedef JsonMap = Map<String, dynamic>;

JsonMap serializeSearchParams(
  JsonMap values, {
  List<String> excludeKeys = const ['size'],
  Set<String> arrayKeys = const {},
}) {
  final params = <String, dynamic>{};

  values.forEach((key, value) {
    if (excludeKeys.contains(key)) {
      return;
    }
    if (value == null || value == '' || value == 0) {
      return;
    }

    if (arrayKeys.contains(key) && value is List) {
      if (value.isNotEmpty) {
        params[key] = value.join(',');
      }
      return;
    }

    if (key == 'page' && value == 1) {
      return;
    }

    params[key] = value.toString();
  });

  return params;
}

JsonMap deserializeSearchParams(
  Map<String, String> params,
  JsonMap defaultValues, {
  Set<String> arrayKeys = const {},
}) {
  final result = Map<String, dynamic>.from(defaultValues);

  for (final key in defaultValues.keys) {
    final param = params[key];
    if (param == null || param.isEmpty) {
      continue;
    }

    if (arrayKeys.contains(key)) {
      result[key] = param.split(',').where((value) => value.isNotEmpty).toList();
      continue;
    }

    final defaultValue = defaultValues[key];
    if (defaultValue is int) {
      final parsed = int.tryParse(param);
      result[key] = parsed != null && parsed >= 0 ? parsed : defaultValue;
      continue;
    }

    result[key] = param;
  }

  return result;
}
