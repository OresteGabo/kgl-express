String obfuscateName(String name) {
  if (name.isEmpty) return "";

  List<String> parts = name.split(' ');
  List<String> obfuscatedParts = parts.map((part) {
    if (part.length <= 2) return part; // Don't hide very short names
    // Keep first and last letter, star the middle
    return "${part[0]}${'*' * (part.length - 2)}${part[part.length - 1]}";
  }).toList();

  return obfuscatedParts.join(' ');
}