class TopicTabMode {
  bool accountTopic;
  bool publicTopic;
  bool multiSelect;
  bool scrollable;
  String? folderId;

  TopicTabMode({
    this.scrollable = true,
    this.accountTopic = false,
    this.publicTopic = false,
    this.multiSelect = false,
    this.folderId,
  });
}
