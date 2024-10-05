import 'package:flutter/material.dart';
import 'employee_view.dart';
import 'vehicle_view.dart'; 
import 'repair_view.dart'; 
import 'inventory_view.dart'; 
import 'company_view.dart'; 
import 'shop_view.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login() {
    // Lógica de autenticación aquí
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo blanco
          Container(
            color: Colors.white,
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(30), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 1), 
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 1), 
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          activeColor: Colors.blueAccent,
                        ),
                        Text('Recordarme', style: TextStyle(color: Colors.blueAccent)),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('LOGIN'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.blueAccent, 
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    CompanyTable(),
    EmployeeTable(),
    VehicleTable(),
    RepairTable(), 
    InventoryTable(), 
    Center(child: Text("Vista Caja")),
    ShopView(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taller Mecanico"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Taller Mecanico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Empresa'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Empleados'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Vehículos'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Reparaciones'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Inventario'),
              onTap: () {
                setState(() {
                  _selectedIndex = 4; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Caja'), 
              onTap: () {
                setState(() {
                  _selectedIndex = 6; 
                });
                Navigator.of(context).pop(); 
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
    );
  }
}
