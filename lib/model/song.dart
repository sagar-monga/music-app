class Song{
  String _name;

  @override
  String toString() {
    return 'Song{_name: $_name, _aname: $_aname, _imgUrl: $_imgUrl, _albumArt: $_albumArt, _url: $_url}';
  }

  String _aname;
  String _imgUrl;
  String _albumArt;
  String _url;

  String get albumArt => _albumArt;

  set albumArt(String value) {
    _albumArt = value;
  }

  String get imgUrl => _imgUrl;

  set imgUrl(String value) {
    _imgUrl = value;
  }


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get aname => _aname;

  set aname(String value) {
    _aname = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}