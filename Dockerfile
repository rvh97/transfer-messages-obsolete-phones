FROM ubuntu:18.04
RUN  apt update
RUN  apt upgrade -y
RUN  apt install -y wammu gammu bluez
# Fix 'ImportError: No module named six' when starting wammu by reinstalling six
RUN  apt install python-pip -y
RUN  pip uninstall six
RUN  pip install six
