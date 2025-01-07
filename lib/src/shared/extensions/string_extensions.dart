extension StringExtensions on String {
  /// Retorna a palavra no singular ou plural com base no valor fornecido.
  ///
  /// [count] é o número que determina se deve ser singular ou plural.
  String pluralize(int count) {
    if (count == 1) {
      return this;
    }

    return '${this}s';
  }

  /// Retorna nulo se a string for vazia.
  String? get nullIfEmpty => trim().isEmpty ? null : this;
}
