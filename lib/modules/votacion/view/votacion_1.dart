import 'package:demo_filestack/core/api/api_service.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/modules/votacion/widgets/datos_mesa.dart';
import 'package:demo_filestack/modules/votacion/controller/votosPresidencial_controller.dart';

class Votacion1View extends StatefulWidget {
  final VoidCallback onNext;
  final MesaModel mesa;

  const Votacion1View({super.key, required this.onNext, required this.mesa,});

  @override
  State<Votacion1View> createState() => _Votacion1ViewState();
}

class _Votacion1ViewState extends State<Votacion1View> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isSubmitting = false;
  final Map<String, String?> _errores = {}; // Aquí guardamos errores por campo
  final int maxVotos = 240;

  @override
  void initState() {
    super.initState();

    final campos = [
      'AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC',
      'VOTOS VALIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'
    ];

    for (var label in campos) {
      _controllers[label] = TextEditingController();
      _errores[label] = null;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _validarCampos() {
    bool esValido = true;
    final partidoLabels = ['AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC'];

    int sumaVotosPartidos = 0;

    setState(() {
      // Validar cada campo
      for (var label in _controllers.keys) {
        String valor = _controllers[label]!.text.trim();

        if (valor.isEmpty) {
          _errores[label] = 'empty'; // guardamos flag (no mostramos texto)
          esValido = false;
          continue;
        }

        // Validar número entero
        final intValor = int.tryParse(valor);
        if (intValor == null || intValor < 0) {
          _errores[label] = 'invalid';
          esValido = false;
          continue;
        }

        // No error, si esta bien limpiar error
        _errores[label] = null;

        // Solo sumar votos de partidos (no votos blancos, nulos, válidos)
        if (partidoLabels.contains(label)) {
          sumaVotosPartidos += intValor;
        }
      }
    });

    // Validar suma max 240
    if (sumaVotosPartidos > maxVotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ La suma máxima de votos es $maxVotos, lleva $sumaVotosPartidos')),
      );
      esValido = false;
    }

    final votosValidos = int.tryParse(_controllers['VOTOS VALIDOS']?.text ?? '0') ?? 0;
    final votosBlancos = int.tryParse(_controllers['VOTOS BLANCOS']?.text ?? '0') ?? 0;
    final votosNulos = int.tryParse(_controllers['VOTOS NULOS']?.text ?? '0') ?? 0;

    //validar suma e votos
    final sumaTotalVotos = votosValidos + votosBlancos + votosNulos;
    if (sumaTotalVotos > maxVotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ La suma de VOTOS VALIDOS, BLANCOS y NULOS no debe superar $maxVotos.')),
      );
      esValido = false;
    }

    return esValido;
  }

  Future<void> _registrarVotos() async {
    // Validación mínima: evitar doble envío
    if (_isSubmitting) return;
    if (!_validarCampos()) {
      return;
    }
    setState(() => _isSubmitting = true);

    final votos = <String, int>{};

    // Recolectar votos
    final partidoLabels = ['AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP',
      'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC'];

    for (var label in partidoLabels) {
      final text = _controllers[label]?.text.trim() ?? '';//
      final valor = int.tryParse(text.isEmpty ? '0' : text) ?? 0;
      votos[label] = valor;
    }

    final votosValidos = int.tryParse(_controllers['VOTOS VALIDOS']?.text ?? '0') ?? 0;
    final votosBlancos = int.tryParse(_controllers['VOTOS BLANCOS']?.text ?? '0') ?? 0;
    final votosNulos = int.tryParse(_controllers['VOTOS NULOS']?.text ?? '0') ?? 0;

    final controller = VotacionController(ApiService(Dio()));

    try {
      await controller.enviarVotacionPresidencial(
        mesaId: widget.mesa.id,
        votos: votos,
        votosValidos: votosValidos,
        votosBlancos: votosBlancos,
        votosNulos: votosNulos,
      );
       // Si controller no devuelve nada, asumimos éxito. En tu controller actual lo imprime.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Votos registrados correctamente')),
      );

      widget.onNext(); // Avanza
    } catch (e) {
      String message = '❌ Error al enviar votación';
      if (e is DioException) {
        try {
          final data = e.response?.data;
          if (data != null) {
            if (data is Map && data['message'] != null) {
              message = '❌ ${data['message']}';
            } else if (data is String) {
              message = '❌ $data';
            }
          }
        } catch (_) {}
      } else {
        message = '❌ $e';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                HeaderDatosMesa(
                  titulo: 'Datos de Boleta Presidencial',
                  mesa: widget.mesa,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for ( var label in ['AP', 'LYP', 'ADN', 'APB', 'SUMATE', 'NGP', 'LIBRE', 'FP', 'MAS_IPSP', 'MORENA', 'UNIDAD', 'PDC'])
                        _FormInput(label: label, controller: _controllers[label]!, hasError: _errores[label] != null,),
                    ],
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
                    children: [
                      for (var label in ['VOTOS VALIDOS', 'VOTOS BLANCOS', 'VOTOS NULOS'])
                        _FormInput(label: label, controller: _controllers[label]!, hasError: _errores[label] != null,),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _RegistrarButton(onPressed: _registrarVotos, isLoading: _isSubmitting),
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
              controller: controller, // <= aquí era el missing
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
  const _RegistrarButton({required this.onPressed,  this.isLoading = false});

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
          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
