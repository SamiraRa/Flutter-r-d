import 'package:barcode_scanner/models/riverpod_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final riverpodIncrement = StateProvider<int>((ref) => 0);
final seatIncrement = StateProvider<int>((ref) => 0);
final riverpodModelIncrement = ChangeNotifierProvider<RiverpodModel>((ref) => RiverpodModel(counter: 0));

final riverpodDarkMode = StateProvider<bool>((ref) => false);
final counterStateProvider = StateProvider<int>((ref) => 0);
