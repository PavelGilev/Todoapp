import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.black87,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey, titleTextStyle: TextStyle(color: Colors.black, fontSize: 20), ),
        listTileTheme: ListTileThemeData(iconColor: Colors.blue),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 22.0
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontSize: 12.0
          )
        ),
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 220, 120, 57)),

      ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  final TextEditingController _taskController = TextEditingController();
  final List<String> _todoTitles = ['Купить молоко', 'Помыть кота', 'Выучить Flutter'];
  final List<bool> _todoStates = [false, false, false];


  void _createNewTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new task'),

          content: TextField(
            controller: _taskController,
            autofocus: true, // open keyboard immediately
            decoration: const InputDecoration(
              hintText: "Enter task name...",
            ),
          ),
          // Buttons
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // Done
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.trim().isNotEmpty) {

                  // refresh widget
                  setState(() {
                    // add text
                    _todoTitles.add(_taskController.text.trim());
                    // add false
                    _todoStates.add(false);
                  });
                }

                _taskController.clear(); // clear field
                Navigator.of(context).pop(); // cancel dialog and return on previous screen
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'scrollable view',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            for (int i = 0; i < _todoStates.length; i++) ...[
              ListTile(
                leading: Checkbox(
                  value: _todoStates[i],
                  onChanged: (bool? newValue) {
                    setState(() {
                      _todoStates[i] = newValue ?? false;
                    });
                  },
                ),
                title: Text(
                  _todoTitles[i],
                  style: TextStyle(
                    decoration: _todoStates[i] ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.train_sharp, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () {
                    // Delete task and refresh view
                    setState(() {
                      _todoTitles.removeAt(i);
                      _todoStates.removeAt(i);
                    });
                  },
                ),
              ),
              const Divider(height: 1),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _createNewTaskDialog, // link callback
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Add task',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // refresh widget (destruct previous widget and create new one)
  // In flutter each state of widgets -- new widget. We do not re-draw
  // it, we distruct it, free memory, create new one and draw.
  // State we keep in _MyHomePageState class.
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

}
