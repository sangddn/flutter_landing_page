import 'dart:convert';

final jsonEncoder = JsonEncoder.withIndent(
  '   ',
  (dynamic object) => object.toString(),
);
