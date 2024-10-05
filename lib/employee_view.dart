import 'package:flutter/material.dart';

class EmployeeTable extends StatefulWidget {
  @override
  _EmployeeTableState createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  List<Employee> employees = [
    Employee(cedula: '123456789', nombre: 'Hernando Vivas', telefono: '303-153-5257', direccion: 'Calle 1 #2-3'),
    Employee(cedula: '987654321', nombre: 'Wilder Fabian', telefono: '310-967-3644', direccion: 'Calle 4 #5-6'),
    Employee(cedula: '123456780', nombre: 'La Teniente Errada', telefono: '300-123-4567', direccion: 'Calle 8 #5-3'),
    Employee(cedula: '987654320', nombre: 'Elver Galarga', telefono: '311-987-8974', direccion: 'Calle 9 #6-6'),
    Employee(cedula: '111222333', nombre: 'Susana Oria', telefono: '323-546-5536', direccion: 'Calle 1 #3-7'),
   
  ];

  String searchQuery = "";

  List<Employee> get filteredEmployees {
    if (searchQuery.isEmpty) {
      return employees;
    } else {
      return employees.where((employee) => employee.cedula.contains(searchQuery)).toList();
    }
  }

  void _addOrEditEmployee({Employee? employee}) {
    final cedulaController = TextEditingController(text: employee?.cedula);
    final nombreController = TextEditingController(text: employee?.nombre);
    final telefonoController = TextEditingController(text: employee?.telefono);
    final direccionController = TextEditingController(text: employee?.direccion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(employee == null ? "Agregar Empleado" : "Editar Empleado"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cedulaController,
                  decoration: InputDecoration(labelText: "Cédula"),
                ),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(labelText: "Teléfono"),
                ),
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(labelText: "Dirección"),
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
                  if (employee == null) {
                    // Agregar nuevo empleado
                    employees.add(Employee(
                      cedula: cedulaController.text,
                      nombre: nombreController.text,
                      telefono: telefonoController.text,
                      direccion: direccionController.text,
                    ));
                  } else {
                    // Editar empleado existente
                    employee.cedula = cedulaController.text;
                    employee.nombre = nombreController.text;
                    employee.telefono = telefonoController.text;
                    employee.direccion = direccionController.text;
                  }
                });
                Navigator.of(context).pop(); 
              },
              child: Text(employee == null ? "Agregar" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Eliminar Empleado"),
          content: Text("¿Desea eliminar a ${employee.nombre}?"),
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
                  employees.remove(employee); 
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
              preferredSize: Size.fromHeight(25.0), 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar por cédula",
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
                      searchQuery = value; 
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
                    header: Text('Tabla de Empleados'),
                    columns: [
                      DataColumn(label: Text('Cédula')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Teléfono')),
                      DataColumn(label: Text('Dirección')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    source: EmployeeDataSource(
                      filteredEmployees, 
                      (employee) => _addOrEditEmployee(employee: employee),
                      _confirmDeleteEmployee,
                    ),
                    rowsPerPage: filteredEmployees.length < 5 ? filteredEmployees.length : 5, 
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
                      onPressed: () => _addOrEditEmployee(),
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

class Employee {
  String cedula;
  String nombre;
  String telefono;
  String direccion;

  Employee({required this.cedula, required this.nombre, required this.telefono, required this.direccion});
}

class EmployeeDataSource extends DataTableSource {
  final List<Employee> employees;
  final Function(Employee?) onEdit;
  final Function(Employee) onDelete;

  EmployeeDataSource(this.employees, this.onEdit, this.onDelete);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= employees.length) return null;

    final employee = employees[index];

    return DataRow(cells: [
      DataCell(Text(employee.cedula)),
      DataCell(Text(employee.nombre)),
      DataCell(Text(employee.telefono)),
      DataCell(Text(employee.direccion)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(employee), 
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(employee), 
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0; 
}
