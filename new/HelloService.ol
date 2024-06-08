type HelloRequest {
	name:string
}

interface HelloInterface {
requestResponse:
	hello( HelloRequest )( string )
}

service HelloService {
	execution: concurrent

	inputPort HelloService {
		location: "socket://localhost:9000"
		protocol: http { format = "json" }
		interfaces: HelloInterface
	}

	main {
		hello( request )( response ) {
			response = "Hello " + request.name
		}
	}
}