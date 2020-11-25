# noVNC container
### featuring the C version of websockify
#### without thousand python dependencies

## Usage

`docker build . --tag novnc`

`docker run -p 8080:80 -it --rm --name novnc novnc`
