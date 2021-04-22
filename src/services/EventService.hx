package services;

class EventService {
    static var subscriptions: Map<String, Dynamic> = new Map<String, Dynamic>();

    public static function subscribe(eventName, callback) {
        if (subscriptions.exists(eventName)) {
            subscriptions.get(eventName).push(callback);
        }
        else {
            subscriptions.set(eventName, [callback]);
        }
    }

    public static function notify(eventName: String, data: Dynamic) {
        var callbackList = subscriptions[eventName];
        if (callbackList.length > 0) {
            for (i in 0...callbackList.length) {
                callbackList[i](data);
            }
        }
    }
}