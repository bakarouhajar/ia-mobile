import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ia_pour_le_mobile/Activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class AddActivityForm extends StatefulWidget {
  final Function(Activity) onAdd;

  const AddActivityForm({super.key, required this.onAdd});

  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  TextEditingController titreController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController nombreMinController = TextEditingController();
  File? _image;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        identifyImage(_image!); // Identify image when picked
      });
    }
  }

  int selectedHour = 0;
  int selectedMinute = 0;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> identifyImage(File imageFile) async {
    await loadModel();

    final recognition = await Tflite.runModelOnImage(
      path: imageFile.path,
      numResults: 1,
      threshold: 0.2,
    );

    setState(() {
      if (recognition != null) {
        categoryController.text = recognition[0]['label'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titreController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lieuController,
              decoration: const InputDecoration(labelText: 'Lieu'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: prixController,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      dateController.text,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Hour      ',
                  style: TextStyle(fontSize: 16),
                ),

                // Dropdown for hours
                DropdownButton<int>(
                  value: selectedHour,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedHour = newValue!;
                    });
                  },
                  items: List.generate(24, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(index.toString().padLeft(2, '0')),
                    );
                  }),
                ),
                const SizedBox(width: 16),

                // Dropdown for minutes
                DropdownButton<int>(
                  value: selectedMinute,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMinute = newValue!;
                    });
                  },
                  items: List.generate(60, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(index.toString().padLeft(2, '0')),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nombreMinController,
              decoration: const InputDecoration(
                  labelText: 'Nombre Minimum de Personnes'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
              enabled: false,
            ),
            const SizedBox(height: 16),
            _image != null
                ? Image.memory(
                    base64Decode(base64Encode(_image!.readAsBytesSync())),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Ajouter une image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (prixController.text.isEmpty ||
                    lieuController.text.isEmpty ||
                    _image == null ||
                    categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Veuillez saisir le prix, le lieu, et sélectionner une image.',
                      ),
                    ),
                  );
                  return;
                }

                // Combine selected hour and minute into a formatted time string
                String formattedTime =
                    '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';

                Activity newActivity = Activity(
                  id: '',
                  titre: titreController.text,
                  lieu: lieuController.text,
                  prix: double.parse(prixController.text),
                  description: descriptionController.text,
                  date: dateController.text,
                  time: formattedTime, // Assign the formatted time
                  category: categoryController.text,
                  image: base64Encode(_image!.readAsBytesSync()),
                  nombreMinimumPersonnes: int.parse(nombreMinController.text),
                );

                widget.onAdd(newActivity);

                titreController.clear();
                lieuController.clear();
                prixController.clear();
                descriptionController.clear();
                dateController.clear();
                timeController.clear();
                categoryController.clear();
                setState(() {
                  _image = null;
                });
              },
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
