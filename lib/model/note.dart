class Note {
  int id = 0;
  String title = '';
  String content = '';
  String tag = '';

  Note(String title, String content,{String tag = '', int id = 0}){
    this.id = id;
    this.title = title;
    this.content = content;
    this.tag = tag;
  }

}