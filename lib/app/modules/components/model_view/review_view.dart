
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({
    Key? key,
    this.review,
  }) : super(key: key);

  final Review? review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      ),
      title: Text('${review?.buyerName}'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: RatingBar.builder(
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
      ),
    );
  }
}
