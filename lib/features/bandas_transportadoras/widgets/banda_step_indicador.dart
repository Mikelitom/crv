import 'package:flutter/material.dart';

class BandaStepIndicator extends StatelessWidget {
  final int currentIndex;
  final List<String> sectionNames;
  final bool isRodilleriaActive;

  const BandaStepIndicator({
    super.key, 
    required this.currentIndex, 
    required this.sectionNames,
    this.isRodilleriaActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(sectionNames.length, (index) {
          bool isCompleted = index < currentIndex;
          bool isActive = index == currentIndex;
          bool isOptional = sectionNames[index] == "Rodillería";
          
          // Color institucional Rojo o Verde si ya pasó
          Color stateColor = isActive 
              ? const Color(0xFFC62828) 
              : (isCompleted ? Colors.green : Colors.grey.shade300);

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container(height: 2, color: index == 0 ? Colors.transparent : Colors.grey.shade300)),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: stateColor,
                        shape: BoxShape.circle,
                        border: isOptional ? Border.all(color: Colors.orange, width: 2) : null, // Marca de opcional
                      ),
                      child: Center(
                        child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(child: Container(height: 2, color: index == sectionNames.length - 1 ? Colors.transparent : Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  sectionNames[index],
                  style: TextStyle(
                    fontSize: 9, 
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isOptional ? Colors.orange.shade700 : (isActive ? Colors.red : Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}