import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class Votacion2View extends StatefulWidget {
  final VoidCallback onNext;

  const Votacion2View({super.key, required this.onNext});

  @override
  State<Votacion2View> createState() => _Votacion2ViewState();
}

class _Votacion2ViewState extends State<Votacion2View> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.primary,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Datos de Boleta Uninominales',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _InfoText(label: 'Departamento', value: 'Cochabamba'),
                      _InfoText(label: 'Provincia', value: 'Cercado'),
                      _InfoText(label: 'Municipio', value: 'Cochabamba'),
                      _InfoText(label: 'Localidad', value: 'Cochabamba'),
                      _InfoText(label: 'Recinto', value: 'Colegio Marista'),
                      _InfoText(label: 'Nro. Mesa', value: '9'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
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
                const SizedBox(height: 24),
                const Divider(color: Colors.white70),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: const [
                    _FormInput(label: 'VOTOS VALIDOS'),
                    _FormInput(label: 'VOTOS BLANCOS'),
                    _FormInput(label: 'VOTOS NULOS'),
                  ],
                ),
                const SizedBox(height: 32),
                _RegistrarButton(onNext: widget.onNext),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoText extends StatelessWidget {
  final String label;
  final String value;

  const _InfoText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
