class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    this.flag = '🌐',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageInfo &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'LanguageInfo(code: $code, name: $name)';
}
