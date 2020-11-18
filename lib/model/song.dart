class Song{
  String _name;
  String _aname;
  String _imgUrl;

  String get imgUrl => _imgUrl;

  set imgUrl(String value) {
    _imgUrl = value;
  }

  @override
  String toString() {
    return 'Song{_name: $_name, _aname: $_aname, _url: $_url}';
  }

  String _url;

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