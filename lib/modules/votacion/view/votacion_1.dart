import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/modules/votacion/widgets/datos_mesa.dart';

class Votacion1View extends StatefulWidget {
  final VoidCallback onNext;
  final MesaModel mesa;

  const Votacion1View({super.key, required this.onNext, required this.mesa,});

  @override
  State<Votacion1View> createState() => _Votacion1ViewState();
}

class _Votacion1ViewState extends State<Votacion1View> {
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
                    children: const [
                      _FormInput(label: 'AP'),
                      _FormInput(label: 'LYP'),
                      _FormInput(label: 'ADN'),
                      _FormInput(label: 'APB'),
                      _FormInput(label: 'SUMATE'),
                      _FormInput(label: 'NGP'),
                      _FormInput(label: 'LIBRE'),
                      _FormInput(label: 'FP'),
                      _FormInput(label: 'MAS-IPSP'),
                      _FormInput(label: 'MORENA'),
                      _FormInput(label: 'UNIDAD'),
                      _FormInput(label: 'PDC'),
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
                    children: const [
                      _FormInput(label: 'VOTOS VALIDOS'),
                      _FormInput(label: 'VOTOS BLANCOS'),
                      _FormInput(label: 'VOTOS NULOS'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _RegistrarButton(onNext: widget.onNext),
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

  const _FormInput({required this.label});

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
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
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
  final VoidCallback onNext;
  const _RegistrarButton({required this.onNext});

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
        onPressed: onNext,  //avanza al siguiente view
        child: Row(
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
