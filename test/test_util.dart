import 'package:path/path.dart' as p;

String validDatePath() =>
    p.join('pkg_firebase3_test', new DateTime.now().toUtc().toIso8601String());
