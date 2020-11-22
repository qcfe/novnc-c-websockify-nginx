# noVNC container
### featuring the C version of websockify
#### without thousand python dependencies

## Usage
`docker build . --tag novnc-c-websockify-nginx`

`docker run -it --rm -p 8080:80 -e VNC_SERVER=host.docker.internal -e VNC_PORT=5900 novnc-c-websockify-nginx`
