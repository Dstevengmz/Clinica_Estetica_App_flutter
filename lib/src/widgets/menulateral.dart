import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLateral extends StatelessWidget {
  final String nombreUsuario;
  final String? rol;
  final VoidCallback? onLogout;

  const MenuLateral({
    Key? key,
    required this.nombreUsuario,
    this.rol,
    this.onLogout,
  }) : super(key: key);
  final Color fondoOscuro = const Color(0xFF1B2430);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: fondoOscuro,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(nombreUsuario),
            accountEmail: Text('usuario@correo.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            decoration: const BoxDecoration(color: Colors.deepPurple),
          ),
          ..._buildItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final r = (rol ?? '').toUpperCase();
    final bool tieneSesion = r.isNotEmpty;
    final items = <Widget>[
      ListTile(
        iconColor: Colors.white,
        leading: const Icon(Icons.home),
        textColor: Colors.white,
        title: const Text('Servicios'),
        onTap: () => Navigator.pushNamed(context, '/pantallaprincipal'),
      ),
    ];

    if (!tieneSesion) {
      items.add(
        ListTile(
          iconColor: Colors.white,
          leading: const Icon(Icons.login),
          textColor: Colors.white,
          title: const Text('Iniciar Sesión'),
          onTap: () => Navigator.pushNamed(context, '/iniciarsesion'),
        ),
      );
    }

    if (r == 'DOCTOR') {
      items.add(
        ListTile(
          iconColor: Colors.white,
          leading: const Icon(Icons.dashboard),
          textColor: Colors.white,
          title: const Text('Panel Doctor'),
          onTap: () => Navigator.pushNamed(context, '/perfildoctor'),
        ),
      );
      items.add(
        ListTile(
          iconColor: Colors.white,
          leading: const Icon(Icons.medical_information),
          textColor: Colors.white,
          title: const Text('Historiales Clínicos'),
          onTap: () => Navigator.pushNamed(context, '/historiales'),
        ),
      );
    } else if (r == 'USUARIO' || r == 'CLIENTE') {
      items.add(
        ListTile(
          iconColor: Colors.white,
          leading: const Icon(Icons.person),
          textColor: Colors.white,
          title: const Text('Panel Usuario'),
          onTap: () => Navigator.pushNamed(context, '/panelusuario'),
        ),
      );
    }

    items.add(
      ListTile(
        iconColor: Colors.white,
        textColor: Colors.white,
        leading: const Icon(Icons.info_outline),
        title: const Text('Acerca de'),
        onTap: () => Navigator.pushNamed(context, '/config'),
      ),
    );

    if (tieneSesion && onLogout != null) {
      items
        ..add(const Divider())
        ..add(
          ListTile(
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => _confirmarLogout(context),
          ),
        );
    }
    return items;
  }

  void _confirmarLogout(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: 'Cerrar Sesión',
      desc: '¿Seguro que deseas cerrar la sesión?',
      buttons: [
        DialogButton(
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),
        DialogButton(
          child: const Text(
            'Salir',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            navigator.pop();
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            await prefs.remove('rol');
            onLogout?.call();
            final scaffoldCtx = navigator.context;
            if (scaffoldCtx.mounted) {
              ScaffoldMessenger.of(scaffoldCtx).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada correctamente')),
              );
              navigator.pushNamedAndRemoveUntil(
                '/iniciarsesion',
                (route) => false,
              );
            }
          },
          gradient: const LinearGradient(
            colors: [Color(0xFFEF5350), Color(0xFFD32F2F)],
          ),
        ),
      ],
    ).show();
  }
}
