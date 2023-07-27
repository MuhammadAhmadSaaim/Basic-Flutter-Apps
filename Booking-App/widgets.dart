import 'package:flutter/material.dart';

final List<String> locations = ['Lahore', 'Islamabad', 'Karachi', 'Multan'];
final List<String> busCompanyNames = ['Daewoo', 'Skyways'];
final List<String> planeCompanyNames = ['Qatar Airways', 'PIA'];

class HeaderText extends StatelessWidget {
  final String label;

  const HeaderText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}

class BodyLabel extends StatelessWidget {
  final String label;

  const BodyLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.black),
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
      style: const TextStyle(color: Colors.black),
      decoration: CustomTextFieldDecoration.getInputDecoration(labelText),
    );
  }
}

class CustomTextFieldDecoration {
  static InputDecoration getInputDecoration(String labelText) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.black),
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey.shade200,

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  VoidCallback? onPressed;

  CustomElevatedButton({
    required this.text,
    this.onPressed,
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
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final VoidCallback onPressed;

  const CustomButton({
    required this.buttonText,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(15.0),
            elevation: 4.0,
            primary: Colors.black,
          ),
          child: Icon(
            iconData,
            size: 40.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          buttonText,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Back',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String text;
  final Icon icon;
  final VoidCallback onPressed;

  CustomListTile({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(text),
        trailing: icon,
        onTap: onPressed,
      ),
    );
  }
}

class CustomInfoContainer extends StatelessWidget {
  final String text;
  final Icon icon;

  const CustomInfoContainer({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            //border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: icon,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Loading...', style: TextStyle(color: Colors.black),),
    );
  }
}
