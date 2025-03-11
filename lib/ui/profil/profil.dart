import 'package:flutter/material.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green,
        leading: const Icon(Icons.people_rounded),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Action pour ouvrir la page profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: "Mes événements créés",
                items: ["Événement 1", "Événement 2"],
                onSeeMore: () {
                  // Naviguer vers la liste complète des événements créés
                },
              ),
              _buildSection(
                title: "Prochains trainings",
                items: ["Training Lundi", "Training Jeudi"],
                onSeeMore: () {
                  // Naviguer vers la liste complète des trainings
                },
              ),
              _buildSection(
                title: "Mes sports favoris",
                items: ["Football", "Tennis", "Natation"],
                onSeeMore: () {
                  // Naviguer vers la liste complète des sports favoris
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required VoidCallback onSeeMore,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onSeeMore,
                  child: Text("Voir plus", style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: items.map((item) {
                return ListTile(
                  leading: Icon(Icons.sports, color: Colors.green),
                  title: Text(item),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
