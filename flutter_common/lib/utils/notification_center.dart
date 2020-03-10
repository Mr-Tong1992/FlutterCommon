
typedef GetObject = Function(dynamic object);

class NotificationCenter {

  //创建Map来记录名称
  Map<String, GetObject> notificationNameMap = Map<String, GetObject>();



  //添加监听者方法
  addObserver(String postName, object(dynamic object)) {
    notificationNameMap[postName] = object;
  }

  //发送通知传值
  postNotification(String postName, dynamic object) {
    //检索Map是否含有postName
    if (notificationNameMap.containsKey(postName)) {
      notificationNameMap[postName](object);
    }
  }

  //移除通知
  removeNotification(String postName) {
    if (notificationNameMap.containsKey(postName)) {
      notificationNameMap.remove(postName);
    }
  }

  // 工厂模式
  factory NotificationCenter() => _getInstance();

  static NotificationCenter get instance => _getInstance();
  static NotificationCenter _instance;

  NotificationCenter._internal() {
    // 初始化
  }

  static NotificationCenter _getInstance() {
    if (_instance == null) {
      _instance = new NotificationCenter._internal();
    }
    return _instance;
  }

}