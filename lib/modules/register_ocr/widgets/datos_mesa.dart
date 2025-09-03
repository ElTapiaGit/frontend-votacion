import 'package:flutter/material.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class HeaderDatosMesa extends StatelessWidget {
  final String titulo;
  final MesaModel mesa;

  const HeaderDatosMesa({
    super.key,
    required this.titulo,
    required this.mesa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width < 360 ? 18 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _InfoText(label: 'Departamento', value: mesa.departamento?.nombre ?? '---'),
          _InfoText(label: 'Provincia', value: mesa.provincia?.nombre ?? '---'),
          _InfoText(label: 'Municipio', value: mesa.municipio?.nombre ?? '---'),
          _InfoText(label: 'Zona', value: mesa.zona?.nombre ?? '---'),
          _InfoText(label: 'Recinto', value: mesa.recinto?.nombre ?? '---'),
          _InfoText(
            label: 'Nro. Mesa',
            value: mesa.numeroMesa?.toString() ?? '---',
            highlighted: true,
          ),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _InfoText({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 320
        ? 12 // pantallas muy pequeñas
        : screenWidth < 400
            ? 14
            : 16;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // separa label y value
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: highlighted ? fontSize + 2 : fontSize,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right, // alineado a la derecha
              style: TextStyle(
                color: highlighted ? Colors.amberAccent : Colors.white,
                fontWeight: highlighted ? FontWeight.w900 : FontWeight.bold,
                fontSize: highlighted ? fontSize + 2 : fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
