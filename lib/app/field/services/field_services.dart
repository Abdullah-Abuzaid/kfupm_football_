import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/field_model.dart';

class FieldServices {
  static final supabase = Supabase.instance.client;

  static Future<List<Field>> fetchFields() async {
    final result = (await supabase.from("field").select()) as List;
    if (result.isEmpty) return [];
    return result.map((e) => Field.fromMap(e)).toList();
  }

  static Future<void> addField(Field field) async {
    await supabase.from("field").insert(
          field.toMap(),
        );
  }
}
