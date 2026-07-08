import 'package:flutter/material.dart';

class UserSearchField extends StatefulWidget {
  final double width;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const UserSearchField({
    super.key,
    required this.width,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<UserSearchField> createState() => _UserSearchFieldState();
}

class _UserSearchFieldState extends State<UserSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didUpdateWidget(UserSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo actualiza si el texto externo cambió (evita saltos de cursor)
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: "Buscar por nombre, rol o área...",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC62828)),
          suffixIcon: widget.query.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.clear, size: 18, color: Colors.grey), onPressed: widget.onClear)
            : null,
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}