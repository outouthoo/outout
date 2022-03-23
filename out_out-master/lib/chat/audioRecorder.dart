import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:out_out/chat/playButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';

typedef _Fn = void Function();

class AudioRecord extends StatefulWidget {
  AudioRecord({
    Key key,
    @required this.title,
    @required this.callback,
  }) : super(key: key);

  final String title;
  final Function callback;

  @override
  _AudioRecordState createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {


  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    stopWatchStream();
    super.dispose();
  }

  bool issinit = true;

  int i = 0;
  String recordFilePath;
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }
  bool isRecording = false;

  // ----------------------  Here is the code for recording and playback -------
  Timer timerr;
  void record() async {
    setStateIfMounted(() {
      recordertime = '00:00:00';
      hoursStr = '00';
      secondsStr = '00';
      hoursStr = '00';
      minutesStr = '00';
    });
    recordFilePath = await getFilePath();
    status = 'recording';
    issinit = false;
    isRecording = true;
    startTimerNow();
    RecordMp3.instance.start(recordFilePath, (type) {
      setState(() {});
    });
    setState(() {});
  }

  File recordedfile;
  void stopRecorder() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      isRecording = false;
      // recordedfile = File(value);
      recordertime = "$hoursStr:$minutesStr:$secondsStr";
      status = 'recorded';
      streamController.done;
      streamController.close();
      timerSubscription.cancel();
      setState(() {});
    }
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {

    return !isRecording ? record : stopRecorder;
  }

  String status = 'notrecording';

  Future<bool> onWillPopNEw() {
    return Future.value(issinit == true
        ? true
        : false);
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Center(
        child: isLoading == true
            ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
            : Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(13),
              // height: 160,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(children: [
                // Text(
                //   _mRecorder!.isRecording
                //       ? getTranslated(this.context, 'recording')
                //       : recordertime == '00:00:00'
                //           ? ''
                //           : getTranslated(
                //               this.context, 'recorderstopped'),
                //   style: TextStyle(fontSize: 16, color: Colors.white),
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  isRecording
                      ? "$hoursStr:$minutesStr:$secondsStr"
                      : recordertime,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                PlayButton(
                  pauseIcon: Icon(
                    Icons.stop,
                    color: Colors.red,
                    size: 60,
                  ),
                  playIcon:
                  Icon(Icons.mic, color: Colors.red, size: 70),
                  onPressed: getRecorderFn(),
                ),
                // RawMaterialButton(
                //   onPressed: getRecorderFn(),
                //   elevation: 2.0,
                //   fillColor:
                //       _mRecorder!.isRecording ? Colors.red : Colors.white,
                //   child: Icon(
                //     _mRecorder!.isRecording
                //         ? Icons.stop
                //         : Icons.mic_rounded,
                //     size: 75.0,
                //     color: _mRecorder!.isRecording
                //         ? Colors.white
                //         : Colors.red,
                //   ),
                //   padding: EdgeInsets.all(15.0),
                //   shape: CircleBorder(),
                // ),
              ]),
            ),
            /*     status == 'recorded'
                      ? Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(13),
                          // height: 160,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Text(
                              _mPlayer.isPlaying
                                  ? 'playingrecording'
                                  : '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RawMaterialButton(
                              onPressed: getPlaybackFn(),
                              elevation: 2.0,
                              fillColor: _mPlayer.isPlaying
                                  ? Colors.black
                                  : Colors.green,
                              child: Icon(
                                _mPlayer.isPlaying
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                size: 45.0,
                                color: _mPlayer.isPlaying
                                    ? Colors.black
                                    : Colors.black,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                          ]),
                        )
                      : SizedBox(
                          height: 20,
                        ),*/
            SizedBox(
              height: 20,
            ),
            status == 'recorded'
                ? RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.green)),
                elevation: 0.2,
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                onPressed: () {
                  setStateIfMounted(() {
                    isLoading = true;
                  });
                  /*  widget
                                    .callback(recordFilePath)
                                    .then((recordedUrl) {
                                });*/
                  Navigator.pop(context, recordFilePath);

                },
                child: Text(
                  'Send Recording',
                  style: TextStyle(
                      fontSize: 16, color: Colors.white),
                ))
                : SizedBox()
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: onWillPopNEw,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: makeBody(),
        ));
  }

  //------ Timer Widget Section Below:
  bool flag = true;
  Stream<int> timerStream;
  // ignore: cancel_subscriptions
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  String recordertime = '00:00:00';
  // ignore: close_sinks
  StreamController<int> streamController;
  Stream<int> stopWatchStream() {
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  startTimerNow() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setStateIfMounted(() {
        hoursStr =
            ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
      print(secondsStr);
      recordertime = "$hoursStr:$minutesStr:$secondsStr";
    });
  }

