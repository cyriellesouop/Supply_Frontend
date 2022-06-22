
import 'package:flutter/material.dart';
import 'package:supply_app/components/form/text_field.dart';


class DPassField extends StatefulWidget {
  final String hint;
  final bool? isLast;
  final IconData? prefix;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const DPassField({
    Key? key,
    required this.hint,
    this.isLast = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.prefix,
  }) : super(key: key);

  @override
  State<DPassField> createState() => _DPassFieldState();
}

class _DPassFieldState extends State<DPassField> {
  bool see = false;

  @override
  Widget build(BuildContext context) {
    return DTextField(
      hint: widget.hint,
      obscureText: !see,
      prefix: widget.prefix ?? Icons.key,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffix: IconButton(
        onPressed: () {
          setState(() {
            see = !see;
          });
        },
        icon: Icon(
          see ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
      ),
    );
  }
}
