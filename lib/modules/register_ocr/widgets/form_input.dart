// lib/modules/ocr/widgets/form_input.dart
import 'package:flutter/material.dart';
import 'package:demo_filestack/modules/register_ocr/controller/form_validator.dart';

class FormInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const FormInput({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  State<FormInput> createState() => FormInputState();
}

class FormInputState extends State<FormInput> {
  bool _mostrarError = false;

  /// Metodo llamado para forzar validacion
  void validarExterno() {
    setState(() {
      _mostrarError = !FormValidator.esNumeroValido(widget.controller.text);
    });
  }

  bool get esValido => FormValidator.esNumeroValido(widget.controller.text);

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
