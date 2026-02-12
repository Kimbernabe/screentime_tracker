import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Screen Time Tracker",
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const ScreenTimeApp(),
    );
  }
}

class ScreenTimeApp extends StatefulWidget {
  const ScreenTimeApp({super.key});

  @override
  State<ScreenTimeApp> createState() => _ScreenTimeAppState();
}

class _ScreenTimeAppState extends State<ScreenTimeApp> {
  int _currentIndex = 0;

  String username = "User";
  int dailyGoal = 5;
  int todayTime = 0;
  List<int> sessions = []; // Each session is in hours

  final TextEditingController timeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  @override
  void dispose() {
    timeController.dispose();
    usernameController.dispose();
    goalController.dispose();
    super.dispose();
  }

  // Add a screen time session
  void addScreenTime() {
    int? hours = int.tryParse(timeController.text);
    if (hours == null || hours <= 0) return;

    setState(() {
      sessions.add(hours);
      todayTime += hours;
      timeController.clear();
    });
  }

  // Advice text
  String getAdvice() {
    if (todayTime < 2) return "🌟 Excellent! Low screen time.";
    if (todayTime <= dailyGoal) return "🙂 Moderate usage. Keep going!";
    return "⚠️ High screen time! Try to reduce.";
  }

  // ------------------- DASHBOARD -------------------
  Widget dashboardScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.smartphone, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                "Hello, $username!",
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Add today's screen time",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: timeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: "Hours",
                          prefixIcon: const Icon(Icons.timer),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Time", style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: addScreenTime,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Total today: $todayTime / $dailyGoal hours",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: todayTime / dailyGoal > 1 ? 1 : todayTime / dailyGoal,
                          minHeight: 12,
                          color: todayTime <= dailyGoal ? Colors.green : Colors.red,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getAdvice(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- HISTORY -------------------
  Widget historyScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Today's Sessions",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                child: Text(
                  "No sessions added yet.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.timer, color: Colors.blueAccent),
                      title: Text("Session ${index + 1}: ${sessions[index]} hours"),
                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: sessions[index] / dailyGoal > 1 ? 1 : sessions[index] / dailyGoal,
                          minHeight: 8,
                          color: sessions[index] <= dailyGoal
                              ? Colors.green
                              : Colors.red,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- PROFILE -------------------
  Widget profileScreen() {
    usernameController.text = username;
    goalController.text = dailyGoal.toString();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.person, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Daily Screen Time Goal",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.timer),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Settings", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    username = usernameController.text;
                    dailyGoal = int.tryParse(goalController.text) ?? dailyGoal;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile updated!")));
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.restart_alt),
                label: const Text("Reset Data", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    todayTime = 0;
                    sessions.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All data reset!")));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- BUILD -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  List<Widget> get screens => [
    dashboardScreen(),
    historyScreen(),
    profileScreen(),
  ];
}
