include "objects.iol"

interface NotificationInterface {
    OneWay:
        sendNotification(NotificationRequest1)
    RequestResponse:
        notificationsHistorialByUser(NotificationRequest2)(string)
}

interface TaskServiceInterface {
    OneWay:
        createTask(Task),
        modifyTaskUser(Task),
        modifyTaskStatus(Task),
        deleteTask(Task)
    RequestResponse:
        listAllTasks(void)(string),
        listTasksByUser(Task)(string)
}

interface UserManagementInterface {
    OneWay:
        deleteUser(UserRequest1)
    RequestResponse:
        registerUser(UserRequest1)(UserResponse1),
        authUser(UserRequest2)(UserResponse2),
        checkUser(UserRequest2)(UserResponse2)
}