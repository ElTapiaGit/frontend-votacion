import 'package:demo_filestack/core/api/api_service.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/votacion/widgets/datos_mesa.dart';
import 'package:demo_filestack/modules/votacion/controller/votosUninominal_controller.dart';

class Votacion2View extends StatefulWidget {
  final VoidCallback onNext;
  final MesaModel mesa;

  const Votacion2View({super.key, required this.onNext, required this.mesa});

  @override
  State<Votacion2View> createState() => _Votacion2ViewState();
}

class _Votacion2ViewState extends State<Votacion2View> {
  late final Map<String, TextEditingController> _controllers;
  late final VotosUninominalController _controller;
  late final Map<String, String?> _errores;
  bool _isSubmitting = false;

  final List<String> partidos = [
    'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
    'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC'
  ];
  final List<String> votosEspeciales = [
    'VOTOS VALIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
  ];

  @override
  void initState() {
    super.initState();

    _controllers = {};
    _errores = {};
    for (var label in [...partidos, ...votosEspeciales]) {
      _controllers[label] = TextEditingController();
      _errores[label] = null; // Por defecto no hay errores
    }

    _controller = VotosUninominalController(ApiService(Dio()));
  }
  
  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validarCampos() {
    const int maxVotos = 240;
    bool esValido = true;

    int sumaVotosPartidos = 0;
    int sumaVotosEspeciales = 0;

    // Validar y sumar votos por partido
    for (var label in partidos) {
      final text = _controllers[label]?.text.trim() ?? '';
      final valor = int.tryParse(text);
      if (text.isEmpty || valor == null || valor < 0) {
        esValido = false;
        _errores[label] = 'El valor para "$label" es inválido'; // Asignamos el error
      } else {
        sumaVotosPartidos += valor;
        _errores[label] = null; // Eliminamos el error si el campo es válido
      }
    }

    if (sumaVotosPartidos > maxVotos) {
      esValido = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ La suma de votos por partidos supera el máximo de $maxVotos. Total: $sumaVotosPartidos')),
      );
    }

    // Validar y sumar votos especiales
    for (var label in votosEspeciales) {
      final text = _controllers[label]?.text.trim() ?? '';
      final valor = int.tryParse(text);
      if (text.isEmpty || valor == null || valor < 0) {
        esValido = false;
        _errores[label] = 'El valor para "$label" es inválido'; // Asignamos el error
      } else {
        sumaVotosEspeciales += valor;
        _errores[label] = null; // Eliminamos el error si el campo es válido
      }
    }

    if (sumaVotosEspeciales > maxVotos) {
      esValido = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ La suma de VOTOS VALIDOS, BLANCOS y NULOS supera $maxVotos. Total: $sumaVotosEspeciales')),
      );
    }

    return esValido;
  }


  void _onSubmit() {
    if (_isSubmitting) return;
    if (!_validarCampos()) return;

    _controller.enviarVotos(
      mesaId: widget.mesa.id,
      controllers: _controllers,
      onLoading: () => setState(() => _isSubmitting = true),
      onFinish: () => setState(() => _isSubmitting = false),
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Votos registrados correctamente')),
        );
        widget.onNext();
      },
      onError: (msg) {
        print('❌ Error al enviar votación: $msg');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error al enviar votación: $msg')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.primary,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //llamamos la widgets datos_mesa
                HeaderDatosMesa(
                  titulo: 'Datos de Boleta Uninominales',
                  mesa: widget.mesa,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: partidos
                      .map((label) => _FormInput(
                            label: label,
                            controller: _controllers[label]!,
                            hasError: _errores[label] != null
                          ))
                      .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white70),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: votosEspeciales
                      .map((label) => _FormInput(
                            label: label,
                            controller: _controllers[label]!,
                            hasError: _errores[label] != null,
                          ))
                      .toList(),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _RegistrarButton(onPressed: _onSubmit, isLoading: _isSubmitting,),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
class _FormInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool hasError;

  const _FormInput({required this.label, required this.controller, this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
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
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: hasError ? Colors.redAccent : Colors.white, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError ? Colors.redAccent : Colors.transparent,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const _RegistrarButton({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,  //avanza al siguiente view
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Registrar Votos',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
