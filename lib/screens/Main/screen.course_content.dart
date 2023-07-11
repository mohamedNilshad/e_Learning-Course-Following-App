import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/entities/course.entity.dart';
import 'package:course_mate/entities/get_contents.entity.dart';
import 'package:course_mate/entities/video.entity.dart';
import 'package:course_mate/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class CourseContent extends StatefulWidget {
  final ncID;
  const CourseContent(this.ncID, {Key? key}) : super(key: key);

  @override
  State<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  bool _playArea = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;
  bool _btnPrvDisabled = false;
  bool _btnNxtDisabled = false;

  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  List videos = [
    {
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    },
    {
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    },
    {
      'url':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
  ];

  String _cThumb = '';
  String publicPath = '';
  bool isLoading = true;
  bool isVThumbLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiCallCourse();
    _apiCallContent();
    // debugPrint('initializing test');
  }

  List<Course> course = [];
  List<Video> content = [];

  //fetch course details
  Future _apiCallCourse() async {
    http.Response courseRes;

    courseRes = await http.get(Uri.parse("${fullURL}getCourse/${widget.ncID}"));
    if (courseRes.statusCode == 200) {
      setState(() {
        var response = json.decode(courseRes.body);
        var res = response?['data'] ?? [];
        course = res.map<Course>((v) => Course.fromJson(v)).toList();
        //public path
        publicPath = response?['publicPath'];
        _cThumb = publicPath + course[0].courseThumbnail.toString();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  GetContents? getContents;

  //fetch video details
  Future _apiCallContent() async {
    http.Response contentRes;

    contentRes =
        await http.get(Uri.parse("${fullURL}getAllContents/${widget.ncID}"));
    if (contentRes.statusCode == 200) {
      setState(() {
        var vResponse = json.decode(contentRes.body);
        var data = vResponse?['data'];

        // getContents = data.map<GetContents>((v) => GetContents.fromJson(v)).toList();

        getContents = GetContents.fromJson(data);
        // debugPrint(getContents?.docs.toString());
        // videos = getContents!.video;
        // debugPrint(content.toString());
        isVThumbLoading = false;
      });
    } else {
      setState(() {
        isVThumbLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    _chewieController?.dispose();
    _chewieController?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
        backgroundColor: primaryColor,
      ),
      body: Visibility(
        visible: !isVThumbLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Column(
          children: [
            _playArea == false
                ? Container(
                    height: 250,
                    child: CachedNetworkImage(
                      width: double.infinity, // Specify the desired width
                      alignment: Alignment.topCenter,
                      imageUrl: _cThumb.isNotEmpty
                          ? _cThumb
                          : 'https://st4.depositphotos.com/17828278/24401/v/600/depositphotos_244011872-stock-illustration-image-vector-symbol-missing-available.jpg', //'http://192.168.8.140:8000/images/thumb/1685332924.jpg',

                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )

                : Container(
                    child: Column(
                      children: [
                        _playView(context),
                        _controlView(context),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  itemCount: getContents?.video.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        _isPlayingIndex = index;

                        if (index > 0) {
                          _btnPrvDisabled = false;
                        } else {
                          _btnPrvDisabled = true;
                        }

                        if (index < getContents!.video.length - 1) {
                          _btnNxtDisabled = false;
                        } else {
                          _btnNxtDisabled = true;
                        }
                        _onTapVideo(index);
                        setState(() {
                          if (!_playArea) {
                            _playArea = true;
                          }
                        });
                      },
                      child: SizedBox(
                        height: 135,
                        child: Column(
                          children: [
                            Row(
                              children: [
                               Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image:  DecorationImage(
                                        image:
                                        NetworkImage(
                                          // 'https://images.pexels.com/photos/296282/pexels-photo-296282.jpeg?auto=compress&cs=tinysrgb&w=600',
                                            publicPath+(getContents?.video[index].videoThumbUrl).toString()
                                          // publicPath+content[index].videoThumbUrl.toString(),
                                        //'${publicPath}images/thumb/defaultThumb1.png',
                                        ),

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // 'Test Video $index',
                                (getContents?.video[index].videoTitle).toString(),
                                      // content[index].videoTitle.toString(),

                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      '15.00',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlView(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      // color: Colors.black45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              final index = _isPlayingIndex - 1;
              if (index >= 0) {
                _onTapVideo(index);
              }

              if (index > 0) {
                _btnPrvDisabled = false;
              } else {
                _btnPrvDisabled = true;
              }

              if (index < getContents!.video.length - 1) {
                _btnNxtDisabled = false;
              } else {
                _btnNxtDisabled = true;
              }
            },
            child: Icon(
              Icons.arrow_circle_left_rounded,
              size: 50,
              color: _btnPrvDisabled ? Colors.grey : Colors.lightBlueAccent,
            ),
          ),
          TextButton(
            onPressed: () async {
              final index = _isPlayingIndex + 1;

              if (index < getContents!.video.length) {
                _onTapVideo(index);
              }
              if (index < getContents!.video.length - 1) {
                _btnNxtDisabled = false;
              } else {
                _btnNxtDisabled = true;
              }

              if (index > 0) {
                _btnPrvDisabled = false;
              } else {
                _btnPrvDisabled = true;
              }
            },
            child: Icon(
              Icons.arrow_circle_right_rounded,
              size: 50,
              color: _btnNxtDisabled ? Colors.grey : Colors.lightBlueAccent,
            ),
          )
        ],
      ),
    );
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
          aspectRatio: 16 / 9,
          child:
              Chewie(controller: _chewieController!) //VideoPlayer(controller),
          );
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: CircularProgressIndicator(), //Text('Processing'),
        ),
      );
    }
  }

  var _onUpdateControllerTime;
  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }

    _onUpdateControllerTime = 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }
    _onUpdateControllerTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      debugPrint("Controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("Controller cant br initialized");
      return;
    }
  }

  _onTapVideo(int index) async {
    // debugPrint(publicPath + content[index].videoUrl.toString());
    final old = _controller;

    try {
      final controller = VideoPlayerController.network(
        // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        // 'https://192.168.8.140:8000/${content[index].videoUrl}',
        publicPath + (getContents?.video[index].videoUrl).toString(),
          // (getContents?.video[index].videoThumbUrl).toString()
        // 'https://firebasestorage.googleapis.com/v0/b/testvideo-a5e31.appspot.com/o/Code_flythough_loop_01_Videvo_preview.mp4?alt=media&token=420be7cb-4323-4f27-b771-ab5f491637bd',
      );

      _controller = controller;
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: true,
      );

      if (old != null) {
        old.removeListener(_onControllerUpdate);
        old.pause();
      }

      setState(() {});
      controller.initialize().then((_) {
        old?.dispose();
        _isPlayingIndex = index;
        controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
      });
    } catch (e) {
      // debugPrint(e.toString());
    }
    // publicPath + content[index]['video_url'].toString();
  }
}
