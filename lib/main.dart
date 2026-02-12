import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --------- DARK NAVY COLORS ----------
const Color navyDark = Color(0xFF0A192F);
const Color navy = Color(0xFF112240);
const Color navyLight = Color(0xFF1F3A5F);
const Color cardDark = Color(0xFF233554);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Screen Time Tracker",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: navyDark,
      ),
      home: const ScreenTimeApp(),
    );
  }
}

BoxDecoration navyGradient() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [navyDark, navy],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
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
  List<int> sessions = [];

  final TextEditingController timeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  void addScreenTime() {
    int? hours = int.tryParse(timeController.text);
    if (hours == null || hours <= 0) return;

    setState(() {
      sessions.add(hours);
      todayTime += hours;
      timeController.clear();
    });
  }

  void removeSession(int index) {
    setState(() {
      todayTime -= sessions[index];
      sessions.removeAt(index);
    });
  }

  void resetAll() {
    setState(() {
      sessions.clear();
      todayTime = 0;
    });
  }

  String getAdvice() {
    if (todayTime < 2) return "Excellent! Low screen time.";
    if (todayTime <= dailyGoal) return "Moderate usage. Keep going!";
    return "High screen time! Try to reduce.";
  }

  // ---------------- DASHBOARD ----------------
  Widget dashboardScreen() {
    return Container(
      decoration: navyGradient(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.smartphone, size: 80, color: Colors.white70),
              const SizedBox(height: 10),
              Text(
                "Hello, $username 👋",
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),

              // -------- INPUT CARD --------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Screen Time",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: timeController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter hours",
                        hintStyle:
                        const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: navyLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15)),
                            ),
                            onPressed: addScreenTime,
                            child: const Text("Add Time"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15)),
                            ),
                            onPressed: () => timeController.clear(),
                            child: const Text("Clear"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // -------- PROGRESS CARD --------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      "Today's Usage: $todayTime / $dailyGoal hrs",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: todayTime / dailyGoal > 1
                          ? 1
                          : todayTime / dailyGoal,
                      minHeight: 12,
                      color: Colors.blueAccent,
                      backgroundColor: navyLight,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getAdvice(),
                      style:
                      const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HISTORY ----------------
  Widget historyScreen() {
    return Container(
      decoration: navyGradient(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Sessions Today",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: resetAll,
                child: const Text("Reset All"),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: sessions.isEmpty
                    ? const Center(
                  child: Text(
                    "No sessions yet.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: cardDark,
                      child: ListTile(
                        leading: const Icon(Icons.timer,
                            color: Colors.white),
                        title: Text(
                          "Session ${index + 1}: ${sessions[index]} hrs",
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: () =>
                              removeSession(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- PROFILE ----------------
  Widget profileScreen() {
    usernameController.text = username;
    goalController.text = dailyGoal.toString();

    return Container(
      decoration: navyGradient(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.person,
                  size: 80, color: Colors.white70),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle:
                  const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: navyLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: goalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Daily Goal (hrs)",
                  hintStyle:
                  const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: navyLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    username = usernameController.text;
                    dailyGoal =
                        int.tryParse(goalController.text) ??
                            dailyGoal;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Profile updated!")));
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        dashboardScreen(),
        historyScreen(),
        profileScreen(),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: navy,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
