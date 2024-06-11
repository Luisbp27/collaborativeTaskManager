// Notification Service

type NotificationRequest1: void {
    userId: int
    message: string
}

type NotificationRequest2: void {
    userId: int
    name: string
}

type Notification: void {
    userId: int
    message: string
}

type Notifications: void {
    notifications[0, *]: Notification
}

// Task Service

type Task: void {
    id?: int
    userId: int
    title: string
    description: string
    date: string
    assignedTo: string
    status?: string(enum(["pending", "completed", "in-progress", "canceled"]))
}

type Tasks: void {
    tasks[0, *]: Task
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
    users[0, *]: UserRequest
}