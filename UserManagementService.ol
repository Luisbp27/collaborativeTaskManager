include "console.iol"
include "/protocols/http.iol"

type UserRequest: void {
    userId: int
    username: string
    password: string
    email: string
}

type UserResponse: void {
    message: string
}

interface UserManagementInterface {
    RequestResponse: registerUser(UserRequest)(UserResponse),
    modifyUser(UserRequest)(UserResponse)
}

inputPort UserManagementPort {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

main {
    registerUser(req)(res) {
        // Register user logic (simplified)
        res.message = "User " + req.username + " registered successfully."
    }

    modifyUser(req)(res) {
        // Modify user logic (simplified)
        res.message = "User " + req.username + " modified successfully."
    }
}
