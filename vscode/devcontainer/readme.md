# VSCode CLI in a Docker Container

This is a minial Debian Docker container with the VSCode CLI inside. Why?

* Running `code serve-web` provides a web development environment that can be connected to through a browser
* Running `code tunnel` connects to GitHub, allowing you to connect to the container from pretty much anywhere
* Or you can ssh directly to the container, allowing you to edit whatever