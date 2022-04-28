// ignore_for_file: avoid_print

import 'package:uuid/uuid.dart';

void main() {
  print("uuid\n");
  const uuid = Uuid();
  print("v1: ${uuid.v1()}");
  print("v4: ${uuid.v4()}");
  print("v5: ${uuid.v5(null, null)}");
  print("\n");
  print("v5(NAMESPACE_DNS): ${uuid.v5(Uuid.NAMESPACE_DNS, null)}");
  //4ebd0208-8328-5d69-8c44-ec50939c0967
  //d2d6b79b-c6fc-553b-b21a-6baa0621a91c
  print("v5(NAMESPACE_DNS,dart): ${uuid.v5(Uuid.NAMESPACE_DNS, "dart")}");
}
