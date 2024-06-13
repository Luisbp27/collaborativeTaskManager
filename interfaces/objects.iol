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
    userId?: int
    title?: string
    description?: string
    date?: string
    assignedTo?: string
    status?: string(enum(["pending", "completed", "in-progress", "canceled"]))
}

type Tasks: void {
    tasks[0, *]: Task
}

// User Management Service

type UserRequest1: void {
    id?: int
    name: string
    password: string
    email: string
}

type UserRequest2: void {
    id?: int
    name: string
    password?: string
}

type UserResponse1: void {
    id?: int
}

type UserResponse2: void {
    userRegistered?: bool
}

type User: void {
    id?: int
    name: string
    password: string
    email: string
}

type Users: void {
    users[0, *]: User
}