#!/bin/bash
# Check for our certs
check_certs () {
    certs="no"
    if [ -f app/ssl/server.crt ]; then
        certs="yes"
    fi
}

# We need to install the certs
cert_install () {
    echo We need some certs my fellow peeps.
    echo Will we be using CertBot today y/n
    read input
    if [ $input == "y" ]; then
        echo We will now run CertBot in docker, please follow its instructions
        docker run -it --rm --name certbot -p 80:80 -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly
        echo Hopefully that went well. Now you just need to move the certs located in /etc/letsencrypt/archive/"Your domain"/ to app/ssl
        echo and rename them to server.crt and server.key
        echo What is your full domain for your cert?
        read input
        cp "/etc/letsencrypt/archive/$input/fullchain1.pem" app/ssl/server.crt
        cp "/etc/letsencrypt/archive/$input/privkey1.pem" app/ssl/server.key
        echo Did dat work?
        return 0
    fi
    echo New self signed y/n
    read input
    if [ $input == "y" ]; then
        openssl req -x509 -nodes -new -batch -keyout app/ssl/server.key -out app/ssl/server.crt
        return 0
    fi
    echo Picky picky, your own? y/n
    read input
    if [ $input == "y" ]; then
        echo Ok cool put them in app/ssl with the names server.crt and server.key
        return 0
    fi
    echo Ok I have no idea what you want from me, im just a script :sob: leave me alone!
    return 1
}

# Want to do something cool, like idk have a config?
setup_topology () {
    echo sweet you gots some certs now do you have the topology all set up?
    echo y/n
    read input
    if [ $input == "y" ]; then
        echo hot damn, then you are ready to go.
        return 0
    else
        echo Lets build us a topology.
        echo You will find the default in app/statics/topology.json
        echo Hopefully you new that and already looked.
        echo Will you want to use a script to help build the topology?
        echo If yes we will need python 3, pip as well as yaml and termcolor installed, there will be a prompt to install these.
        echo Use script to build topology y/n
        read input
        if [ $input == "y" ]; then
            echo Auto install? If no try to run and just blow up if not installed.
            read input
            if [ $input == "y" ]; then
                apt-get install python3
                apt-get install python3-pip
                pip3 install -r runMe.requirements.txt
            else
                echo ima just run now.
            fi
            python3 scripts/generate_config.py
            if [ -f app/statics/topology.json ]; then
                mv app/statics/topology.json app/statics/topology.default.json
            else
                echo topology.json is missing, not always a bad thing.
            fi
            if [ -f topology.json ]; then
                cp topology.json app/statics/topology.json
            else
                echo topology.json has not been made. RIP
            fi
        else
            echo Cool have fun and re run me when you are happy with it.
            return 0
        fi
    fi
}

# woot
woooosh () {
    docker-compose build
    echo OMG we are going to run!!!
    docker-compose up
}

main () {
    check_certs
    if [ $certs == "no" ]; then
        cert_install
        exit
    fi
    setup_topology
    woooosh
}
main
