FROM ubuntu:16.04

RUN apt-get update -y && apt-get install -y gcc python 

# adds all the exploitable services to the container
ADD exploitables/ /etc/

# compile all C programs
RUN gcc /etc/echoserver.c -o /etc/echoserver \
&& gcc -std=c99 /etc/lab1.c -o /etc/lab1 \
&& gcc -std=c99 /etc/lab2.c -o /etc/lab2 \
&& gcc -std=c99 /etc/lab3.c -o /etc/lab3 \
&& gcc -std=c99 /etc/lab4.c -o /etc/lab4

# add the script that mantains all the services
ADD start.sh /etc/

# documentation purposes only: list all the ports
#   remove this if you want the ports to be
#   hidden from docker's interface
EXPOSE 1000-1004 12345 33333 3285 4445 

# main process for container
CMD ["/etc/start.sh"]