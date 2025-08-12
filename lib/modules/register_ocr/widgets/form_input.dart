import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const FormInput({required this.label, required this.controller, super.key,});

  @override
  State<FormInput> createState() => FormInputState();
}

class FormInputState extends State<FormInput> {
  bool _mostrarError = false;

  // Validación simple: número entero entre 0 y 240
  bool _esNumeroValido(String? valor) {
    if (valor == null || valor.trim().isEmpty) return false;
    final numero = int.tryParse(valor);
    return numero != null && numero >= 0 && numero <= 240;
  }

  /// Método llamado para forzar validación desde fuera (controller)
  void validarExterno() {
    setState(() {
      _mostrarError = !_esNumeroValido(widget.controller.text);
    });
  }

  bool get esValido => _esNumeroValido(widget.controller.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${widget.label}:',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white12,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _mostrarError ? Colors.red : Colors.transparent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _mostrarError ? Colors.red : Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
