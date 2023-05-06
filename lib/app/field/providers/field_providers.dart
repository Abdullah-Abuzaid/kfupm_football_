import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/field/services/field_services.dart';
import 'package:kfupm_football/core/models/field_model.dart';

final fieldsProvider = FutureProvider<List<Field>>((ref) async {
  return await FieldServices.fetchFields();
});
