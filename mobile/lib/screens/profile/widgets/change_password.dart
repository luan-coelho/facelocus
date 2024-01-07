import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class ChangeUserPassword extends StatefulWidget {
  const ChangeUserPassword({super.key});

  @override
  State<ChangeUserPassword> createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _showCurrentPassword = true;
  bool _showNewPassword = true;
  bool _showConfirmPassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Senha atual",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
              const SizedBox(height: 3),
              TextFormField(
                controller: _currentPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _showCurrentPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a senha atual";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0F172A), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(203, 213, 225, 1), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.key, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showCurrentPassword = !_showCurrentPassword;
                        });
                      },
                      child: Icon(
                        _showCurrentPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text("Nova senha",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
              const SizedBox(height: 3),
              TextFormField(
                controller: _newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _showNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a nova senha";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0F172A), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(203, 213, 225, 1), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.key, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                      child: Icon(
                        _showNewPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text("Confirme a senha",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start),
              const SizedBox(height: 3),
              TextFormField(
                controller: _confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _showConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirme a nova senha";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0F172A), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(203, 213, 225, 1), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: const Icon(Icons.key, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                      child: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, // Largura 100%
                height: 50, // Altura de 50
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColorsConst.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () {
                    _login();
                  },
                  child: const Text("Alterar",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              )
            ]),
          )),
    );
  }
}
