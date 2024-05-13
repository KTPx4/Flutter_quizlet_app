import 'package:client_app/values/topic.dart';

class folder {
  final int id;
  final String folderName;
  final List<Topic> topics;
  final String accountID;
  final DateTime createdDate = DateTime.now();

  folder({
    required this.id,
    required this.folderName,
    required this.topics,
    required this.accountID,
  });
}

// list of folder

List<folder> folderList = [
  folder(id: 1, folderName: "Folder 1", topics: topicList, accountID: '1'),
  folder(id: 2, folderName: "Folder 2", topics: topicList, accountID: '2'),
  folder(id: 3, folderName: "Folder 3", topics: topicList, accountID: '1'),
  folder(id: 4, folderName: "Folder 4", topics: topicList, accountID: '2'),
  folder(id: 5, folderName: "Folder 5", topics: topicList, accountID: '2'),
];
