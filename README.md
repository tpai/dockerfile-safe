# Dockerfile Safe

Basically it's no possible to keep source code safe when you put it inside docker image, anyone who have the docker image can access as root user.

However, we still can create some inconvenience for malicious user.

- Pull docker image: only specific IP address can pull
- Use interactive shell on container: only VM/K8s admin can use
- Run command on container: container user can only read/exec app
- Disable chown/chmod: container user should not be the owner of files
- Protect source code: compile to binary, uglify or minify

## Showcase

Be sure to build image before running any case.

```sh
docker build -t dockerfile-safe .
```

### Run as root

Anyone can run as root when he/she owns the docker image.

```sh
docker run --rm dockerfile-safe
# Output: exec by app

docker run -u 0:0 --rm dockerfile-safe
# Output: exec by root
```

Remember to add access restriction for container registry, docker images should only be pulled by server or developer.

### Install Packages

Keep everything minimal and trust no one, **DO NOT** add container user into sudoer group.

Use `slim` or `alpine` linux based image instead of installing handy tools for malicious user.

```sh
apt update
# Output: E: List directory /var/lib/apt/lists/partial is missing. - Acquire (13: Permission denied)
```

### Application Breach

Let's say the application has a bug and allow malicious user to run shell as container user. It will allow malicious user to change the permission of filesystem.

That's why we changed the file ownership to root and only allow container user to access as a group member.

```sh
docker run --rm -it dockerfile-safe sh # to simulate a running container
$ chmod 777 main.sh
# Output: chmod: changing permissions of 'main.sh': Operation not permitted
```
