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
                notifications[global.not_iter].userId = req.userId
                notifications[global.not_iter].message = req.message
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
                    if (notifications[j].userId == req.userId) {
                        println@Console("Notification Nº" + j + ": " + notifications[j].message)()
                    }
                }
            }
        }]

        [deleteAllNotificationsByUser(req)(res) {
            synchronized( token ) {
                println@Console("Deleting all notifications for user " + req.userId)()
                println@Console( " " )()

                for (j = 0, j < global.not_iter, j++) {
                    if (notifications[j].userId == req.userId) {
                        notifications[j].userId = ""
                        notifications[j].message = ""
                    }
                }

                res.message = "Notifications deleted"
            }
        }]
    }
}