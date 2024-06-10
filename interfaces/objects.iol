// Notification Service

type NotificationRequest: void {
    userId: int
    message: string
}

type NotificationResponse: void {
    notificationSent: bool
}

type Notification: void {
    userId: int
    message: string
}

type Notifications: void {
    notification*: Notification
}

// Task Service

type Task: void {
    userId : int
    title: string
    description: string
    date: string
    assignedTo: string
    status?: string(enum(["pending", "completed", "in-progress", "canceled"]))
}

type Tasks: void {
    task*: Task
}

// User Management Service

type UserRequest: void {
    id?: int
    name: string
    password: string
    email: string
}

type UserResponse: void {
    id?: int
}

type Users: void {
    users*: UserRequest
}