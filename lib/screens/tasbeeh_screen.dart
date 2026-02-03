import 'package:flutter/material.dart';
import '../models/dhikr.dart';

class TasbeehScreen extends StatefulWidget {
  final Dhikr dhikr;
  final int initialCount;

  const TasbeehScreen({
    super.key,
    required this.dhikr,
    required this.initialCount,
  });

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = widget.initialCount;
  }

  void incrementCounter() {
    if (counter < widget.dhikr.targetCount) {
      setState(() {
        counter++;
      });
    }
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dhikr.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, counter);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.dhikr.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: Center(
                child: Text(
                  '$counter',
                  style: const TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'الهدف: ${widget.dhikr.targetCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: incrementCounter,
                child: const Text(
                  'سبّح',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            TextButton(
              onPressed: resetCounter,
              child: const Text('إعادة العد'),
            ),
          ],
        ),
      ),
    );
  }
}