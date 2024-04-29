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
    RequestResponse:
    registerUser(UserRequest)(UserResponse),
    modifyUser(UserRequest)(UserResponse)
}

inputPort UserManagementPort {
    location: "socket://localhost:1235"
    protocol: http
    interfaces: UserManagementInterface
}

main {
    registerUser(req)(res) {
        // Adding user in a list
        res.message = "User " + req.username + " registered successfully."
    }

    checkUser(req)(res) {
        // Check if the user is in the list
        res.message = "User " + req.username + " checked successfully."
    }
}
