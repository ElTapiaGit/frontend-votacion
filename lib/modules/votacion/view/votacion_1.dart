import 'package:flutter/material.dart';
import 'package:demo_filestack/core/constants/app_colors.dart';

class Votacion1View extends StatefulWidget {
  const Votacion1View({super.key});

  @override
  State<Votacion1View> createState() => _Votacion1ViewState();
}

class _Votacion1ViewState extends State<Votacion1View> {
  String? selectedDepartamento;
  String? selectedProvincia;
  String? selectedMunicipio;
  String? selectedDistrito;
  String? selectedZona;
  String? selectedCircunscripcion;
  String? selectedRecinto;

  final List<String> departamentos = List.generate(9, (i) => 'Dep ${i + 1}');
  final List<String> provincias = List.generate(5, (i) => 'Provincia ${i + 1}');
  final List<String> municipios = List.generate(3, (i) => 'Municipio ${i + 1}');
  final List<String> distritos = List.generate(3, (i) => 'Distrito ${i + 1}');
  final List<String> zonas = List.generate(3, (i) => 'Zona ${i + 1}');
  final List<String> circunscripciones = List.generate(3, (i) => 'Circunscripción ${i + 1}');
  final List<String> recintos = List.generate(3, (i) => 'Recinto ${i + 1}');

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: const TextStyle(
            color: AppColors.white, 
            fontSize: 16, 
            fontWeight: FontWeight.w500,
          )
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text('Seleccione $label'),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.8),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          dropdownColor: Colors.white,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdown('Departamento', selectedDepartamento, departamentos, (val) {
                  setState(() {
                    selectedDepartamento = val;
                    selectedProvincia = null;
                  });
                }),
                if (selectedDepartamento != null)
                  _buildDropdown('Provincia', selectedProvincia, provincias, (val) {
                    setState(() {
                      selectedProvincia = val;
                      selectedMunicipio = null;
                    });
                  }),
                if (selectedProvincia != null)
                  _buildDropdown('Municipio', selectedMunicipio, municipios, (val) {
                    setState(() {
                      selectedMunicipio = val;
                      selectedDistrito = null;
                    });
                  }),
                if (selectedMunicipio != null)
                  _buildDropdown('Distrito', selectedDistrito, distritos, (val) {
                    setState(() {
                      selectedDistrito = val;
                      selectedZona = null;
                    });
                  }),
                if (selectedDistrito != null)
                  _buildDropdown('Zona', selectedZona, zonas, (val) {
                    setState(() {
                      selectedZona = val;
                      selectedCircunscripcion = null;
                    });
                  }),
                if (selectedZona != null)
                  _buildDropdown('Circunscripción', selectedCircunscripcion, circunscripciones, (val) {
                    setState(() {
                      selectedCircunscripcion = val;
                      selectedRecinto = null;
                    });
                  }),
                if (selectedCircunscripcion != null)
                  _buildDropdown('Recinto', selectedRecinto, recintos, (val) {
                    setState(() {
                      selectedRecinto = val;
                    });
                  }),
              ],
            ),
          ),
        );
      }
    );
  }
}




