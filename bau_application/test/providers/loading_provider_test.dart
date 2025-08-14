import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/loading_provider.dart';

void main() {
  test('isLoadingProvider starts as false and can be updated', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(isLoadingProvider), false);

    container.read(isLoadingProvider.notifier).state = true;
    expect(container.read(isLoadingProvider), true);

    container.read(isLoadingProvider.notifier).state = false;
    expect(container.read(isLoadingProvider), false);
  });
}
