include "console.iol"
include "/protocols/http.iol"

type NotificationRequest: void {
    userId: string
    message: string
}

type NotificationResponse: void {
    status: string
}

interface NotificationInterface {
    RequestResponse:
    sendNotification(NotificationRequest)(NotificationResponse),
}

inputPort NotificationPort {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

main {
    i = 0
    sendNotification(req)(res) {

        NotificationRequest.userId[i] = req.userId
        NotificationRequest.message[i] = req.message
        i = i + 1

        // Send notification to user
        println@Console("Notification sent to user " + req.userId + ": " + req.message)()
        res.status = "Notification sent"
    }
}
