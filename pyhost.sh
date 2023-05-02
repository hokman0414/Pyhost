#!/bin/bash

arg_w=8080
arg_f=21

function help_function {
        echo "Usage:./pyhost -w <specify port to host HTTP server>"
        echo "If No Switches Presenteed,It will be defaulted to port 8080 (HTTP)  and port 21 (FTP)"
        echo -e "\t-w specify which Port to Host HTTP Server"
        echo -e "\t-f Specify which Port to Host FTP Server"
        echo -e "\t-h Show the Help Menu"
}



while getopts ":w:f:help" opt; do
  case $opt in 
    w)
        if [[ "$OPTARG" =~ ^[0-9]+$ ]]; then 
          arg_w="$OPTARG"
        else
          echo "Invalid, Value After -w Must Be Port Number";exit 1
        fi
    ;;
    f) 
        if [["$OPTARG" = ~ ^[0-9]+$ ]]; then
          arg_f="$OPTARG"
        else
          echo "Invalid, Value After -f Must Be Port Number";exit 1
        fi 
    ;;
    h)help_function;exit 0;;
    \?)help_function;exit 1;; 
  esac
done


function cleanup {
        echo -e "\nEnding All Sessions"
        sudo pkill -f pyftpdlib
        pkill -f "/usr/bin/python3.11 -m http.server 8080"
}

trap cleanup INT

/usr/bin/python3.11 -m http.server $arg_w &
sudo python3 -m pyftpdlib -p $arg_f &

wait
