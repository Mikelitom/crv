import 'package:flutter/material.dart';

class BaseAssetDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onConfirm;
  final bool isLoading;
  final bool isSuccess; // 🔥 NUEVO

  const BaseAssetDialog({
    required this.title,
    required this.children,
    this.onConfirm,
    this.isLoading = false,
    this.isSuccess = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titlePadding: EdgeInsets.zero,

      /// 🔥 HEADER DINÁMICO
      title: _buildHeader(),

      /// 🔥 CONTENIDO DINÁMICO
      content: SizedBox(
        width: 480,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSuccess
              ? _buildSuccessState()
              : SingleChildScrollView(
                  child: Column(
                    key: const ValueKey("form"),
                    mainAxisSize: MainAxisSize.min,
                    children: [const SizedBox(height: 12), ...children],
                  ),
                ),
        ),
      ),

      /// 🔥 ACCIONES DINÁMICAS
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: isSuccess ? [] : _buildActions(context),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.withOpacity(0.05)
            : const Color(0xFFD32F2F).withOpacity(0.04),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Icon(
            isSuccess
                ? Icons.check_circle_rounded
                : Icons.add_circle_outline_rounded,
            color: isSuccess ? Colors.green : const Color(0xFFD32F2F),
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            isSuccess ? "¡Registro exitoso!" : title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A1C1E),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// BOTONES
  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Cancelar",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD32F2F).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  "Registrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    ];
  }

  /// SUCCESS UI
  Widget _buildSuccessState() {
    return SizedBox(
      key: const ValueKey("success"),
      height: 220,
      child: Center(
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 64,
              color: Colors.green.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildField(
  TextEditingController? controller,
  String label,
  String hint, {
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF454B4E),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.all(18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    ),
  );
}
