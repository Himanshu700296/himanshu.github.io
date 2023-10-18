import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWithAvatarMarker extends StatefulWidget {
  GoogleMapWithAvatarMarker({Key? key}) : super.key(key);

  @override
  State<GoogleMapWithAvatarMarker> get createState => _GoogleMapWithAvatarMarkerState();
}

class _GoogleMapWithAvatarMarkerState extends State<GoogleMapWithAvatarMarker> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkerImage();
  }

  Future<void> _createMarkerImage() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.blue;
    final radius = 20.0;

    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(radius.toInt() * 2, radius.toInt() * 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    final bitmapDescriptor = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('avatarMarker'),
        position: LatLng(0, 0),
        icon: bitmapDescriptor,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 200,
                child: Center(child: Text('User Information')),
              );
            },
          );
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
        zoom: 12,
      ),
      markers: _markers,
    );
  }
}