import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

/// Immutable class [BaseObject] which will be inherited later
@immutable
class BaseObject {
  /// Unique identifier for objects
  final String id;

  /// Last updated time for objects
  final String lastUpdated;

  /// Default constructor for initializing parameters [id] and [lastUpdated]
  BaseObject()
      : id = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  /// Overriding [==] operator to compare ids
  @override
  bool operator ==(covariant BaseObject other) => id == other.id;

  /// Overriding [hashCode] getter to get hashCode of [id] instead.
  @override
  int get hashCode => id.hashCode;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home Page')),
      ),
    );
  }
}
