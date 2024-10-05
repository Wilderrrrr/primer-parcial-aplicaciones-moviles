import 'package:flutter/material.dart';

class CompanyTable extends StatefulWidget {
  @override
  _CompanyTableState createState() => _CompanyTableState();
}

class _CompanyTableState extends State<CompanyTable> {
  final String companyName = "Mi Empresa";
  final String nit = "123456789";
  final String address = "Calle 123 #45-67";
  final String phone = "(123) 456-7890";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nitController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = companyName;
    nitController.text = nit;
    addressController.text = address;
    phoneController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center( 
          child: Text(
            'Empresa',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildButton("Caja", Icons.money, () {
                    print("Caja presionado");
                  }),
                  _buildButton("Empleados", Icons.person, () {
                    print("Empleados presionado");
                  }),
                  _buildButton("Vehículos", Icons.directions_car, () {
                    print("Vehículos presionado");
                  }),
                  _buildButton("Reparaciones", Icons.build, () {
                    print("Reparaciones presionado");
                  }),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Información de la Empresa:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Nombre"),
                  ),
                  TextField(
                    controller: nitController,
                    decoration: InputDecoration(labelText: "NIT"),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Dirección"),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Teléfono"),
                  ),
                  SizedBox(height: 20),
                  Center( // Centrar el botón
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color azul
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                      
                        print("Editar presionado");
                      },
                      child: Text(
                        "Editar",
                        style: TextStyle(color: Colors.white), 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 20),
          textStyle: TextStyle(fontSize: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
