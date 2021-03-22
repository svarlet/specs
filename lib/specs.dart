library specs;

abstract class Spec<T> {
  bool isSatisfiedBy(T candidate);
  Spec<T> and(Spec<T> s) => AndSpec(this, s);
  Spec<T> or(Spec<T> s) => OrSpec(this, s);
  Spec<T> not() => NotSpec(this);
  Spec<T> xor(Spec<T> s) => XorSpec(this, s);
  Spec<T> operator &(Spec<T> s) => and(s);
  Spec<T> operator |(Spec<T> s) => or(s);
  Spec<T> operator ~() => not();
  Spec<T> operator ^(Spec<T> s) => xor(s);
}

class AndSpec<T> extends Spec<T> {
  final Spec<T> _s1;
  final Spec<T> _s2;

  AndSpec(this._s1, this._s2);

  @override
  bool isSatisfiedBy(T candidate) {
    return _s1.isSatisfiedBy(candidate) && _s2.isSatisfiedBy(candidate);
  }
}

class OrSpec<T> extends Spec<T> {
  final Spec<T> _s1;
  final Spec<T> _s2;

  OrSpec(this._s1, this._s2);

  @override
  bool isSatisfiedBy(T candidate) {
    return _s1.isSatisfiedBy(candidate) || _s2.isSatisfiedBy(candidate);
  }
}

class NotSpec<T> extends Spec<T> {
  final Spec<T> _s;

  NotSpec(this._s);

  @override
  bool isSatisfiedBy(T candidate) {
    return !_s.isSatisfiedBy(candidate);
  }
}

class XorSpec<T> extends Spec<T> {
  final Spec<T> _s1;
  final Spec<T> _s2;

  XorSpec(this._s1, this._s2);

  @override
  bool isSatisfiedBy(T candidate) {
    return ((_s1 & ~_s2) | (~_s1 & _s2)).isSatisfiedBy(candidate);
  }
}
