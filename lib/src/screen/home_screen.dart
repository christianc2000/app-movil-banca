import 'package:flutter/material.dart';
import 'package:appmovilbanca/src/app.dart';
import 'package:appmovilbanca/src/screen/cobro_screen.dart';
import 'package:appmovilbanca/src/screen/movimiento_screen.dart';
import 'package:appmovilbanca/src/screen/pago_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(
        title: const Text('Inicio'),
         automaticallyImplyLeading: false,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            _buildButton(context, 'Cobrar', Icons.monetization_on, Colors.blue, () {
              // Navegar a la vista Cobrar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CobroScreen(),
                ),
              );
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'Pagar', Icons.payment, Colors.green, () {
              // Navegar a la vista Pagar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PagoScreen(),
                ),
              );
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'Movimiento', Icons.compare_arrows, Colors.orange, () {
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

  Widget _buildButton(BuildContext context, String title, IconData icon, Color color,
      VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
