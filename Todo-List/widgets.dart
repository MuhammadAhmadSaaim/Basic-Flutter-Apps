import 'package:flutter/material.dart';

class DataRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const DataRowWidget({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.indigo,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 35,
        ),
      ],
    );
  }
}

class ProfilePageDivider extends StatelessWidget {
  const ProfilePageDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 3,
      indent: 20,
      endIndent: 20,
      color: Colors.indigo,
      height: 60,
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      style: const TextStyle(color: Colors.indigo),
      decoration: CustomTextFieldDecoration.getInputDecoration(labelText),
    );
  }
}

class CustomTextFieldDecoration {
  static InputDecoration getInputDecoration(String labelText) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.indigo),
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const CustomListTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.indigo),
      ),
      trailing: Icon(
        icon,
        color: Colors.indigo,
      ),
      onTap: onTap,
    );
  }
}

class HeaderText extends StatelessWidget {
  final String label;

  const HeaderText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}

class CustomLabel extends StatelessWidget {
  final String label;

  const CustomLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white),
    );
  }
}
