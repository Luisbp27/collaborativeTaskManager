include "console.iol"
include "HelloService.ol"

service Main {

    main {
        println@Console( "Welcome to the Collaborative Task Manager!" )()
    }
}

