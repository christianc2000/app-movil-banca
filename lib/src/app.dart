import 'package:flutter/material.dart';
import 'package:appmovilbanca/api_service.dart'; // Asegúrate de importar el archivo api_service.dart correctamente
import 'package:flutter/services.dart';

class MyAppForm extends StatefulWidget {
  const MyAppForm({Key? key}) : super(key: key);

  @override
  State<MyAppForm> createState() => _MyAppFormState();
}

class _MyAppFormState extends State<MyAppForm> {
  TextEditingController ciController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login(BuildContext context) async {
    final ci = ciController.text;
    final password = passwordController.text;
    setState(() {
      isLoading = true; // Activa el indicador de carga
    });
    // Llamada a la API para el inicio de sesión
    ApiService apiService = ApiService();
    bool loginSuccess = await apiService.login(ci, password);
    setState(() {
      isLoading = false; // Desactiva el indicador de carga
    });

    if (loginSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: const Text('Las credenciales ingresadas son incorrectas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'ACCEDE A TU CUENTA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Inicia sesión en tu cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 235,
                color: Colors.grey[100],
                child: Center(
                  child: Image.asset(
                    'images/imageninicial.png',
                    width: 235,
                    height: 200,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: ciController,
                      decoration: const InputDecoration(
                        labelText: 'CI',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, // Ancho máximo
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () =>
                            _login(context), // Pasar el contexto como argumento
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF487AA1),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildButton(context, 'Cobrar', 'images/cobrar.png', () {
              // Navegar a la vista Cobrar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CobrarScreen(),
                ),
              );
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'Pagar', 'images/pagar.png', () {
              // Navegar a la vista Pagar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PagarScreen(),
                ),
              );
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'Movimiento', 'images/movimiento.png', () {
              // Navegar a la vista Movimiento
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovimientoScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String imagePath,
      VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: double.infinity,
        height: 60,
        color: const Color(0xFFB2D9F7),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CobrarScreen extends StatelessWidget {
  const CobrarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cobrar'),
      ),
      body: Center(
        child: const Text('Vista de Cobrar'),
      ),
    );
  }
}

class PagarScreen extends StatefulWidget {
  const PagarScreen({Key? key}) : super(key: key);

  @override
  _PagarScreenState createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
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
      setState(() {
        cuentas = response['cuentas'];
      });
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
          children: [
            Text(
              'Seleccione una Cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                items: cuentas.map<DropdownMenuItem<dynamic>>((dynamic cuenta) {
                  final nro = cuenta['nro'];
                  final bancoId = cuenta['banco_id'];
                  final optionText = '$nro - $bancoId';

                  return DropdownMenuItem<dynamic>(
                    value: cuenta,
                    child: Text(optionText),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
                underline: Container(), // Remover la línea inferior
                icon:
                    Icon(Icons.arrow_drop_down), // Icono del botón desplegable
                isExpanded: true, // Expandir el ancho del botón desplegable
              ),
            ),
              if (selectedOption != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saldo: ${selectedOption['saldo']}',
                  style: TextStyle(
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
                                    context); // Volver a la pantalla inicial
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
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: const Color(0xFF487AA1),
              ),
              child: const Text('Realizar Pago'),
            )
          ],
        ),
      ),
    );
  }
}

class MovimientoScreen extends StatefulWidget {
  const MovimientoScreen({Key? key}) : super(key: key);

  @override
  _MovimientoScreenState createState() => _MovimientoScreenState();
}

class _MovimientoScreenState extends State<MovimientoScreen> {
  List<dynamic> cuentas = []; // Lista de cuentas obtenidas de la API
  dynamic selectedOption;
  List<dynamic> movimientos = []; // Lista de movimientos obtenidos de la API

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
            Text(
              'Seleccione una Cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                icon:
                    Icon(Icons.arrow_drop_down), // Icono del botón desplegable
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
                  style: TextStyle(
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
