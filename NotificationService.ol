include "console.iol"
include "http.iol"

type NotificationRequest: void {
    .userId: string,
    .message: string
}

type NotificationResponse: void {
    .status: string
}

interface NotificationInterface {
    OneWay: sendNotification(NotificationRequest)
}

inputPort NotificationPort {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

main {
    sendNotification(req) {
        // Send notification logic (simplified)
        Console.log@println("Notification sent to user " + req.userId + ": " + req.message)()
    }
}
