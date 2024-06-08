include "console.iol"
include "/protocols/http.iol"
include "interfaces/interfaces.iol"
include "interfaces/objects.iol"

service NotificationService() {

    execution: concurrent

    inputPort NotificationPort {
        location: "socket://localhost:1236"
        protocol: http
        interfaces: NotificationInterface
    }

    init {
        global.not_iter = 0
    }

    main {
        [sendNotification(req)(res) {
            synchronized( token ) {
                notifications.userId[global.not_iter] = req.userId
                notifications.message[global.not_iter] = req.message
                global.not_iter++

                // Send notification to user
                println@Console("Notification sent to user " + req.userId + ": " + req.message)()
                res.message = "Notification sent"
            }
        }]

        [notificationsHistorialByUser(req)(res) {
            synchronized( token ) {
                println@Console("Showing notifications for user " + req.userId)()
                println@Console( " " )()

                for (j = 0, j < global.not_iter, j++) {
                    if (notifications.userId[j] == req.userId) {
                        println@Console("Notification Nº" + j + ": " + notifications.message[j])()
                    }
                }
            }
        }]

        [deleteAllNotificationsByUser(req)(res) {
            synchronized( token ) {
                println@Console("Deleting all notifications for user " + req.userId)()
                println@Console( " " )()

                for (j = 0, j < global.not_iter, j++) {
                    if (notifications.userId[j] == req.userId) {
                        notifications.userId[j] = ""
                        notifications.message[j] = ""
                    }
                }

                res.message = "Notifications deleted"
                }
        }]
    }
}