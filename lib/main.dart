import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ViaCepPage extends StatefulWidget {
  @override
  _ViaCepPageState createState() => _ViaCepPageState();
}

class _ViaCepPageState extends State<ViaCepPage> {
  final TextEditingController _cepController = TextEditingController();
  String _endereco = '';

  Future<void> _buscarEndereco() async {
    final dio = Dio();
    final cep = _cepController.text;

    if (cep.isEmpty || cep.length != 8) {
      setState(() {
        _endereco = 'Por favor, insira um CEP válido.';
      });
      return;
    }

    try {
      final response = await dio.get('https://viacep.com.br/ws/$cep/json/');
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          _endereco = "CEP: ${response.data['cep']} \n"
              "Rua: ${response.data["logradouro"]}\n"
              "Estado: ${response.data["estado"]}\n"
              "Cidade: ${response.data["localidade"]}\n"
              "UF: ${response.data["uf"]}\n";
        });
      }
    } catch (e) {
      setState(() {
        _endereco = 'Erro ao buscar o endereço: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta CEP ViaCEP'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cepController,
              decoration: InputDecoration(labelText: 'Digite o CEP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarEndereco,
              child: Text('Buscar'),
            ),
            SizedBox(height: 20),
            Text(
              _endereco,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ViaCepPage(),
    debugShowCheckedModeBanner: false,
  ));
}
