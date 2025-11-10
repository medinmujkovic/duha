import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';


final dataServiceProvider = ChangeNotifierProvider<DataService>((ref) {
  return DataService();
});