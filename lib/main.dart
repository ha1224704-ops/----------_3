import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نور القلوب',
      theme: ThemeData.dark(),
      home: QuranHome(),
    );
  }
}

class QuranHome extends StatefulWidget {
  @override
  _QuranHomeState createState() => _QuranHomeState();
}

class _QuranHomeState extends State<QuranHome> {
  final player = AudioPlayer();
  int currentAya = 0;
  bool isPlaying = false;

  Future<void> playAya(int sura, int aya) async {
    try {
      final url = "https://everyayah.com/data/Alafasy_128kbps/${sura.toString().padLeft(3, '0')}${aya.toString().padLeft(3, '0')}.mp3";
      await player.setUrl(url);
      await player.play();
      setState(() {
        isPlaying = true;
        currentAya = aya;
      });
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          playAya(sura, aya + 1);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("نور القلوب", style: TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(0xFFD4AF37), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    "بسم الله الرحمن الرحيم",
                    style: TextStyle(color: Color(0xFFD4AF37), fontSize: 19, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text("ثواب هذا العمل مهدى الى روح المرحوم", style: TextStyle(color: Colors.white70, fontSize: 15)),
                  Text("ناصر عزيز", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("الفاتحة لروحه الطاهرة", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16)),
                  Divider(color: Color(0xFFD4AF37)),
                  Text(
                    "بسم الله الرحمن الرحيم الحمد لله رب العالمين الرحمن الرحيم مالك يوم الدين اياك نعبد واياك نستعين اهدنا الصراط المستقيم صراط الذين انعمت عليهم غير المغضوب عليهم ولا الضالين",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Icon(Icons.menu_book, size: 80, color: Color(0xFFD4AF37)),
            SizedBox(height: 20),
            Text("سورة الفاتحة", style: TextStyle(color: Colors.white, fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37), padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () => playAya(1, 1),
              child: Text(isPlaying ? "جاري التشغيل اية $currentAya" : "تشغيل متواصل", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              onPressed: () {
                player.stop();
                setState(() => isPlaying = false);
              },
              child: Text("ايقاف", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}