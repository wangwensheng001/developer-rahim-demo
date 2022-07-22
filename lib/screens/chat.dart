import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/painting.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'dart:async';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Chat extends StatefulWidget {
  Chat({
    Key key,
    this.conversation_id,
    this.messenger_name,
    this.messenger_title,
    this.messenger_image,
  }) : super(key: key);

  final int conversation_id;
  final String messenger_name;
  final String messenger_title;
  final String messenger_image;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatTextController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final ScrollController _xcrollController = ScrollController();
  final lastKey = GlobalKey();

  var uid = user_id;

  List<dynamic> _list = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;
  int _last_id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();
  }


  fetchData() async {
    var messageResponse = await ChatRepository().getMessageResponse(
        conversation_id: widget.conversation_id, page: _page);
    _list.addAll(messageResponse.messages);
    _isInitial = false;
    _totalData = messageResponse.meta.total;
    _showLoadingContainer = false;
    _last_id = _list[0].id;
    setState(() {});

    fetch_new_message();
  }

  reset() {
    _list.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    _last_id = 0;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPressLoadMore() {
    setState(() {
      _page++;
    });
    _showLoadingContainer = true;
    fetchData();
  }

  onTapSendMessage() async {
    var chatText = _chatTextController.text.toString();
    _chatTextController.clear();
    //print(chatText);
    if (chatText != "") {
      final DateTime now = DateTime.now();
      final intl.DateFormat date_formatter = intl.DateFormat('yyyy-MM-dd');
      final intl.DateFormat time_formatter = intl.DateFormat('hh:ss');
      final String formatted_date = date_formatter.format(now);
      final String formatted_time = time_formatter.format(now);

      var messageResponse = await ChatRepository().getInserMessageResponse(
          conversation_id: widget.conversation_id, message: chatText);
      _list = [
        messageResponse.messages,
        _list,
      ].expand((x) => x).toList(); //prepend
      _last_id = _list[0].id;
      setState(() {});

      _xcrollController.animateTo(
        _xcrollController.position.maxScrollExtent + 100,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  fetch_new_message() async {
    print('fetch new message hit');
    print('-------------');
    await Future.delayed(const Duration(seconds: 5), () {
      print('fetch new message start');
      print('##################');
      get_new_message();
    }).then((value) {
      print('again');
      fetch_new_message();
    });
  }

  get_new_message() async {
    var messageResponse = await ChatRepository().getNewMessageResponse(
        conversation_id: widget.conversation_id, last_message_id: _last_id);
    _list = [
      messageResponse.messages,
      _list,
    ].expand((x) => x).toList(); //prepend
    _last_id = _list[0].id;
    setState(() {});

    // if new message comes in
    if( messageResponse.messages.length > 0){
      _xcrollController.animateTo(
        _xcrollController.position.maxScrollExtent + 100,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              CustomScrollView(
                controller: _xcrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 36,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context).home_screen_featured_categories,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressLoadMore();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildChatList(),
                      ),
                      Container(
                        height: 80,
                      )
                    ]),
                  )
                ],
              ),
              Align(alignment: Alignment.center, child: buildLoadingContainer()),
              //original
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.white54.withOpacity(0.6)),
                      height: 80,
                      //color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                        child: buildMessageSendingRow(context),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _list.length
            ? AppLocalizations.of(context).common_no_more_items
            : AppLocalizations.of(context).common_loading_more_items),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
      toolbarHeight: 75,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        child: Container(
            width: 350,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                          color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                      //shape: BoxShape.rectangle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: AppConfig.BASE_PATH + widget.messenger_image,
                          fit: BoxFit.contain,
                        )),
                  ),
                  Container(
                    width: 220,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.messenger_name,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.messenger_title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                              fontSize: 12,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      _onRefresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.rotate_left,
                        color: MyTheme.font_grey,
                      ),
                    ),
                  )
                ])),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildChatList() {
    if (_isInitial && _list.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 10, item_height: 100.0));
    } else if (_list.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          key: lastKey,
          controller: _chatScrollController,
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildChatItem(index),
            );
          },
        ),
      );
    } else if (_totalData == 0) {
      return Center(child: Text(AppLocalizations.of(context).common_no_data_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildChatItem(index) {
    return _list[index].user_id == uid
        ? getSenderView(ChatBubbleClipper5(type: BubbleType.sendBubble),
            context, _list[index].message, _list[index].date, _list[index].time)
        : getReceiverView(
            ChatBubbleClipper5(type: BubbleType.receiverBubble),
            context,
            _list[index].message,
            _list[index].date,
            _list[index].time);
  }

  Row buildMessageSendingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 40,
          width: (MediaQuery.of(context).size.width - 32) * (4 / 5),
          child: TextField(
            autofocus: false,
            maxLines: null,
            controller: _chatTextController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(251, 251, 251, 1),
                hintText: AppLocalizations.of(context).chat_screen_type_message_here,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(35.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(35.0),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              onTapSendMessage();
            },
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              decoration: BoxDecoration(
                color: MyTheme.accent_color,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                //shape: BoxShape.rectangle,
              ),
              child: Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getSenderView(
          CustomClipper clipper, BuildContext context, text, date, time) =>
      ChatBubble(
        elevation: 0.0,
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 10),
        backGroundColor: MyTheme.soft_accent_color,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            minWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontSize: 13, wordSpacing: 1),
                ),
              ),
              Text(date + " " + time,
                  style: TextStyle(color: MyTheme.medium_grey, fontSize: 10)),
            ],
          ),
        ),
      );

  getReceiverView(
          CustomClipper clipper, BuildContext context, text, date, time) =>
      ChatBubble(
        elevation: 0.0,
        clipper: clipper,
        backGroundColor: Color.fromRGBO(239, 239, 239, 1),
        margin: EdgeInsets.only(top: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            minWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontSize: 13, wordSpacing: 1),
                ),
              ),
              Text(date + " " + time,
                  style: TextStyle(color: MyTheme.medium_grey, fontSize: 10)),
            ],
          ),
        ),
      );
}
