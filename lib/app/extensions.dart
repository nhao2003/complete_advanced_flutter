const EMPTY = "";
const ZERO = 0;
extension NonNullString on String? {
  String orEmpty() {
    return this == null ? EMPTY : this!;
  }
}
extension NonNullInterger on int? {
  int orZero() {
    return this == null ? ZERO : this!;
  }
}