//------
}

/*
/// Example app.
class AudioRecord extends StatefulWidget {
  AudioRecord({
    Key key,
    @required this.title,
    @required this.callback,
  }) : super(key: key);

  final String title;
  final Function callback;

  @override
  _AudioRecordState createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  final String _mPath = 'Recording${DateTime.now().millisecondsSinceEpoch}.aac';

  @override
  void initState() {
    _mPlayer = FlutterSoundPlayer();
    _mRecorder = new  FlutterSoundRecorder();
    _mPlayer.openAudioSession().then((value) {
      setStateIfMounted(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setStateIfMounted(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    _mRecorder.closeAudioSession();
    _mRecorder = null;
    stopWatchStream();
    super.dispose();
  }

  bool issinit = true;
  Future<void> openTheRecorder() async {
    if (!kIsWeb) {

      if (await Permission.microphone.request().isGranted) {
        // Fiberchat.showRationale(getTranslated(this.context, 'pm'));
        // openAppSettings();

      } else {
        await _mRecorder.openAudioSession();
        _mRecorderIsInited = true;
      }
    }
  }

  // ----------------------  Here is the code for recording and playback -------
  Timer timerr;
  void record() async {
    setStateIfMounted(() {
      recordertime = '00:00:00';
      hoursStr = '00';
      secondsStr = '00';
      hoursStr = '00';
      minutesStr = '00';
    });
    _mRecorder
        .startRecorder(
      codec: Codec.aacMP4,
      toFile: _mPath,
      //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
    )
        .then((value) {
      setStateIfMounted(() {
        status = 'recording';
        issinit = false;
      });
      startTimerNow();
    });
  }

  File recordedfile;
  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) async {
      setStateIfMounted(() {
        _mplaybackReady = true;
        status = 'recorded';
      });
      setStateIfMounted(() {
        recordedfile = File(value);
        recordertime = "$hoursStr:$minutesStr:$secondsStr";
      });

      setStateIfMounted(() {
        streamController.done;
        streamController.close();
        timerSubscription.cancel();
      });
    });
  }

  void play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    _mPlayer
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          setStateIfMounted(() {});
        })
        .then((value) {
      setStateIfMounted(() {
        // status = 'play';
      });
    });
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setStateIfMounted(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }
    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return null;
    }
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  String status = 'notrecording';

  Future<bool> onWillPopNEw() {
    return Future.value(issinit == true
        ? true
        : status == 'recorded'
        ? _mPlayer.isPlaying
        ? false
        : true
        : false);
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Center(
        child: isLoading == true
            ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF02ac88)))
            : Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            _mPlayer.isPlaying
                ? SizedBox(
              height: 223,
            )
                : Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(13),
              // height: 160,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(children: [
                // Text(
                //   _mRecorder!.isRecording
                //       ? getTranslated(this.context, 'recording')
                //       : recordertime == '00:00:00'
                //           ? ''
                //           : getTranslated(
                //               this.context, 'recorderstopped'),
                //   style: TextStyle(fontSize: 16, color: Colors.white),
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  _mRecorder.isRecording
                      ? "$hoursStr:$minutesStr:$secondsStr"
                      : recordertime,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color:  Colors.white,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                PlayButton(
                  pauseIcon: Icon(
                    Icons.stop,
                    color: Colors.red,
                    size: 60,
                  ),
                  playIcon:
                  Icon(Icons.mic, color: Colors.red, size: 70),
                  onPressed: getRecorderFn(),
                ),
                // RawMaterialButton(
                //   onPressed: getRecorderFn(),
                //   elevation: 2.0,
                //   fillColor:
                //       _mRecorder!.isRecording ? Colors.red : Colors.white,
                //   child: Icon(
                //     _mRecorder!.isRecording
                //         ? Icons.stop
                //         : Icons.mic_rounded,
                //     size: 75.0,
                //     color: _mRecorder!.isRecording
                //         ? Colors.white
                //         : Colors.red,
                //   ),
                //   padding: EdgeInsets.all(15.0),
                //   shape: CircleBorder(),
                // ),
              ]),
            ),
            status == 'recorded'
                ? Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(13),
              // height: 160,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(children: [
                Text(
                  _mPlayer.isPlaying
                      ? "Playing Recording"
                      : '',
                  style: TextStyle(
                    fontSize: 16,
                    color:  Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: getPlaybackFn(),
                  elevation: 2.0,
                  fillColor: _mPlayer.isPlaying
                      ? Colors.white
                      : Color(0xFF02ac88),
                  child: Icon(
                    _mPlayer.isPlaying
                        ? Icons.stop
                        : Icons.play_arrow,
                    size: 45.0,
                    color: _mPlayer.isPlaying
                        ? Colors.black
                        : Colors.white,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
              ]),
            )
                : SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            status == 'recorded'
                ? _mPlayer.isPlaying
                ? SizedBox()
            // ignore: deprecated_member_use
                : RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Color(0xFF02ac88))),
                elevation: 0.2,
                color: Color(0xFF02ac88),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                onPressed: () {
                  final observer = Provider.of<Observer>(
                      this.context,
                      listen: false);
                  if (recordedfile.lengthSync() / 1000000 >
                      observer.maxFileSizeAllowedInMB) {
                    CommonDialogUtil.showToastMsg(
                        context: context,
                        toastMsg:
                        'File should be less than - ${observer.maxFileSizeAllowedInMB}MB\n\nSelected File size is - ${(recordedfile.lengthSync() / 1000000).round()}MB');
                    // Fiberchat.toast(
                    //     '${getTranslated(this.context, 'maxfilesize')} ${observer.maxFileSizeAllowedInMB}MB\n\n${getTranslated(this.context, 'selectedfilesize')} ${(recordedfile!.lengthSync() / 1000000).round()}MB');
                  } else {
                    setStateIfMounted(() {
                      isLoading = true;
                    });
                    CommonDialogUtil.showToastMsg(
                        context: context,
                        toastMsg:
                        'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
                    // Fiberchat.toast('Sending Recording ... Please wait !');
                    widget
                        .callback(recordedfile)
                        .then((recordedUrl) {
                      Navigator.pop(context, recordedUrl);
                    });
                  }
                },
                child: Text(
                  'Send Recording',
                  style: TextStyle(
                      fontSize: 16, color: Colors.white),
                ))
                : SizedBox()
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: onWillPopNEw,
        child: Scaffold(
          backgroundColor: Color(0xFF01826b),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color:  Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF01826b),
            title: Text(
              widget.title,
              style: TextStyle(
                color:  Colors.white,
              ),
            ),
          ),
          body: makeBody(),
        ));
  }

  //------ Timer Widget Section Below:
  bool flag = true;
  Stream<int> timerStream;
  // ignore: cancel_subscriptions
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  String recordertime = '00:00:00';
  // ignore: close_sinks
  StreamController<int> streamController;
  Stream<int> stopWatchStream() {
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  startTimerNow() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setStateIfMounted(() {
        hoursStr =
            ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
      print(secondsStr);
    });
  }

//------
}*/
