import 'package:flutter/material.dart';
import 'package:appmovilbanca/api_service.dart';
import 'package:appmovilbanca/src/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          builder: (context) => const HomeScreen(),
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
    return Theme(
      data: ThemeData(
        primaryColor: Colors.indigo, // Color primario
        accentColor: Colors.white, // Color de acento
        scaffoldBackgroundColor:
            Colors.white, // Color de fondo de los scaffolds
      
        appBarTheme: AppBarTheme(
          color: Colors.indigo, // Color de fondo de la AppBar
          elevation: 0, // Sombra de la AppBar (0 para eliminarla)
          brightness: Brightness
              .dark, // Brillo del contenido de la AppBar (puede ser light o dark)
          iconTheme: IconThemeData(
              color: Colors.white), // Color de los iconos de la AppBar
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight
                    .bold), // Estilo del texto del título de la AppBar
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo, // Color de fondo del botón elevado
            onPrimary: Colors.white, // Color del texto del botón elevado
            padding:
                const EdgeInsets.all(16.0), // Padding interno del botón elevado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), // Bordes redondeados del botón elevado
            ),
          ),
        ),
        // Otros ajustes de tema según tus necesidades
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ACCEDE A TU CUENTA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: [
                Card(
                  elevation: 2,
                  child: SizedBox(
                    width: double.infinity,
                    height: 235,
                    child: Image.asset(
                      'images/imageninicial.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      ElevatedButton.icon(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
