import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'firestore.dart';

class MedicamentosList extends StatefulWidget {
  @override
  _MedicamentosListState createState() => _MedicamentosListState();
}

class _MedicamentosListState extends State<MedicamentosList> {
  void launchURL(String url) async {
    await FlutterWebBrowser.openWebPage(url: url);
  }

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> medicamentosList = [];

  void searchMedicamentos() async {
    String searchTerm = searchController.text.toLowerCase();
    List<Map<String, dynamic>> baratoList = await getBarato();
    setState(() {
      medicamentosList = baratoList.where((medicamento) {
        String nombre = medicamento['nombre'].toLowerCase();
        return nombre.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PillSend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar medicamento',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchMedicamentos,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: medicamentosList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> medicamento = medicamentosList[index];
                  return ListTile(
                    title: Text(medicamento['farmacia'] ?? ''),
                    subtitle: Text('Precio: ${medicamento['precio'] ?? ''}'),
                    onTap: () {
                      String? link = medicamento['link'];
                      if (link != null) {
                        launchURL(link);
                      }
                    },
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
