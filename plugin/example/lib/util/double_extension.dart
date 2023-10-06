extension Round on double {
  int get roundUpAbs => this.isNegative ? this.floor() : this.ceil();
}
