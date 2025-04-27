import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

void main() {
  runApp(const MyApp());
}

const String APP_ID = 'YOUR_AGORA_APP_ID';
const String CHANNEL_NAME = 'testchannel';
const String TEMP_TOKEN = 'YOUR_TEMP_TOKEN';
const String USER_ACCOUNT = 'testuser';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RtcEngine _engine;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    
    await _engine.enableVideo();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid, RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
          debugPrint('RemoteVideoState: $state for uid $remoteUid');
        },
      ),
    );

    await _engine.joinChannel(
      token: TEMP_TOKEN,
      channelId: CHANNEL_NAME,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agora Web Video Bug Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Agora Web Video Bug Demo')),
        body: Column(
          children: [
            Expanded(
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
            Expanded(
              child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid!),
                      connection: const RtcConnection(channelId: CHANNEL_NAME),
                    ),
                  )
                : const Center(child: Text('Waiting for remote user...')),
            ),
          ],
        ),
      ),
    );
  }
}
