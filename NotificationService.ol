include "console.iol"
include "/protocols/http.iol"

type NotificationRequest: void {
    userId: string
    message: string
    preference: string
}

type NotificationResponse: void {
    status: string
}

interface NotificationInterface {
    RequestResponse:
    sendNotification(NotificationRequest)(NotificationResponse),
    modifyPreference(NotificationRequest)(NotificationResponse)
}

inputPort NotificationPort {
    location: "socket://localhost:1236"
    protocol: http
    interfaces: NotificationInterface
}

main {
    sendNotification(req)(res) {
        // Send notification logic
        println@Console("User notification preference: " + req.preference)()
        println@Console("Notification sent to user " + req.userId + ": " + req.message)()
        res.status = "Notification sent"
    }

    modifyPreference(req)(res) {
        // Modify preference logic
        println@Console("User " + req.userId + " preference modified to: " + req.preference)()
        res.status = "Preference modified"
    }
}
