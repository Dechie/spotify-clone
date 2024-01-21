import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/constants.dart';
import 'package:spotify_clone/homepage/widgets/horizontal_list.dart';
import 'package:spotify_clone/models/song_local.dart';
import 'package:spotify_clone/profile/upload_file.dart';
import 'package:spotify_clone/providers/song_provider.dart';
import 'package:spotify_clone/providers/song_upload.dart';

import '../models/user.dart';
import '../providers/the_auth.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with AfterLayoutMixin {
  var uploadProvider, authProvider;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    fetchUploaded();
  }

  @override
  void initState() {
    super.initState();
    uploadProvider = Provider.of<UploadProvider>(context, listen: false);
    authProvider = Provider.of<Auth>(context, listen: false);
  }

  String username = '', email = '';
  String password = '', passwordConfirm = '';

  final titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> sendFormData(BuildContext context, File uploadFile) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //Navigator.pop(context, user);
      //Provider.of<Auth>(context, listen: false).register(user);
      User user = authProvider.authedUser;
      await uploadProvider.uploadLocal(user, uploadFile);

      Navigator.pop(context);
    }
  }

  void onUploadLocal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadNewScreen(
          user: authProvider.authedUser,
        ),
      ),
    );
  }

  void fetchUploaded() async {
    if (uploadProvider.hasUploaded) {
      List<SongLocal> fetched = uploadProvider.uploadedSongs;
      localSongs = fetched;
      print(localSongs.length);
      setState(() {});
    }
  }

  List<SongLocal> localSongs = [],
      localSongsApproved = [],
      localSongsUnapproved = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onUploadLocal,
        child: const Icon(
          Icons.playlist_add,
          color: Colors.grey,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * .28,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 21, 147, 65),
                        const Color.fromARGB(255, 24, 169, 75).withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    //color: AppConstants.mainGreen,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        widget.user.name,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user.email,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 218, 218, 218)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<UploadProvider>(
                  builder: (context, uploadProvider, child) => uploadProvider
                          .hasUploaded
                      ? ListView(
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Your Works',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * .6,
                                child: ListView.separated(
                                  itemCount: localSongs.length,
                                  itemBuilder: (context, index) => Card(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                        tileColor: AppConstants.mainGreen
                                            .withOpacity(.5),
                                        title: Text(localSongs[index].title),
                                        subtitle: Text(
                                          localSongs[index].genre,
                                        ),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: SizedBox(
                            width: 400,
                            height: 120,
                            child: Column(
                              children: [
                                Text(
                                  'You have not uploaded anything yet.',
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Start Creating.",
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
