import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ObjectProvider(),
      child: MaterialApp(
        title: 'Flutter Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
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

/// Has data that is updated every second
/// Simulates an object that is not very resource intensive
@immutable
class CheapObject extends BaseObject {}

/// Has data that is updated every 10 seconds
/// Simulates an object that is resource intensive
@immutable
class ExpensiveObject extends BaseObject {}

/// Provider for [CheapObject] and [ExpensiveObject]
class ObjectProvider extends ChangeNotifier {
  /// Unique id for each instance of provider
  late String id;

  /// An instance of [CheapObject]
  late CheapObject _cheapObject;

  /// A [StreamSubscription] to the stream of [CheapObject]
  late StreamSubscription _cheapObjectStreamSubs;

  /// An instance of [ExpensiveObject]
  late ExpensiveObject _expensiveObject;

  /// A [StreamSubscription] to the stream of [ExpensiveObject]
  late StreamSubscription _expensiveObjectStreamSubs;

  /// Getter for initializing [_cheapObject]
  CheapObject get cheapObject => _cheapObject;

  /// Getter for initializing [_expensiveObject]
  ExpensiveObject get expensiveObject => _expensiveObject;

  /// Default Constructor of [ObjectProvider] that initializes
  /// [id], [_cheapObject] and [_expensiveObject]
  ObjectProvider()
      : id = const Uuid().v4(),
        _cheapObject = CheapObject(),
        _expensiveObject = ExpensiveObject();

  /// Overrides the default [notifyListeners] in order to change / reset
  /// the [id] of the provider whenever [notifyListeners] is called.
  ///
  /// This is done so that we the watch() function knows that a change has
  /// occurred within the provider and can request for rebuild.
  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  /// Initializes [_cheapObjectStreamSubs] and [_expensiveObjectStreamSubs] as
  /// periodic streams with duration as 1 second and 10 seconds respectively
  /// After respective time period, a new instance of [_cheapObject] and
  /// [_expensiveObject] are created within the respective StreamSubs.
  void start() {
    _cheapObjectStreamSubs = Stream.periodic(
      const Duration(seconds: 1),
    ).listen(
      (_) {
        _cheapObject = CheapObject();
        notifyListeners();
      },
    );

    _expensiveObjectStreamSubs =
        Stream.periodic(const Duration(seconds: 10)).listen(
      (_) {
        _expensiveObject = ExpensiveObject();
        notifyListeners();
      },
    );
  }
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

/// Widget to display [ExpensiveObject]'s lastUpdated.
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key? key}) : super(key: key);

  /// [expensiveObject] consists of a select function that selects an [ExpensiveObject]
  /// object (i.e. [_expensiveObject] parameter) of [ObjectProvider] and listens to
  /// changes in it in order to rebuild the widget
  @override
  Widget build(BuildContext context) {
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
      (provider) => provider.expensiveObject,
    );
    return Container(
      height: 100,
      color: Colors.blue,
      child: Column(
        children: [
          const Text('Expensive Widget'),
          const Text('Last Updated'),
          Text(expensiveObject.lastUpdated),
        ],
      ),
    );
  }
}

/// Widget to display [CheapObject]'s lastUpdated.
class CheapWidget extends StatelessWidget {
  const CheapWidget({Key? key}) : super(key: key);

  /// [cheapObject] consists of a select function that selects an [CheapObject]
  /// object (i.e. [_cheapObject] parameter) of [ObjectProvider] and listens to
  /// changes in it in order to rebuild the widget
  @override
  Widget build(BuildContext context) {
    final cheapObject = context.select<ObjectProvider, CheapObject>(
      (provider) => provider.cheapObject,
    );
    return Container(
      height: 100,
      color: Colors.yellow,
      child: Column(
        children: [
          const Text('Cheap Widget'),
          const Text('Last Updated'),
          Text(cheapObject.lastUpdated),
        ],
      ),
    );
  }
}
