# Intro

This repository is meant to help anyone having trouble transferring data liks messages/sms from old cellphones, in my case an old Sony Ericsson K530i. This repository was created due to a lack of available resources online, and I hope I can save someone else the time-consuming troubleshooting involved, at least partially.

# Prerequisites:
* Using Ubuntu

# How To Transfer

Due to wammu not being available in Ubuntu releases later than 18.04, I had to create a docker container using the older Ubuntu version.

1. Install Docker Engine, see https://docs.docker.com/engine/install/ubuntu/

2. Clone this repository or create an identical Dockerfile

3. Build the docker container, as long as the Dockerfile is in the same location that you're executing the command from this should work:
```
docker build -t nameofimage .
```

4. Temporarily enable display access using
```
xhost +local:*
```

5. Now it's more or less to just start up the container and find your cellphone through bluetooth in order to be able to transfer messages. Run the container with the following options:
- `-it` means interactive
- `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/` to let container use display
- `--net=host` to let container get access to bluetooth (didn't work without this for me at least)

Which should end up as:
```
docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ --net=host nameofimage
```

6. Inside the docker-container, first test that bluetooth seems to work by executing the following command and making sure you have a couple of lines output without any obvious error
```
hciconfig
```

7. Then, scan for bluetooth devices (make sure bluetooth is activated on both computer and cellphone and that the phone is visible). It might be that you need to run the command a few times for it in order to detect your cellphone:
```
hcitool scan
```
From the output you should be able to get the bluetooth address for your phone, e.g. `00:1E:DC:C2:4A:ED`.

8. From there on you can add a config file for gammu/wammu by adding your address and type in a config file:
```
echo "[gammu]" > ~/.gammurc
echo "port = 00:1E:DC:C2:4A:ED" >> ~/.gammurc
echo "connection = blueat" >> ~/.gammurc
echo "model = at" >> ~/.gammurc
```

9. Now you should be able to test connect using gammu. Try executing
```
gammu identify
```
It should give some output response if it can find it.

10. If step 9 worked, you can proceed to backup your sms either through:
* The GUI-tool wammu, which you can start simply by running `wammu` and then after connecting to choose to retrieve messages, and then save or export them
* `gammu backupsms file -all`, you can see other commands and options under `gammu --help` and `gammu --help sms`

11. Copying the backed up sms file is as easy as copying any file from a docker container, e.g.
```
docker cp nameofcontainer:/foo.txt foo.txt
```
(You can list active containers in another terminal by using `docker ps`)

12. Disable display access after you're done (as this was just a temporary fix)
```
xhost -local:*
```


## New to Docker? Some Common Commands

List active containers:
```
docker ps
```

List all containers:
```
docker ps -a
```

List all images:
```
docker images
```

Running simple containers:
```
docker run hello-world
docker run -it ubuntu`
docker run -it ubuntu:18.04`
```

Removing all containers:
```
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

Removing all images:
```
docker rmi $(docker images -q)
```
