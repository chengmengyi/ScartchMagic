import 'package:audioplayers/audioplayers.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';

StorageHep<bool> playBg=StorageHep<bool>(key: "playBg", defaultValue: true);
StorageHep<bool> playVoice=StorageHep<bool>(key: "playVoice", defaultValue: true);

class VoiceUtils{
  factory VoiceUtils()=>_getInstance();
  static VoiceUtils get instance => _getInstance();
  static VoiceUtils? _instance;
  static VoiceUtils _getInstance(){
    _instance??=VoiceUtils._internal();
    return _instance!;

  }
  final _bgAudioPlayer=AudioPlayer();
  final _voiceAudioPlayer=AudioPlayer();

  VoiceUtils._internal(){
    _voiceAudioPlayer.onPlayerStateChanged.listen((event) {
      if(playBg.read()){
        if(event==PlayerState.playing){
          _bgAudioPlayer.pause();
        }else if(event==PlayerState.completed){
          _bgAudioPlayer.resume();
        }
      }
    });
  }

  playBgMp3(){
    if(playBg.read()){
      _bgAudioPlayer.setReleaseMode(ReleaseMode.loop);
      _bgAudioPlayer.play(AssetSource("beijing.MP3"));
    }
  }

  playVoiceMp3(){
    if(playVoice.read()){
      _voiceAudioPlayer.play(AssetSource("guaka.MP3"));
    }
  }

  setPlayOrStopBg(){
    if(playBg.read()){
      playBg.write(false);
      _bgAudioPlayer.stop();
    }else{
      playBg.write(true);
      playBgMp3();
    }
  }

  setPlayOrStopVoice(){
    playVoice.write(!playVoice.read());
  }
}