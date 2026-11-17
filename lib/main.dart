import 'package:flutter/material.dart';
void main() => runApp(const SportifyApp());

const navy = Color(0xFF142B3B);
const orange = Color(0xFFFF7A36);
const cream = Color(0xFFF6F4EF);
const muted = Color(0xFF73808A);

class SportifyApp extends StatelessWidget {
  const SportifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: orange, primary: navy),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: cream, foregroundColor: navy, elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class Facility {
  final String name, sport, location, price, rating, image, description;
  final IconData icon;
  const Facility(this.name, this.sport, this.location, this.price, this.rating,
      this.image, this.description, this.icon);
}

const facilities = [
  Facility('Arena Sports Club', 'Football', 'Saida, Lebanon', '\$25 / hour', '4.9',
      '⚽', 'Premium outdoor football field with lighting and changing rooms.', Icons.sports_soccer),
  Facility('Downtown Hoops', 'Basketball', 'Beirut, Lebanon', '\$18 / hour', '4.8',
      '🏀', 'Indoor basketball court with professional flooring.', Icons.sports_basketball),
  Facility('Ace Tennis Center', 'Tennis', 'Tyre, Lebanon', '\$15 / hour', '4.7',
      '🎾', 'Well-maintained tennis courts with equipment rental available.', Icons.sports_tennis),
  Facility('Padel Point', 'Padel', 'Saida, Lebanon', '\$22 / hour', '4.9',
      '🎾', 'Modern panoramic padel courts for friends and groups.', Icons.sports_tennis),
  Facility('Volley Hub', 'Volleyball', 'Beirut, Lebanon', '\$20 / hour', '4.6',
      '🏐', 'Indoor volleyball court suitable for casual and competitive games.', Icons.sports_volleyball),
];

class Reservation {
  final Facility facility;
  final DateTime date;
  final String time, duration, bookingType;
  final int players;
  final List<String> extras;
  Reservation({required this.facility, required this.date, required this.time,
    required this.duration, required this.bookingType, required this.players, required this.extras});
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final List<Reservation> bookings = [];
  void addBooking(Reservation r) => setState(() => bookings.add(r));
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onBrowse: () => setState(() => tab = 1), onBook: openBooking),
      ExplorePage(onBook: openBooking),
      BookingPage(facility: facilities.first, onConfirm: addBooking, standalone: false),
      ReservationsPage(bookings: bookings),
      const ProfilePage(),
    ];
    return Scaffold(
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: Colors.white,
        indicatorColor: orange.withValues(alpha: .16),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Book'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void openBooking(Facility facility) {
    Navigator.push(context, MaterialPageRoute(builder: (_) =>
      BookingPage(facility: facility, onConfirm: (r) {
        addBooking(r);
        Navigator.pop(context);
        setState(() => tab = 3);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservation confirmed!')));
      }, standalone: true)));
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onBrowse;
  final ValueChanged<Facility> onBook;
  const HomePage({super.key, required this.onBrowse, required this.onBook});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      Row(children: [
        const CircleAvatar(backgroundColor: navy, child: Icon(Icons.sports, color: Colors.white)),
        const SizedBox(width: 10),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SPORTIFY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, color: navy)),
          Text('Find. Book. Play.', style: TextStyle(color: muted, fontSize: 12)),
        ])),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: navy)),
      ]),
      const SizedBox(height: 26),
      const Text('Ready to play?', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: navy)),
      const SizedBox(height: 6),
      const Text('Find a place. Bring your game.', style: TextStyle(color: muted)),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('YOUR NEXT GAME\\nSTARTS HERE.', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.2, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text('Book courts and fields in a few taps.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: onBrowse, icon: const Icon(Icons.search), label: const Text('Explore facilities'),
            style: FilledButton.styleFrom(backgroundColor: orange, foregroundColor: Colors.white)),
        ]),
      ),
      const SizedBox(height: 26),
      sectionTitle('Choose your sport', 'See all', onBrowse),
      const SizedBox(height: 14),
      SizedBox(height: 94, child: ListView(scrollDirection: Axis.horizontal, children: const [
        SportTile('Football', '⚽'), SportTile('Basketball', '🏀'), SportTile('Tennis', '🎾'),
        SportTile('Padel', '🎾'), SportTile('Volleyball', '🏐'),
      ])),
      const SizedBox(height: 25),
      sectionTitle('Popular near you', 'View all', onBrowse),
      const SizedBox(height: 12),
      ...facilities.take(3).map((f) => FacilityCard(facility: f, onTap: () => onBook(f))),
    ],
  ));
}

