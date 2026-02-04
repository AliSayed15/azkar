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
  Dhikr(
    id: 'subhan_behamd',
    title: 'سبحان الله وبحمده',
    text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    targetCount: 100,
  ),
  Dhikr(
    id: 'subhan_azeem',
    title: 'سبحان الله العظيم',
    text: 'سُبْحَانَ اللَّهِ الْعَظِيمِ ',
    targetCount: 100,
  ),
  Dhikr(
    id: 'istighfar',
    title: 'استغفر الله ',
    text: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
    targetCount: 100,
  ),
  
  
  Dhikr(
    id: 'salat_prophet',
    title: 'الصلاة على النبي',
    text: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
    targetCount: 100,
  ),
  Dhikr(
    id: 'salat_prophet_full',
    title: 'الصلاة الإبراهيمية',
    text: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ، اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
    targetCount: 10,
  ),
  Dhikr(
    id: 'la_ilaha',
    title: 'لا إله إلا الله',
    text: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    targetCount: 100,
  ),
  
  Dhikr(
    id: 'la_hawla',
    title: 'لا حول ولا قوة',
    text: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    targetCount: 100,
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