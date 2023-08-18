import 'package:flutter/material.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});

  final TextEditingController emailController = TextEditingController();

  void login() {
    String text = emailController.text;
    print(text);
    emailController.clear();
  }

  void onChangeded(String text) {
    print(text);
  }

  // void onSubmitteded(String text) {
  //   print('on Submitted$text');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                onChanged: onChangeded,
                // onSubmitted: onSubmitteded,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  // hintText: 'exemplo@exemplo.com',
                  // errorText: 'Campo Obrigatório',
                  // labelStyle: TextStyle(
                  //   fontSize: 32,
                  // )
                  // prefixText: 'R\$ ',
                  // suffixText: '...',
                  // border: InputBorder.none,
                ),
                // obscureText: true,
                // obscuringCharacter: 'X',
                // keyboardType: TextInputType.number,
                // style: TextStyle(
                //   fontSize: 18,
                //   fontWeight: FontWeight.w700,
                //   color: Colors.orange,
                // )
              ),
              ElevatedButton(onPressed: login, child: Text('Enter'))
            ],
          ),
        ),
      )
    );
  }
}