import 'package:facial/pages/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text("Dark Mode"),
            subtitle: const Text("Enable or disable dark mode"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.ChangeTheme(value);
            },
          ),
        ],
      ),
    );
  }
}
