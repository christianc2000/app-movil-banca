import 'package:flutter/material.dart';
import 'package:appmovilbanca/api_service.dart';

class MovimientoScreen extends StatefulWidget {
  const MovimientoScreen({Key? key}) : super(key: key);

  @override
  _MovimientoScreenState createState() => _MovimientoScreenState();
}

class _MovimientoScreenState extends State<MovimientoScreen> {
  List<dynamic> cuentas = [];
  dynamic selectedOption;
  List<dynamic> movimientos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiService = ApiService();
    final response = await apiService.getCuentas();

    if (response != null) {
      setState(() {
        cuentas = response['cuentas'];
      });
    }
  }

  Future<void> obtenerMovimientos(nroCuenta) async {
    final apiService = ApiService();
    final response = await apiService.obtenerMovimientos(nroCuenta);

    if (response != null) {
      setState(() {
        movimientos = response['movimientos'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                icon: const Icon(Icons.arrow_drop_down), // Icono del botón desplegable
                isExpanded: true, // Expandir el ancho del botón desplegable
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedOption != null) {
                  final nroCuenta = selectedOption['nro'];
                  obtenerMovimientos(nroCuenta);
                }
              },
              
              child: const Text('Obtener Movimientos'),
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
            Expanded(
              child: ListView.builder(
                itemCount: movimientos.length,
                itemBuilder: (BuildContext context, int index) {
                  final movimiento = movimientos[index];
                  final monto = movimiento['monto'];
                  final tipo = movimiento['tipo'];
                  final cuentaDestino = movimiento['nrocuentadestino'];
                  final fecha = movimiento['created_at'];

                  return Card(
                    child: ListTile(
                      title: Text('Monto: $monto'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo: $tipo'),
                          Text('Cuenta de Destino: $cuentaDestino'),
                          Text('Fecha: $fecha'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
