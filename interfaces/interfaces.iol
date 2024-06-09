include "objects.iol"

interface NotificationInterface {
    OneWay:
        sendNotification(NotificationRequest),
        notificationsHistorialByUser(NotificationRequest),
        deleteAllNotificationsByUser(NotificationRequest)
}

interface TaskServiceInterface {
    OneWay:
        createTask(Task),
        modifyTaskUser(Task),
        modifyTaskStatus(Task),
        deleteTask(Task),
        listAllTasks(Task),
        listTasksByUser(Task)
}

interface UserManagementInterface {
    OneWay:
        registerUser(UserRequest),
        deleteUser(UserRequest)
    RequestResponse:
        authUser(UserRequest)(UserResponse),
        checkUser(UserRequest)(UserResponse)
}