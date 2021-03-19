import 'package:specs/specs.dart';
import 'package:test/test.dart';

void main() {
  final candidate = '::irrelevant::';

  group('and spec:', () {
    test('true and true', () {
      final andSpec = AndSpec(HappySpec(), HappySpec());
      expect(andSpec.isSatisfiedBy(candidate), isTrue);
    });

    test('true and false', () {
      final andSpec = AndSpec(HappySpec(), SadSpec());
      expect(andSpec.isSatisfiedBy(candidate), isFalse);
    });

    test('false and false', () {
      final andSpec = AndSpec(HappySpec(), SadSpec());
      expect(andSpec.isSatisfiedBy(candidate), isFalse);
    });

    test('false and true', () {
      final andSpec = AndSpec(HappySpec(), SadSpec());
      expect(andSpec.isSatisfiedBy(candidate), isFalse);
    });
  });

  group('or spec:', () {
    test('true or false', () {
      expect(OrSpec(HappySpec(), SadSpec()).isSatisfiedBy(candidate), isTrue);
    });

    test('true or true', () {
      expect(OrSpec(HappySpec(), HappySpec()).isSatisfiedBy(candidate), isTrue);
    });

    test('false or false', () {
      expect(OrSpec(SadSpec(), SadSpec()).isSatisfiedBy(candidate), isFalse);
    });

    test('false or true', () {
      expect(OrSpec(SadSpec(), HappySpec()).isSatisfiedBy(candidate), isTrue);
    });
  });

  group('not spec:', () {
    test('not true', () {
      expect(NotSpec(HappySpec()).isSatisfiedBy(candidate), isFalse);
    });

    test('not false', () {
      expect(NotSpec(SadSpec()).isSatisfiedBy(candidate), isTrue);
    });
  });

  group('xor spec:', () {
    test('true xor true', () {
      expect(
          XorSpec(HappySpec(), HappySpec()).isSatisfiedBy(candidate), isFalse);
    });

    test('false xor false', () {
      expect(XorSpec(SadSpec(), SadSpec()).isSatisfiedBy(candidate), isFalse);
    });

    test('true xor false', () {
      expect(XorSpec(HappySpec(), SadSpec()).isSatisfiedBy(candidate), isTrue);
    });

    test('false xor true', () {
      expect(XorSpec(SadSpec(), HappySpec()).isSatisfiedBy(candidate), isTrue);
    });
  });
}

class HappySpec<T> extends Spec<T> {
  @override
  bool isSatisfiedBy(T _) => true;
}

class SadSpec<T> extends Spec<T> {
  @override
  bool isSatisfiedBy(T _) => false;
}
