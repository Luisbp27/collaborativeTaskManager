include "console.iol"
include "/protocols/http.iol"

type NotificationRequest: void {
    userId: string
    message: string
}

type NotificationResponse: void {
    status: string
}

type Notification: void {
    userId: string
    message: string
}

type Notifications: void {
    notification*: Notification
}

service NotificationService() {

    execution: concurrent

    inputPort NotificationPort {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    main {
        i = 0
        sendNotification(req)(res) {
            notifications.userId[i] = req.userId
            notifications.message[i] = req.message
            i = i + 1

            // Send notification to user
            println@Console("Notification sent to user " + req.userId + ": " + req.message)()
            res.message = "Notification sent"
        }

        notificationsHistorialByUser(req)(res) {
            println@Console("Showing notifications for user " + req.userId)()
            println@Console( " " )()

            for (j = 0, j < i, j++) {
                if (notifications.userId[j] == req.userId) {
                    println@Console("Notification Nº" + j + ": " + notifications.message[j])()
                }
            }
        }

        deleteAllNotificationsByUser(req)(res) {
            println@Console("Deleting all notifications for user " + req.userId)()
            println@Console( " " )()

            for (j = 0, j < i, j++) {
                if (notifications.userId[j] == req.userId) {
                    notifications.userId[j] = ""
                    notifications.message[j] = ""
                }
            }

            res.message = "Notifications deleted"
        }
    }
}