import '../models/dhikr.dart';

final List<Dhikr> generalAdhkar = [
  Dhikr(
    id: 'tasbeeh',
    title: 'سبحان الله',
    text: 'سُبْحَانَ اللَّهِ',
    targetCount: 33,
  ),
  Dhikr(
    id: 'tahmeed',
    title: 'الحمد لله',
    text: 'الْحَمْدُ لِلَّهِ',
    targetCount: 33,
  ),
  Dhikr(
    id: 'takbeer',
    title: 'الله أكبر',
    text: 'اللَّهُ أَكْبَرُ',
    targetCount: 34,
  ),
];

final List<Dhikr> morningAdhkar = [
  Dhikr(
    id: 'morning_1',
    title: 'أذكار الصباح',
    text:
        'اللّهـمَّ أَنْتَ رَبِّـي لا إلهَ إلاّ أَنْتَ، خَلَقْتَنـي...',
    targetCount: 1,
  ),
];

final List<Dhikr> eveningAdhkar = [
  Dhikr(
    id: 'evening_1',
    title: 'أذكار المساء',
    text:
        'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ...',
    targetCount: 1,
  ),
];