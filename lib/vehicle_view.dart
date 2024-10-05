import 'package:flutter/material.dart';

class VehicleTable extends StatefulWidget {
  @override
  _VehicleTableState createState() => _VehicleTableState();
}

class _VehicleTableState extends State<VehicleTable> {
  List<Vehicle> vehicles = [
    Vehicle(placa: 'ABC-123', modelo: 'Toyota Corolla', ano: '2020', color: 'Blanco', cliente: 'Juan Pérez'),
    Vehicle(placa: 'XYZ-456', modelo: 'Honda Civic', ano: '2021', color: 'Azul', cliente: 'Ana Gómez'),
    Vehicle(placa: 'HJL-367', modelo: 'Porche 911', ano: '2024', color: 'Rojo', cliente: 'Sevelinda Parada'),
    Vehicle(placa: 'ZUY-546', modelo: 'Lamborghini SVJ', ano: '2023', color: 'Amarillo', cliente: 'Elma Monnt'),
  ];

  List<Vehicle> filteredVehicles = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredVehicles = vehicles; // Iniciar con todos los vehículos
    searchController.addListener(_filterVehicles); // Escuchar cambios en la barra de búsqueda
  }

  void _filterVehicles() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filteredVehicles = vehicles
          .where((vehicle) => vehicle.placa.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  void _addOrEditVehicle({Vehicle? vehicle}) {
    final placaController = TextEditingController(text: vehicle?.placa);
    final modeloController = TextEditingController(text: vehicle?.modelo);
    final anoController = TextEditingController(text: vehicle?.ano);
    final colorController = TextEditingController(text: vehicle?.color);
    final clienteController = TextEditingController(text: vehicle?.cliente);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(vehicle == null ? "Agregar Vehículo" : "Editar Vehículo"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: placaController,
                  decoration: InputDecoration(labelText: "Placa"),
                ),
                TextField(
                  controller: modeloController,
                  decoration: InputDecoration(labelText: "Modelo"),
                ),
                TextField(
                  controller: anoController,
                  decoration: InputDecoration(labelText: "Año"),
                ),
                TextField(
                  controller: colorController,
                  decoration: InputDecoration(labelText: "Color"),
                ),
                TextField(
                  controller: clienteController,
                  decoration: InputDecoration(labelText: "Cliente"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (vehicle == null) {
                    // Agregar nuevo vehículo
                    vehicles.add(Vehicle(
                      placa: placaController.text,
                      modelo: modeloController.text,
                      ano: anoController.text,
                      color: colorController.text,
                      cliente: clienteController.text,
                    ));
                  } else {
                    // Editar vehículo existente
                    vehicle.placa = placaController.text;
                    vehicle.modelo = modeloController.text;
                    vehicle.ano = anoController.text;
                    vehicle.color = colorController.text;
                    vehicle.cliente = clienteController.text;
                  }
                  _filterVehicles(); // Actualizar la lista filtrada
                });
                Navigator.of(context).pop();
              },
              child: Text(vehicle == null ? "Agregar" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteVehicle(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Eliminar Vehículo"),
          content: Text("¿Desea eliminar el vehículo con placa ${vehicle.placa}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  vehicles.remove(vehicle);
                  _filterVehicles(); // Actualizar la lista filtrada
                });
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(25.0), // Ajustar la altura de la barra
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Buscar por Placa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _filterVehicles(); // Actualiza la lista filtrada cuando cambia el texto
                  },
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: PaginatedDataTable(
                    header: Text('Tabla de Vehículos'),
                    columns: [
                      DataColumn(label: Text('Placa')),
                      DataColumn(label: Text('Modelo')),
                      DataColumn(label: Text('Año')),
                      DataColumn(label: Text('Color')),
                      DataColumn(label: Text('Cliente')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    source: VehicleDataSource(
                      filteredVehicles,
                      (vehicle) => _addOrEditVehicle(vehicle: vehicle),
                      _confirmDeleteVehicle,
                    ),
                    rowsPerPage: filteredVehicles.length < 5 ? filteredVehicles.length : 5,
                    columnSpacing: orientation == Orientation.landscape ? 200 : 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addOrEditVehicle(),
                      child: Text("Agregar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Vehicle {
  String placa;
  String modelo;
  String ano; 
  String color;
  String cliente;

  Vehicle({required this.placa, required this.modelo, required this.ano, required this.color, required this.cliente});
}

class VehicleDataSource extends DataTableSource {
  final List<Vehicle> vehicles;
  final Function(Vehicle?) onEdit;
  final Function(Vehicle) onDelete;

  VehicleDataSource(this.vehicles, this.onEdit, this.onDelete);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vehicles.length) return null;

    final vehicle = vehicles[index];

    return DataRow(cells: [
      DataCell(Text(vehicle.placa)),
      DataCell(Text(vehicle.modelo)),
      DataCell(Text(vehicle.ano)), 
      DataCell(Text(vehicle.color)),
      DataCell(Text(vehicle.cliente)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(vehicle), 
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(vehicle), 
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => vehicles.length;

  @override
  int get selectedRowCount => 0; 
}
