import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/response/token_response.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.msg,
    required this.myInfo,
    required this.formattedDate,
  });

  final ChatMessage msg;
  final AsyncValue<TokenResponse> myInfo;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (msg.senderId != myInfo.value!.userId)
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: (msg.senderId == myInfo.value!.userId)
                  ? Colors.orange[200]
                  : Constants.secondaryBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: (msg.senderId != myInfo.value!.userId)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.imageUrl != null)
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.5),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SizedBox.expand(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: InteractiveViewer(
                                child: Image.network(
                                  msg.imageUrl!,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.withAlpha(125),
                                      height: 20,
                                      width: 20,
                                      child: Column(
                                        spacing: 8,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported,
                                            size: 32,
                                            semanticLabel:
                                                AppLocalizations.of(context)!
                                                    .failToLoadImage,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .failToLoadImage,
                                            style: TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.network(
                      msg.imageUrl!,
                      // width: 200,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: Colors.grey[200],
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.withAlpha(125),
                          width: double.infinity,
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 32,
                                semanticLabel: AppLocalizations.of(context)!
                                    .failToLoadImage,
                              ),
                              Text(
                                AppLocalizations.of(context)!.failToLoadImage,
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                Text(
                  msg.message,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (msg.isRead && msg.senderId == myInfo.value!.userId)
                      Icon(
                        Icons.remove_red_eye_rounded,
                        color: Colors.grey[700],
                        size: 14,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
