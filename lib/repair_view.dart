import 'package:flutter/material.dart';

class RepairTable extends StatefulWidget {
  @override
  _RepairTableState createState() => _RepairTableState();
}

class _RepairTableState extends State<RepairTable> {
  List<Repair> repairs = [
    Repair(placa: 'ABC-123', modelo: 'Toyota Corolla', ano: '2020', color: 'Blanco', mecanico: 'Hernando Vivas'),
    Repair(placa: 'XYZ-456', modelo: 'Honda Civic', ano: '2021', color: 'Azul', mecanico: 'Wilder Fabian'),
    Repair(placa: 'HJL-367', modelo: 'Porche 911', ano: '2024', color: 'Rojo', mecanico: 'Elver Galarga'),
    Repair(placa: 'ZUY-546', modelo: 'Lamvorghini SVJ', ano: '2023', color: 'Amarillo', mecanico: 'Susana Oria'),
    // Puedes agregar más reparaciones si lo deseas
  ];

  String searchQuery = '';

  void _addOrEditRepair({Repair? repair}) {
    final placaController = TextEditingController(text: repair?.placa);
    final modeloController = TextEditingController(text: repair?.modelo);
    final anoController = TextEditingController(text: repair?.ano);
    final colorController = TextEditingController(text: repair?.color);
    final mecanicoController = TextEditingController(text: repair?.mecanico);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(repair == null ? "Agregar Reparación" : "Editar Reparación"),
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
                  controller: mecanicoController,
                  decoration: InputDecoration(labelText: "Mecánico"),
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
                  if (repair == null) {
                    // Agregar nueva reparación
                    repairs.add(Repair(
                      placa: placaController.text,
                      modelo: modeloController.text,
                      ano: anoController.text,
                      color: colorController.text,
                      mecanico: mecanicoController.text,
                    ));
                  } else {
                    // Editar reparación existente
                    repair.placa = placaController.text;
                    repair.modelo = modeloController.text;
                    repair.ano = anoController.text;
                    repair.color = colorController.text;
                    repair.mecanico = mecanicoController.text;
                  }
                });
                Navigator.of(context).pop(); 
              },
              child: Text(repair == null ? "Agregar" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteRepair(Repair repair) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Eliminar Reparación"),
          content: Text("¿Desea eliminar la reparación con placa ${repair.placa}?"),
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
                  repairs.remove(repair); 
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
                  decoration: InputDecoration(
                    hintText: "Buscar por placa",
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
                    setState(() {
                      searchQuery = value; // Actualiza la consulta de búsqueda
                    });
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
                    header: Text('Tabla de Reparaciones'),
                    columns: [
                      DataColumn(label: Text('Placa')),
                      DataColumn(label: Text('Modelo')),
                      DataColumn(label: Text('Año')),
                      DataColumn(label: Text('Color')),
                      DataColumn(label: Text('Mecánico')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    source: RepairDataSource(
                      repairs.where((repair) => repair.placa.contains(searchQuery)).toList(), 
                      (repair) => _addOrEditRepair(repair: repair), 
                      _confirmDeleteRepair,
                    ),
                    rowsPerPage: repairs.length < 5 ? repairs.length : 5, // Ajustar filas por página
                    columnSpacing: orientation == Orientation.landscape ? 200 : 100, // Ajustar espacio entre columnas
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addOrEditRepair(),
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

class Repair {
  String placa;
  String modelo;
  String ano; 
  String color;
  String mecanico;

  Repair({required this.placa, required this.modelo, required this.ano, required this.color, required this.mecanico});
}

class RepairDataSource extends DataTableSource {
  final List<Repair> repairs;
  final Function(Repair?) onEdit;
  final Function(Repair) onDelete;

  RepairDataSource(this.repairs, this.onEdit, this.onDelete);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= repairs.length) return null;

    final repair = repairs[index];

    return DataRow(cells: [
      DataCell(Text(repair.placa)),
      DataCell(Text(repair.modelo)),
      DataCell(Text(repair.ano)), 
      DataCell(Text(repair.color)),
      DataCell(Text(repair.mecanico)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(repair), 
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(repair), 
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => repairs.length;

  @override
  int get selectedRowCount => 0; // Cambia esto si implementas selección de filas
}
