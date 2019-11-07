import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/common/resources/t_colors.dart';
import 'package:flutter_template/common/resources/t_text_styles.dart';
import 'package:flutter_template/flutter_template.dart';

class UserScreen extends StatelessWidget {
  final MainAppBloc bloc;

  const UserScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 255, 246, 183),
                Color.fromARGB(255, 246, 65, 108),
              ],
              stops: <double>[0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'List user',
              style: TTextStyles.black(fontSize: 16, color: TColors.white),
            ),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TColors.green),
                  ),
                );
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (_, int index) => UserItemWidget(
                    documentSnapshot: snapshot.data.documents[index],
                    onTap: _onTap,
                  ),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ),
      
      ],
    );
  }

  void _onTap(DocumentSnapshot documentSnapshot) {}
}

class UserItemWidget extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final void Function(DocumentSnapshot documentSnapshot) onTap;

  const UserItemWidget({Key key, this.documentSnapshot, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null ? onTap(documentSnapshot) : null,
      child: Card(
        child: Container(
          height: 80,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(documentSnapshot.data['photoUrl']),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                documentSnapshot.data['nickname'],
                style: TTextStyles.bold(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
