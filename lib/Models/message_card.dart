import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/Models/message.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

class MessageCard extends StatefulWidget {
  final Message message;
  final ChatUser user;

  const MessageCard({super.key, required this.message, required this.user});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = FirebaseAuth.instance.currentUser!.email != widget.message.told;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _myMessage(context) : _yourMessage(context),
    );
  }

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }

  //---------------------------------------------------------------->>>>>>>>>>>> Your Message
  Widget _yourMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    //Update last message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      FirebaseFirestore.instance
          .collection(
              'chats/${getChatId(widget.user.email, FirebaseAuth.instance.currentUser!.email!)}/messages/')
          .doc(widget.message.sent)
          .update(
        {
          'read': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
    }

    // Parse the sent time
    // DateTime sentTime =
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent));

    // Format the time
    // String formattedTime = DateFormat('HH:mm a').format(sentTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                widget.message.type == Type.text ? mq.width * 0.02 : 0),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(223, 202, 232, 206),
              border: Border.all(color: Colors.green),
              borderRadius: widget.message.type == Type.text
                  ? BorderRadius.only(
                      topLeft: Radius.circular(mq.width * 0.05),
                      topRight: Radius.circular(mq.width * 0.05),
                      bottomRight: Radius.circular(mq.width * 0.05))
                  : BorderRadius.circular(mq.width * 0.043),
            ),

            //__________________________________________________________________ Text

            child: widget.message.type == Type.text
                ?
                //Show Text
                Text(
                    widget.message.msg,
                    style: GoogleFonts.acme(fontSize: mq.width * 0.045),
                  )
                :
                //Show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(mq.width * 0.04),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        //______________________________________________________________________ Send Time

        Padding(
          padding:
              EdgeInsets.only(right: mq.width * 0.04, top: mq.width * 0.04),
          child: Text(
            // formattedTime,
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: GoogleFonts.adamina(
                fontSize: mq.width * 0.03, color: Colors.black45),
          ),
        )
      ],
    );
  }

  //-------------------------------------------------------------->>>>>>>>>>>>>> MY Message
  Widget _myMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    // Parse the sent time
    // DateTime sentTime =
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent));

    // Format the time
    // String formattedTime = DateFormat('HH:mm a').format(sentTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            //For Adding some space
            SizedBox(width: mq.width * 0.04),

            //__________________________________________________________________Read Time

            Padding(
              padding: EdgeInsets.only(top: mq.width * 0.04),
              child: Text(
                // formattedTime,
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: GoogleFonts.adamina(
                    fontSize: mq.width * 0.03, color: Colors.black45),
              ),
            ),

            //For Adding some space
            SizedBox(width: mq.width * 0.01),

            //__________________________________________________________________Double tik button icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blueAccent,
              ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                widget.message.type == Type.text ? mq.width * 0.025 : 0),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(210, 228, 245, 1.0),
              border: Border.all(color: Colors.blueGrey),
              borderRadius: widget.message.type == Type.text
                  ? BorderRadius.only(
                      topLeft: Radius.circular(mq.width * 0.05),
                      topRight: Radius.circular(mq.width * 0.05),
                      bottomLeft: Radius.circular(mq.width * 0.05))
                  : BorderRadius.circular(mq.width * 0.043),
            ),

            //__________________________________________________________________ Text
            child: widget.message.type == Type.text
                ?
                //Show Text
                Text(
                    widget.message.msg,
                    style: GoogleFonts.acme(fontSize: mq.width * 0.045),
                  )
                :
                //Show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(mq.width * 0.04),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //____________________________________________________________________________Show bottom sheet

  void _showBottomSheet(bool isMe) {
    final mq = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black54,
      shape: const ContinuousRectangleBorder(),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            // Container for upper line
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * 0.015, horizontal: mq.width * 0.4),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15)),
            ),

            widget.message.type == Type.text
                ?

                // _____________________________________________________________________________Copy option
                _OptionItem(
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then((value) {
                        //For Hiding Bottom Sheet
                        Navigator.pop(context);

                        Dialogs.showSnackbar(context, 'Text Copied!');
                      });
                    },
                  )
                :
                //_________________________________________________________________________Save option
                _OptionItem(
                    icon: const Icon(
                      Icons.cloud_download_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Save',
                    onTap: () async {
                      try {
                        //For Hiding Bottom Sheet
                        Navigator.pop(context);

                        // Download the image
                        var response =
                            await http.get(Uri.parse(widget.message.msg));

                        if (response.statusCode == 200) {
                          // Save the image to the gallery
                          await ImageGallerySaver.saveImage(
                              Uint8List.fromList(response.bodyBytes));

                          Dialogs.showSnackbar(context, 'Saved image!');
                        } else {
                          print(
                              "Error downloading image: ${response.statusCode}");
                        }
                      } catch (e) {
                        print("Error saving image: $e");
                      }
                    },
                  ),

            //Divider
            if (isMe)
              Divider(
                color: Colors.white30,
                endIndent: mq.width * 0.04,
                indent: mq.width * 0.04,
              ),

            // _______________________________________________________________________Edit option
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 26,
                ),
                name: 'Edit Message',
                onTap: () {
                  //For hiding bottom sheet
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                },
              ),

            // Delete option
            if (isMe)
              _OptionItem(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 26,
                ),
                name: 'Delete Message',
                onTap: () async {
                  await API
                      .deleteMessage(widget.message, widget.user.email,
                          FirebaseAuth.instance.currentUser!.email!)
                      .then((value) {
                    //For hiding bottom sheet
                    Navigator.pop(context);
                  });
                },
              ),

            //Divider
            Divider(
              color: Colors.white30,
              endIndent: mq.width * 0.04,
              indent: mq.width * 0.04,
            ),

            // _______________________________________________________________________________________________Sent time
            _OptionItem(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
                size: 26,
              ),
              name:
                  'Sent At: ${MyDateUtil.getLastMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),

            //________________________________________________________________________________________________Read time
            _OptionItem(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.green,
                size: 26,
              ),
              name: widget.message.read.isEmpty
                  ? 'Read At: Not seen yet'
                  : 'Read At: ${MyDateUtil.getLastMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  // Dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // contentPadding: EdgeInsets.only(left: 24,bottom: 10),
        backgroundColor: Colors.black54,
        //Title
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text(
              ' Update Message',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),

        //Content
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          style: const TextStyle(color: Colors.white70),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        //Actions
        actions: [
          MaterialButton(
            onPressed: () {
              // Hide Alert dialog
              Navigator.pop(context);
            },
            child: const Text(
              'Cancle',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () {
              // Hide Alert dialog
              Navigator.pop(context);
              API.updateMessage(widget.message, updatedMsg, widget.user.email,
                  FirebaseAuth.instance.currentUser!.email!);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding:
            EdgeInsets.only(left: mq.width * 0.05, bottom: mq.height * 0.015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '   $name',
              style: const TextStyle(color: Colors.white70),
            ))
          ],
        ),
      ),
    );
  }
}
