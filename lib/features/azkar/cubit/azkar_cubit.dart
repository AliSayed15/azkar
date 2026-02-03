import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/zekr_model.dart';
import '../services/azkar_api.dart';
import '../services/azkar_cache.dart';

class AzkarCubit extends Cubit<List<ZekrItem>> {
  final AzkarApi api;
  
  AzkarCubit(this.api) : super([]);

  bool isLoading = false;
  String? error;

  Future<void> loadAzkar(String category) async {
    try {
      isLoading = true;
      emit([]);

      // جرب من الـ Cache أولاً
      final cachedAzkar = AzkarCache.getAzkar(category);
      
      if (cachedAzkar != null && cachedAzkar.isNotEmpty) {
        print('📦 تم تحميل $category من الـ cache');
        isLoading = false;
        error = null;
        emit(cachedAzkar);
        return;
      }

      // لو مش موجود، حمّل من الـ API
      print('🌐 تحميل $category من الإنترنت...');
      final azkar = await api.fetchAzkar(category);
      
      // احفظ في الـ Cache
      await AzkarCache.saveAzkar(category, azkar);
      
      isLoading = false;
      error = null;
      emit(azkar);
      
    } catch (e) {
      isLoading = false;
      error = 'فشل تحميل الأذكار. تأكد من اتصالك بالإنترنت.';
      print('❌ خطأ: $e');
      emit([]);
    }
  }

  void decrease(int index) {
    final updated = List<ZekrItem>.from(state);
    if (updated[index].currentCount > 0) {
      updated[index].currentCount--;
    }
    emit(updated);
  }

  Future<void> forceRefresh(String category) async {
    try {
      isLoading = true;
      emit([]);

      final azkar = await api.fetchAzkar(category);
      await AzkarCache.saveAzkar(category, azkar);
      
      isLoading = false;
      error = null;
      emit(azkar);
      
    } catch (e) {
      isLoading = false;
      error = 'فشل تحديث الأذكار';
      emit([]);
    }
  }
}