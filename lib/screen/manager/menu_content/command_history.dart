// ignore_for_file: dead_code, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, no_logic_in_create_state,, must_be_immutable, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supply_app/common/constants.dart';
import 'package:supply_app/models/Database_Model.dart';
import 'package:supply_app/screen/manager/menu_content/List_command.dart';
import 'package:supply_app/services/command_service.dart';
import 'package:supply_app/services/storage_service.dart';
import 'package:supply_app/services/user_service.dart';

class CommandListe extends StatefulWidget {
  String currentManagerID;
  CommandListe({required this.currentManagerID, Key? key}) : super(key: key);
  @override
  _CommandListeState createState() => _CommandListeState();
}

class _CommandListeState extends State<CommandListe> {
//les controleurs des champs date
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputfinal = TextEditingController();
  List<CommandModel> Commands = [];
  List<CommandModel> termine = [];
  List<CommandModel> encours = [];
  List<CommandModel> enattente = [];
  UserModel deliver = new UserModel(name: 'fabiol');
  UserModel currentManager = new UserModel(name: 'fabiol');
  // CommandModel co = CommandModel(createdBy: createdBy, nameCommand: nameCommand, description: description, statut: statut, state: state, startPoint: startPoint, updatedAt: updatedAt,.updatedAt:.updatedAt)

  //UserModel? exampleModel = new UserModel(name: 'fabiol');
  CommandService ServiceCommand = new CommandService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Storage storage = Storage();
//vider les controller
  @override
  void dispose() {
    dateinput.dispose();
    dateinputfinal.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCommandDeliver();
    getCurrentManager();
    getcommandEnd() ;
    getCommandeon();
    getcommandsIN();
    dateinput.text = ""; //set the initial value of text field
    dateinputfinal.text = '';
    super.initState();
  }

  getCurrentManager() async {
    await UserService().getUserbyId(widget.currentManagerID).then((value) {
      setState(() {
        currentManager = value;
        print('currrent user $currentManager');
      });
    });
  }

  getCommandDeliver() async {
    await ServiceCommand.getCommandsManager(widget.currentManagerID)
        .forEach((element) async {
      print('currrent manager Id${widget.currentManagerID}');

      print("elementttttttttttttttttttttttttttttt   $element");
      setState(() {
        this.Commands = element;
      });
    });
  }

  getCommandeon() async {
    await CommandService()
        .getCommandsManagerstatut(widget.currentManagerID, "en attente")
        .forEach((element) async {
      print("eattnteteaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa   $element");
      setState(() {
        this.enattente = element;
      });
    });
  }

  getcommandEnd() async {
    await CommandService()
        .getCommandsManagerstatut(widget.currentManagerID, "termine")
        .forEach((element) async {
      print("fffffffffffffffffffffffffffffffffffffffffffffff   $element");
      setState(() {
        termine = element;
      });
    });
  }

  getcommandsIN() async {
    await CommandService()
        .getCommandsManagerstatut(widget.currentManagerID, "en cours")
        .forEach((element) async {
      print("ccccccccccccccccccccccccccccccccccc   $element");
      setState(() {
        this.encours = element;
      });
    });
  }

//compare les dates afin de triet la liste de commandes par date
  int dateCompare(DateTime d1, DateTime d2) {
    var isrecent;
    if (d1.isBefore(d2)) {
      isrecent = -1;
    } else {
      isrecent = 1;
    }

    return isrecent;
  }

  @override
  Widget build(BuildContext context) {
    List<CommandModel> sortedcommands = (Commands)
      ..sort((item1, item2) => dateCompare(
          DateTime.parse(item2.updatedAt), DateTime.parse(item1.updatedAt)));

    List<CommandModel> sortedenattente = enattente
      ..sort((item1, item2) => dateCompare(
          DateTime.parse(item2.updatedAt), DateTime.parse(item1.updatedAt)));

    List<CommandModel> sortedencours = encours
      ..sort((item1, item2) => dateCompare(
          DateTime.parse(item2.updatedAt), DateTime.parse(item1.updatedAt)));

    List<CommandModel> sortedtermine = termine
      ..sort((item1, item2) => dateCompare(
          DateTime.parse(item2.updatedAt), DateTime.parse(item1.updatedAt)));
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: buildAppBar(),
            body: TabBarView(
              children: [
                ListCommand(
                  deliver: deliver,
                  Commands: (sortedcommands),
                  manager: currentManager,
                ),
                ListCommand(
                  deliver: deliver,
                  Commands: sortedenattente,
                  manager: currentManager,
                ),
                ListCommand(
                  deliver: deliver,
                  Commands: sortedencours,
                  manager: currentManager,
                ),
                ListCommand(
                    deliver: deliver,
                    Commands: sortedtermine,
                    manager: currentManager),
              ],
            )));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Text(
        'Historique des commandes',
        style: GoogleFonts.philosopher(fontSize: 20),
      ),
      bottom: TabBar(tabs: [
        Tab(
          text: 'Tous'.toUpperCase(),
          icon: Icon(Icons.all_inbox),
        ),
        Tab(
          text: 'Att.'.toUpperCase(),
          icon: Icon(Icons.question_mark),
        ),
        Tab(
          text: 'Cours'.toUpperCase(),
          icon: Icon(Icons.car_rental),
        ),
        Tab(
          text: 'Term.'.toUpperCase(),
          icon: Icon(Icons.done),
        ),
      ]),

      //centerTitle: true,
      //leading: IconButton(onPressed: () {}, icon: Icon(Icons.update)),
    );
  }
}
