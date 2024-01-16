extension Round on double {
  int get roundUpAbs => isNegative ? floor() : ceil();
}
