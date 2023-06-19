import 'package:appmovilbanca/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({Key? key}) : super(key: key);

  @override
  _PagoScreenState createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  List<dynamic> cuentas = [];
  dynamic selectedOption;
  TextEditingController montoController = TextEditingController();
  TextEditingController cuentaDestinoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiService = ApiService();
    final response = await apiService.getCuentas();

    if (response != null) {
      if (mounted) {
        setState(() {
          cuentas = response['cuentas'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Seleccione una Cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButton<dynamic>(
                value: selectedOption,
                hint: const Text('Selecciona una opción'),
                items: cuentas.map<DropdownMenuItem<dynamic>>(
                  (dynamic cuenta) {
                    final nro = cuenta['nro'];
                    final bancoId = cuenta['banco_id'];
                    final optionText = '$nro - $bancoId';

                    return DropdownMenuItem<dynamic>(
                      value: cuenta,
                      child: Text(optionText),
                    );
                  },
                ).toList(),
                onChanged: (dynamic value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
                underline: Container(), // Remover la línea inferior
                icon: const Icon(
                    Icons.arrow_drop_down), // Icono del botón desplegable
                isExpanded: true, // Expandir el ancho del botón desplegable
              ),
            ),
            if (selectedOption != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saldo: ${selectedOption['saldo']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: montoController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                      r'^\d+\.?\d{0,2}$'), // Expresión regular para números con hasta 2 decimales
                ),
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cuentaDestinoController,
              decoration: const InputDecoration(
                labelText: 'Cuenta Destino',
                border:
                    OutlineInputBorder(), // Agregar un borde al campo de texto
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validar que todos los campos estén llenos
                if (selectedOption != null &&
                    montoController.text.isNotEmpty &&
                    cuentaDestinoController.text.isNotEmpty) {
                  // Realizar la acción de pago con los datos ingresados
                  final monto = montoController.text;
                  final cuentaDestino = cuentaDestinoController.text;
                  // Realizar la acción de pago utilizando los datos ingresados
                  final apiService = ApiService();
                  apiService
                      .postPagar(selectedOption['nro'], monto, cuentaDestino)
                      .then((response) {
                    // Manejar la respuesta del método posPagar
                    if (response != null) {
                      // Realizar las acciones necesarias con la respuesta
                      // por ejemplo, mostrar un mensaje de éxito, actualizar la interfaz, etc.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pago Realizado'),
                          content: const Text(
                              'El pago se ha realizado exitosamente.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Cerrar el diálogo
                                Navigator.pop(
                                    context); // Volver a la pantalla anterior
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Manejar el caso de error en la solicitud posPagar
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Error al realizar el pago.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  });
                } else {
                  // Mostrar un mensaje de error indicando que todos los campos deben estar llenos
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content:
                          const Text('Todos los campos deben estar llenos.'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Realizar Pago',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
