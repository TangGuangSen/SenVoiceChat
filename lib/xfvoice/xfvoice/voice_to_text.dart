import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/Values/values.dart';
import 'package:flutter_chatgpt/configs/translations.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:siri_wave/siri_wave.dart';

import '../utils/xf_socket.dart';
import 'anmation/RecordingAnimation.dart';
import 'canvas/voice_animtor.dart';

/// 作者： lixp
/// 创建时间： 2022/6/17 10:21
/// 类介绍：语音转文本
class VoiceText extends StatefulWidget {


  const VoiceText({Key? key,required this.onSendText}) : super(key: key);
  final Function( String text)? onSendText;


  @override
  _VoiceTextState createState() => _VoiceTextState();
}

class _VoiceTextState extends State<VoiceText> {
  final FlutterSoundRecorder _mRecorder =
      FlutterSoundRecorder(logLevel: Level.debug);

  /// 实时语音听写
  /// 最长支持1分钟即使语音听写
  /// 超出1分钟请参考语音转写
  Timer? _timer;
  int max_time = 59;
  int currentTime = 59;

  XfSocket? xfSocket;

  /// 识别文本
  String text = "";

  /// 是否在说话
  bool isTalking = false;

  /// 声音大小 0 - 120
  ValueNotifier<double> voiceNum = ValueNotifier<double>(0.0);
  final _controller = SiriWaveController();

  String getTime(int time){
    if(time>9){
      return time.toString();
    }else{
      return "0$time";
    }
  }

  @override
  void initState() {
    super.initState();

    initRecorder();
    _controller.speed = 0.03;
    _controller.color = AppColors.primaryAccentColor;
    onSpeak();
  }

  /// 初始化录音
  Future<void> initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    await _mRecorder.openRecorder();
    // 设置音频音量获取频率
    _mRecorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
    _mRecorder.onProgress!.listen((event) {
      // 0 - 120
      voiceNum.value = event.decibels ?? 0;
    });

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  StreamSubscription? _mRecordingDataSubscription;

  Future<void> stopRecorder() async {
    setState(() {
      isTalking = false;
    });
    await _mRecorder.stopRecorder();
    voiceNum.value = 0.0;
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
  }

  void onSpeak() {
    if (!isTalking) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          currentTime--;
          if (currentTime == 0) {
            _timer?.cancel();
         //   stopRecorder();
            currentTime = max_time;
          }
        });
      });
      xfSocket = XfSocket.connectVoice(onTextResult: (text) {
        setState(() {
          this.text = text;
        });
      });
      state = 0;
      // startRecord();
      setState(() {
        isTalking = true;
      });
    } else {
      _timer?.cancel();
      state = 2;
      // stopRecorder();
    }
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 38,
                width: 38,
                child: SvgPicture.asset(
                  'assets/icon/cancel.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
              start: 20, end: 20, top: 100, bottom: 20),
          child: Text(
            "$text",
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        Container(
            width: double.infinity,
            height: 72,
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icon/audio.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
                ),
                SiriWave(
                  controller: _controller,
                  options: SiriWaveOptions(
                    height: kIsWeb ? 300 : 38,
                    showSupportBar: false,
                    width:
                        kIsWeb ? 600 : MediaQuery.of(context).size.width * 0.5,
                  ),
                  style: SiriWaveStyle.ios_7,
                ),
              ],
            )),
        Text(
          "00:${getTime(currentTime)}",
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(
          height: 16,
        ),
      GestureDetector(onTap:(){
        Navigator.pop(context);
        widget.onSendText?.call("你好，我是森，今天如何？");
      },child: Container(
        height: 44,
        width: 100,
        alignment: Alignment.center,
        margin: const EdgeInsetsDirectional.only(top: 10, bottom: 16),
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryAccentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          MyTranslations.TR_NAME_SEND.tr,
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),)
      ],
    );
  }

  /// 0 :第一帧音频
  /// 1 :中间的音频
  /// 2 :最后一帧音频，最后一帧必须要发送
  int state = 0;

  Future<void> startRecord() async {
    var recordingDataController = StreamController<FoodData>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (state == 0) {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = 1;
      } else if (state == 1) {
        xfSocket?.sendVoice(buffer.data!, state: state);
      } else if (state == 2) {
        xfSocket?.sendVoice(buffer.data!, state: state);
        state = -1;
      }
    });
    await _mRecorder.startRecorder(
      // toFile: "filePath",
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );
  }
}
