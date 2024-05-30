import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mingle/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/model/ticket_model.dart';
import '../../utils/datetime_utils.dart';

class TicketPageDialog extends StatelessWidget {
  final Ticket ticket;

  const TicketPageDialog({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double qrSize = screenSize.width * 0.30;

    return Dialog(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: kAccentColor,
            width: 2.0,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenSize.width * 0.15,
                    height: screenSize.width * 0.15,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      iconSize: screenSize.width * 0.07,
                      color: kAccentColor,
                      onPressed: () async {
                        try {
                          RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
                          ui.Image image = await boundary.toImage();
                          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                          Uint8List pngBytes = byteData!.buffer.asUint8List();
                          final result = await ImageGallerySaver.saveImage(pngBytes);
                          if (kDebugMode) {
                            print('Image saved to gallery: $result');
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print('Error saving image: $e');
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.15,
                    height: screenSize.width * 0.15,
                    child: IconButton(
                      icon: const Icon(Icons.close_outlined),
                      iconSize: screenSize.width * 0.07,
                      color: kAccentColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              _ticketInfo("Ticket Id", ticket.eventId, screenSize),
              SizedBox(
                width: screenSize.width,
                height: qrSize,
                child: Center(
                  child: QrImageView(
                    data: ticket.eventId,
                    version: QrVersions.auto,
                    size: qrSize,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ticketInfo("Event Name", ticket.eventName, screenSize),
                  _ticketInfo("Event Location", ticket.eventLocation, screenSize),
                  _ticketInfo("Event Date", DateTimeUtils.getFullDate(ticket.eventDate), screenSize),
                  _ticketInfo("Event Price", '\$${ticket.eventPrice}', screenSize),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketInfo(String title, dynamic value, Size screenSize) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: screenSize.width * 0.04, color: kAccentColor),
      ),
      SizedBox(height: screenSize.height * 0.005),
      Text(
        value.toString(),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenSize.width * 0.045),
      ),
      SizedBox(height: screenSize.height * 0.015),
      const Divider(color: kColorPrimaryVariant, thickness: 1.0),
      SizedBox(height: screenSize.height * 0.015),
    ],
  );
}
