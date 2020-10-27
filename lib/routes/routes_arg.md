# Utilisation de la passation d'arguments entre les routes

## Nomage des routes dans `routes.dart`

**Screen**
```dart
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';
[...]
```

**Routes**
```dart
MaterialApp(
  routes: {
    ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
  },
);
```

## Navigation et envois de l'argument vers une route

**Route de départ -> changement de screen + envois d'argument**
```dart
onPressed: () {
    //utlisation de l'argument 'argument' de pushNamed() pour envoyer notre object qui contient l'argument qu'on veut envoyer
    Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: RouteArgument(
        variable_a_envoyer,
      ),
    );
},
```

**Route d'arrivée -> extraction de l'argument**

```dart
Widget build(BuildContext context) {
    
    // Extraction de l'argument
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: Center(
        child: Text(args.variable),
      ),
    );
  }
```