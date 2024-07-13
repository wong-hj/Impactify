import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class Recording extends StatefulWidget {
  const Recording({super.key});

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey(); 
  

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
        //"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
"https://firebasestorage.googleapis.com/v0/b/impactifyapp-1fcfa.appspot.com/o/Timing.mp4?alt=media&token=1f59c474-525e-43b5-ad0f-3718a4cc6728"
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    _betterPlayerController.isPictureInPictureSupported();
    
    return Expanded(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
              key: _betterPlayerKey,
            ),
          ),
      
          ElevatedButton(
              child: Text("Show PiP"),
              onPressed: () async {
                _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
              },
            ),
      
            ElevatedButton(
              child: Text("Disable PiP"),
              onPressed: () async {
                _betterPlayerController.disablePictureInPicture();
              },
            ),
        ],
      ),
    );
  }
}