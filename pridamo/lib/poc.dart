import 'package:flutter/material.dart';
import 'package:pridamo/log_status_and_updates/login_status.dart';
import 'package:pridamo/userpages/check_particular_post_and_push_on_page.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return login_status();
        } else {
          Navigator.pop(context);
          return check_particular_post_and_push_on_page(snapshotdata: snapshot.data);
        }
      },
    );
  }
}
