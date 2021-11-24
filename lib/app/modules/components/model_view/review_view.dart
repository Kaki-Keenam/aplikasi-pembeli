
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:intl/intl.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({
    Key? key,
    this.review,
  }) : super(key: key);

  final Review? review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        child: review?.buyerImage != null ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: "${review?.buyerImage}",
            fit: BoxFit.cover,
            placeholder: (context, url) => Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(),
            ),
          ),
        ) : Container(),
      ),
      title: Text('${review?.buyerName}'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              initialRating: review?.rating ?? 0.0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 10,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(height: 3,),
            Text(DateFormat('EEE, d MMM yyyy').format(
                DateTime.parse(review?.time ?? ""),), style: TextStyle(fontSize: 10),)
          ],
        ),
      ),
    );
  }
}
