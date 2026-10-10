import 'dart:io';

void main() {
  final dir = Directory('c:/Users/ADMIN/Desktop/attendanceapp/lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final mappings = {
    'AppColors.primaryVioletViolet': 'AppColors.primaryViolet',
    'AppColors.surfaceCardCard': 'AppColors.surfaceCard',
    'AppColors.maidenMist': 'AppColors.neutralGrey',
    'AppColors.polishWhite': 'AppColors.background',
    'AppColors.sunsetInItaly': 'AppColors.primaryViolet',
    'AppColors.accentRedDarkDark': 'AppColors.accentRedDark',
    'Colors.black.withOpacity(0.06)': 'const Color(0x0F000000)',
    'AppColors.neutralGrey.withOpacity(0.2)': 'const Color(0x338385A1)',
  };

  for (final file in files) {
    if (file.path.endsWith('colors.dart')) continue;
    String content = file.readAsStringSync();
    bool modified = false;
    mappings.forEach((oldVal, newVal) {
      if (content.contains(oldVal)) {
        content = content.replaceAll(oldVal, newVal);
        modified = true;
      }
    });
    if (modified) {
      file.writeAsStringSync(content);
      print('Fixed \${file.path}');
    }
  }
}
