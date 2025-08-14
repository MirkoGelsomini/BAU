import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/dogCard.dart';

void main() {
  group('DogCard Widget Tests', () {
    testWidgets('should render correctly with dog data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(DogCard), findsOneWidget);
      expect(find.text('Buddy'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('should display correct gender text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Luna',
              breed: 'Husky',
              isFemale: true,
              years: 2,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DogCard));
      expect(tapped, isTrue);
    });

    testWidgets('should call onFavoriteToggle when favorite button is tapped', (tester) async {
      bool toggled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () => toggled = true,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      expect(toggled, isTrue);
    });

    testWidgets('should display favorite icon when dog is favorite', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: true,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should not display favorite icon when dog is not favorite', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display dog image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogCard(
              imageUrl: 'assets/images/dogs/chihuahua_image.png',
              name: 'Buddy',
              breed: 'Labrador',
              isFemale: false,
              years: 3,
              isFavorite: false,
              onFavoriteToggle: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });
  });
}