Widget sectionTitle(String title, String action, VoidCallback onTap) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: navy)),
    TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: orange, fontWeight: FontWeight.bold)))],
);

class SportTile extends StatelessWidget {
  final String name, emoji;
  const SportTile(this.name, this.emoji, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 82, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 27)), const SizedBox(height: 5),
      Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: navy)),
    ]),
  );
}

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final VoidCallback onTap;
  const FacilityCard({super.key, required this.facility, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12), color: Colors.white, elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: InkWell(borderRadius: BorderRadius.circular(18), onTap: onTap, child: Padding(
      padding: const EdgeInsets.all(12), child: Row(children: [
        Container(width: 82, height: 82, decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14)),
          child: Center(child: Text(facility.image, style: const TextStyle(fontSize: 38)))),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(facility.name, style: const TextStyle(fontWeight: FontWeight.w800, color: navy, fontSize: 15)),
          const SizedBox(height: 4),
          Text('${facility.sport} • ${facility.location}', style: const TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 7),
          Row(children: [const Icon(Icons.star, color: orange, size: 15), Text(' ${facility.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const Spacer(), Text(facility.price, style: const TextStyle(color: orange, fontWeight: FontWeight.w800, fontSize: 12))]),
        ])),
        const Icon(Icons.chevron_right, color: muted),
      ]),
    )),
  );
}

class ExplorePage extends StatefulWidget {
  final ValueChanged<Facility> onBook;
  const ExplorePage({super.key, required this.onBook});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}
class _ExplorePageState extends State<ExplorePage> {
  String selected = 'All';
  final options = ['All', 'Football', 'Basketball', 'Tennis', 'Padel', 'Volleyball'];
  @override
  Widget build(BuildContext context) {
    final list = selected == 'All' ? facilities : facilities.where((f) => f.sport == selected).toList();
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Explore', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: navy)),
      const SizedBox(height: 5), const Text('Find the perfect place to play.', style: TextStyle(color: muted)),
      const SizedBox(height: 18),
      TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search facilities or locations',
        ),
      ),      const SizedBox(height: 15),
      SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal, children: options.map((s) =>
        Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(s), selected: selected == s,
          selectedColor: orange.withValues(alpha: .2), onSelected: (_) => setState(() => selected = s)))).toList())),
      const SizedBox(height: 15),
      Text('${list.length} facilities found', style: const TextStyle(color: muted, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      ...list.map((f) => FacilityCard(facility: f, onTap: () => widget.onBook(f))),
    ]));
  }
}

