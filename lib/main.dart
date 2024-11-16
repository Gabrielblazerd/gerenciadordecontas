// A Flutter application to store information about multiple game accounts.
// Main features include selecting a game and storing details of up to 100 accounts per game.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const NightCrowsApp());

class NightCrowsApp extends StatelessWidget {
  const NightCrowsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Account Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameSelectionScreen(),
    );
  }
}

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Select a Game',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: SizedBox(
              width: 250,
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    Image.asset('assets/unnamed.png', width: 250, height: 250),
              ),
            ),
            title: const Text('Night Crows', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountListScreen()),
              );
            },
          ),
          // You can add more games here if needed
        ],
      ),
    );
  }
}

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  AccountListScreenState createState() => AccountListScreenState();
}

class AccountListScreenState extends State<AccountListScreen> {
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  _loadAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountsString = prefs.getString('accounts');
    if (accountsString != null) {
      setState(() {
        Iterable decoded = jsonDecode(accountsString);
        accounts =
            List<Account>.from(decoded.map((model) => Account.fromJson(model)));
      });
    }
  }

  _saveAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountsString = jsonEncode(accounts);
    await prefs.setString('accounts', accountsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Night Crows Accounts'),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Account ${index + 1} - Nick: ${accounts[index].nick}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AccountDetailScreen(account: accounts[index]),
                ),
              ).then((updatedAccount) {
                if (updatedAccount != null) {
                  setState(() {
                    accounts[index] = updatedAccount;
                    _saveAccounts();
                  });
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAccount = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AccountDetailScreen()),
          );
          if (newAccount != null) {
            setState(() {
              if (accounts.length < 100) {
                accounts.add(newAccount);
                _saveAccounts();
              }
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AccountDetailScreen extends StatefulWidget {
  final Account? account;

  const AccountDetailScreen({super.key, this.account});

  @override
  AccountDetailScreenState createState() => AccountDetailScreenState();
}

class AccountDetailScreenState extends State<AccountDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nick,
      classe,
      power,
      servidor,
      email,
      senha,
      emailWallet,
      senhaMailWallet,
      privateKey,
      carteira,
      walletName,
      walletLink;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      nick = widget.account!.nick;
      classe = widget.account!.classe;
      power = widget.account!.power;
      servidor = widget.account!.servidor;
      email = widget.account!.email;
      senha = widget.account!.senha;
      emailWallet = widget.account!.emailWallet;
      senhaMailWallet = widget.account!.senhaMailWallet;
      privateKey = widget.account!.privateKey;
      carteira = widget.account!.carteira;
      walletName = widget.account!.walletName;
      walletLink = widget.account!.walletLink;
    } else {
      nick = '';
      classe = '';
      power = '';
      servidor = '';
      email = '';
      senha = '';
      emailWallet = '';
      senhaMailWallet = '';
      privateKey = '';
      carteira = '';
      walletName = '';
      walletLink = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? 'Add Account' : 'Edit Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: nick,
                decoration: const InputDecoration(labelText: 'Nick'),
                onSaved: (value) => nick = value!,
              ),
              TextFormField(
                initialValue: classe,
                decoration: const InputDecoration(labelText: 'Classe'),
                onSaved: (value) => classe = value!,
              ),
              TextFormField(
                initialValue: power,
                decoration: const InputDecoration(labelText: 'Power'),
                onSaved: (value) => power = value!,
              ),
              TextFormField(
                initialValue: servidor,
                decoration: const InputDecoration(labelText: 'Servidor'),
                onSaved: (value) => servidor = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                initialValue: senha,
                decoration: const InputDecoration(labelText: 'Senha'),
                onSaved: (value) => senha = value!,
              ),
              TextFormField(
                initialValue: emailWallet,
                decoration: const InputDecoration(labelText: 'Email Wallet'),
                onSaved: (value) => emailWallet = value!,
              ),
              TextFormField(
                initialValue: senhaMailWallet,
                decoration:
                    const InputDecoration(labelText: 'Senha Mail Wallet'),
                onSaved: (value) => senhaMailWallet = value!,
              ),
              TextFormField(
                initialValue: privateKey,
                decoration: const InputDecoration(labelText: 'Private Key'),
                onSaved: (value) => privateKey = value!,
              ),
              TextFormField(
                initialValue: carteira,
                decoration: const InputDecoration(labelText: 'Carteira'),
                onSaved: (value) => carteira = value!,
              ),
              TextFormField(
                initialValue: walletName,
                decoration: const InputDecoration(labelText: 'Wallet Name'),
                onSaved: (value) => walletName = value!,
              ),
              TextFormField(
                initialValue: walletLink,
                decoration: const InputDecoration(labelText: 'Wallet Link'),
                onSaved: (value) => walletLink = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Account(
                        nick: nick,
                        classe: classe,
                        power: power,
                        servidor: servidor,
                        email: email,
                        senha: senha,
                        emailWallet: emailWallet,
                        senhaMailWallet: senhaMailWallet,
                        privateKey: privateKey,
                        carteira: carteira,
                        walletName: walletName,
                        walletLink: walletLink,
                      ),
                    );
                  }
                },
                child: const Text('Save Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Account {
  String nick;
  String classe;
  String power;
  String servidor;
  String email;
  String senha;
  String emailWallet;
  String senhaMailWallet;
  String privateKey;
  String carteira;
  String walletName;
  String walletLink;

  Account({
    required this.nick,
    required this.classe,
    required this.power,
    required this.servidor,
    required this.email,
    required this.senha,
    required this.emailWallet,
    required this.senhaMailWallet,
    required this.privateKey,
    required this.carteira,
    required this.walletName,
    required this.walletLink,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      nick: json['nick'],
      classe: json['classe'],
      power: json['power'],
      servidor: json['servidor'],
      email: json['email'],
      senha: json['senha'],
      emailWallet: json['emailWallet'],
      senhaMailWallet: json['senhaMailWallet'],
      privateKey: json['privateKey'],
      carteira: json['carteira'],
      walletName: json['walletName'],
      walletLink: json['walletLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nick': nick,
      'classe': classe,
      'power': power,
      'servidor': servidor,
      'email': email,
      'senha': senha,
      'emailWallet': emailWallet,
      'senhaMailWallet': senhaMailWallet,
      'privateKey': privateKey,
      'carteira': carteira,
      'walletName': walletName,
      'walletLink': walletLink,
    };
  }
}
