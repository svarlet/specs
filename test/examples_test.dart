import 'package:specs/specs.dart';
import 'package:test/test.dart';

void main() {
  test('allowed to drive a car', () {
    final Spec<Human> minAge = AgeSpecs.olderThan(16);
    final Spec<Human> licenced = LicenceSpecs.ownsDrivingLicence();
    final Spec<Human> drunk = HealthSpecs.isDrunk();
    final allowedToDrive = minAge & licenced & ~drunk;

    final kid = Human(age: 11, hasDrivingLicence: false);
    expect(allowedToDrive.isSatisfiedBy(kid), isFalse);

    final unlicencedAdult = Human(age: 28, hasDrivingLicence: false);
    expect(allowedToDrive.isSatisfiedBy(unlicencedAdult), isFalse);

    final licencedAdult = Human(age: 45, hasDrivingLicence: true);
    expect(allowedToDrive.isSatisfiedBy(licencedAdult), isTrue);

    final drunkDriver = Human(age: 45, hasDrivingLicence: true, drunk: true);
    expect(allowedToDrive.isSatisfiedBy(drunkDriver), isFalse);
  });
}

abstract class Ageing {
  int get age;
}

abstract class Driver {
  bool get hasDrivingLicence;
}

abstract class Health {
  bool get drunk;
}

class Human implements Ageing, Driver, Health {
  final int age;
  final bool hasDrivingLicence;
  final bool drunk;

  Human({
    required this.age,
    this.hasDrivingLicence = false,
    this.drunk = false,
  });
}

class PredicateSpec<T> extends Spec<T> {
  final bool Function(T candidate) _predicate;

  PredicateSpec(this._predicate);

  @override
  bool isSatisfiedBy(T candidate) => _predicate(candidate);
}

class AgeSpecs {
  static Spec<T> olderThan<T extends Ageing>(int age) =>
      PredicateSpec((T candidate) => candidate.age >= age);
}

class LicenceSpecs {
  static Spec<T> ownsDrivingLicence<T extends Driver>() =>
      PredicateSpec((T candidate) => candidate.hasDrivingLicence);
}

class HealthSpecs {
  static Spec<T> isDrunk<T extends Health>() =>
      PredicateSpec((T candidate) => candidate.drunk);
}