class BookingPage extends StatefulWidget {
  final Facility facility;
  final ValueChanged<Reservation> onConfirm;
  final bool standalone;
  const BookingPage({super.key, required this.facility, required this.onConfirm, required this.standalone});
  @override
  State<BookingPage> createState() => _BookingPageState();
}
class _BookingPageState extends State<BookingPage> {
  DateTime date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay time = const TimeOfDay(hour: 18, minute: 0);
  String duration = '1 hour', bookingType = 'Group';
  int players = 5;
  final extras = <String>{};
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: widget.standalone ? AppBar(title: const Text('Book a facility')) : null,
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      if (!widget.standalone) const Text('Quick booking', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: navy)),
      if (!widget.standalone) const SizedBox(height: 8),
      const Text('Complete your game details', style: TextStyle(color: muted)),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [const Icon(Icons.stadium, color: orange, size: 34), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.facility.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            Text('${widget.facility.sport} • ${widget.facility.price}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]))])),
      const SizedBox(height: 20),
      label('Booking type'),
      RadioListTile<String>(contentPadding: EdgeInsets.zero, dense: true, value: 'Individual', groupValue: bookingType, title: const Text('Individual'), onChanged: (v) => setState(() => bookingType = v!)),
      RadioListTile<String>(contentPadding: EdgeInsets.zero, dense: true, value: 'Group', groupValue: bookingType, title: const Text('Group'), onChanged: (v) => setState(() => bookingType = v!)),
      const SizedBox(height: 8),
      label('Date & time'),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () async {
          final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 180)));
          if (d != null) setState(() => date = d);
        }, icon: const Icon(Icons.calendar_today), label: Text('${date.day}/${date.month}/${date.year}'))),
        const SizedBox(width: 10),
        Expanded(child: OutlinedButton.icon(onPressed: () async {
          final t = await showTimePicker(context: context, initialTime: time);
          if (t != null) setState(() => time = t);
        }, icon: const Icon(Icons.access_time), label: Text(time.format(context)))),
      ]),
      const SizedBox(height: 16),
      label('Number of players'),
      DropdownButtonFormField<int>(initialValue: players, decoration: const InputDecoration(), items: List.generate(20, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n players'))).toList(), onChanged: (v) => setState(() => players = v!)),
      const SizedBox(height: 16),
      label('Duration'),
      DropdownButtonFormField<String>(initialValue: duration, decoration: const InputDecoration(), items: ['1 hour', '1.5 hours', '2 hours', '3 hours'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(), onChanged: (v) => setState(() => duration = v!)),
      const SizedBox(height: 16),
      label('Additional services'),
      ...['Equipment rental', 'Changing room', 'Shower access'].map((x) => CheckboxListTile(contentPadding: EdgeInsets.zero, dense: true, title: Text(x), value: extras.contains(x), onChanged: (v) => setState(() => v! ? extras.add(x) : extras.remove(x)))),
      const SizedBox(height: 18),
      FilledButton(onPressed: () => widget.onConfirm(Reservation(facility: widget.facility, date: date,
        time: time.format(context), duration: duration, bookingType: bookingType, players: players, extras: extras.toList())),
        style: FilledButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(vertical: 16)),
        child: const Text('Confirm reservation', style: TextStyle(fontWeight: FontWeight.bold))),
      const SizedBox(height: 8),
      const Center(child: Text('Demo app • No payment is processed', style: TextStyle(color: muted, fontSize: 11))),
    ])),
  );
}
Widget label(String s) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(s, style: const TextStyle(fontWeight: FontWeight.w800, color: navy, fontSize: 15)));

class ReservationsPage extends StatelessWidget {
  final List<Reservation> bookings;
  const ReservationsPage({super.key, required this.bookings});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('My bookings', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: navy)),
    const SizedBox(height: 5), const Text('Your games, all in one place.', style: TextStyle(color: muted)),
    const SizedBox(height: 20),
    if (bookings.isEmpty) Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Column(children: [Icon(Icons.event_available, size: 54, color: orange), SizedBox(height: 12),
        Text('No reservations yet', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5), Text('Your confirmed bookings will appear here.', textAlign: TextAlign.center, style: TextStyle(color: muted))]))
    else ...bookings.reversed.map((b) => Card(color: Colors.white, elevation: 0, child: ListTile(
      leading: const CircleAvatar(backgroundColor: cream, child: Icon(Icons.sports, color: navy)),
      title: Text(b.facility.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${b.date.day}/${b.date.month}/${b.date.year} • ${b.time}\\n${b.duration} • ${b.players} players'),
      isThreeLine: true, trailing: const Icon(Icons.check_circle, color: Colors.green),
    ))),
  ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('My profile', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: navy)),
    const SizedBox(height: 25),
    const Center(child: CircleAvatar(radius: 44, backgroundColor: navy, child: Icon(Icons.person, color: Colors.white, size: 48))),
    const SizedBox(height: 12),
    const Center(child: Text('Sportify Player', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: navy))),
    const Center(child: Text('player@sportify.demo', style: TextStyle(color: muted))),
    const SizedBox(height: 28),
    ...[
      (Icons.person_outline, 'Personal information'),
      (Icons.favorite_border, 'Favorite facilities'),
      (Icons.notifications_none, 'Notifications'),
      (Icons.help_outline, 'Help & support'),
      (Icons.settings_outlined, 'Settings'),
    ].map((e) => Card(color: Colors.white, elevation: 0, child: ListTile(leading: Icon(e.$1, color: orange), title: Text(e.$2), trailing: const Icon(Icons.chevron_right)))),
    const SizedBox(height: 15),
    const Center(child: Text('SPORTIFY  •  FIND. BOOK. PLAY.', style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1.5))),
  ]));
}
