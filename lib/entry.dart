class Entry {
  int id;
  String domainName;
  String ipAddress = '192.168.11.20';
  String hostName = 'Frans_iP11pMx';
  String dateTime = '13:04 EDT';
  String macAddress = '80:32:04:5b:7a:c3';
  bool isBlocked;

  Entry(this.id, this.domainName, this.isBlocked);
}
