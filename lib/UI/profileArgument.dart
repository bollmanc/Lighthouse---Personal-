class profileArgument {
  String uid;
  String url;

  profileArgument(String id, String download) {
    this.uid=id;
    this.url=download;
  }

  String get() => this.uid;

}