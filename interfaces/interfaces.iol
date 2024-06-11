include "objects.iol"

interface NotificationInterface {
    OneWay:
        sendNotification(NotificationRequest1),
        deleteAllNotificationsByUser(NotificationRequest1),
        notificationsHistorialByUser(NotificationRequest2)
}

interface TaskServiceInterface {
    OneWay:
        createTask(Task),
        modifyTaskUser(Task),
        modifyTaskStatus(Task),
        deleteTask(Task),
        listAllTasks(void),
        listTasksByUser(Task)
}

interface UserManagementInterface {
    OneWay:
        deleteUser(UserRequest)
    RequestResponse:
        registerUser(UserRequest)(UserResponse),
        authUser(UserRequest)(UserResponse),
        checkUser(UserRequest)(UserResponse)
}