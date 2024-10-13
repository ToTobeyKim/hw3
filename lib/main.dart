import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MemoryCardApp());

class MemoryCardApp extends StatelessWidget {
  const MemoryCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Memory Game')),
          body: const GameScreen(),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: cardProvider.cards.length,
          itemBuilder: (context, index) {
            final card = cardProvider.cards[index];
            return GestureDetector(
              onTap: () {
                cardProvider.flipCard(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: card.flipped ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    card.flipped ? card.frontDesign : '',
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Card {
  final String frontDesign;
  bool flipped;

  Card(this.frontDesign) : flipped = false;
}

class CardProvider with ChangeNotifier {
  List<Card> _cards = [];
  int? _lastFlippedIndex;

  CardProvider() {
    _initializeCards();
  }

  List<Card> get cards => _cards;

  void _initializeCards() {
    List<String> designs = [
      '1', '4', '1', '8', '3', '2', '2', '6', '7', '5', '5', '4', '6', '8', '7', '3'
    ];
    _cards = designs.map((design) => Card(design)).toList();
  }

  void flipCard(int index) {
    if (_cards[index].flipped) return;

    _cards[index].flipped = true;
    notifyListeners();

    if (_lastFlippedIndex == null) {
      _lastFlippedIndex = index;
    } else {
      final lastFlippedCard = _cards[_lastFlippedIndex!];
      final currentCard = _cards[index];

      if (lastFlippedCard.frontDesign != currentCard.frontDesign) {
        Future.delayed(const Duration(seconds: 1), () {
          lastFlippedCard.flipped = false;
          currentCard.flipped = false;
          _lastFlippedIndex = null;
          notifyListeners();
        });
      } else {
        _lastFlippedIndex = null;
      }
    }
  }
}
