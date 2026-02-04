import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TasbeehController extends ChangeNotifier {
  final Box box = Hive.box('tasbeehBox');

  int _count = 0;
  int _target = 33;

  int get count => _count;
  int get target => _target;

  TasbeehController() {
    _count = box.get('count', defaultValue: 0);
    _target = box.get('target', defaultValue: 33);
  }

  Future<void> increment() async {
    if (_count < _target) {
      _count++;

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 40);
      }

      await box.put('count', _count);
      final today = DateTime.now().toIso8601String().substring(0, 10);
int todayCount = box.get(today, defaultValue: 0);
todayCount++;
await box.put(today, todayCount);
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _count = 0;
    await box.put('count', _count);
    notifyListeners();
  }

  Future<void> changeTarget(int value) async {
    _target = value;
    _count = 0;
    await box.put('target', _target);
    await box.put('count', _count);
    notifyListeners();
  }
}