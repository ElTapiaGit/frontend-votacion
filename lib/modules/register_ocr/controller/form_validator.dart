import 'package:flutter/material.dart';

class FormValidator {
  static const int maxValor = 240;

  /// Valida que el valor ingresado sea un numero entero <= 240.
  /// Devuelve true si es valido, false si no.
  static bool esNumeroValido(String? valor) {
    if (valor == null || valor.trim().isEmpty) return false;

    final numero = int.tryParse(valor);
    return numero != null && numero >= 0 && numero <= maxValor;
  }

  /// Retorna un InputDecoration con borde rojo si no es valido.
  static InputDecoration decorarInput({required bool esValido}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: esValido ? Colors.grey : Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: esValido ? Colors.blue : Colors.red,
          width: 2,
        ),
      ),
      errorText: esValido ? null : 'Numero invalido (0-240)',
    );
  }
}
