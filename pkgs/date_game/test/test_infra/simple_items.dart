import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

Matcher checkGolden(String fileName) {
  return matchesGoldenFile(p.join('test_infra', 'goldens', fileName));
}
