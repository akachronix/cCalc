#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'

if [ -f /usr/lib/libmath.so ]; then
	echo "[${RED}LOG${NC}] Deleting libmath library from /usr/lib."
	sudo rm -rf /usr/lib/libmath.so
else
	echo "[${RED}LOG${NC}] libmath shared library doesn't exist in lib directory."
fi

if [ -d bin ]; then
	echo "[${RED}LOG${NC}] Deleting bin directory."
	rm -rf bin
else
	echo "[${RED}LOG${NC}] bin directory doesn't exist."
fi

echo "[${RED}LOG${NC}] Creating bin directory."
mkdir bin

echo "[${RED}LOG${NC}] Compiling frontend."
g++ -Ilibmath -Lbin -Wall -pedantic -g -c calc/main.cpp

echo "[${RED}LOG${NC}] Compiling libmath library."
g++ -Ilibmath -Lbin -Wall -pedantic -g -c -fPIC libmath/libmath.cpp

echo "[${RED}LOG${NC}] Linking libmath into shared library."
g++ -Ilibmath -Lbin -Wall -pedantic -g -shared -o bin/libmath.so libmath.o

echo "[${RED}LOG${NC}] Linking frontend with library into applet."
g++ -Ilibmath -Lbin -Wall -pedantic -g -o bin/calc main.o -lmath

echo "[${RED}LOG${NC}] Cleaning up object files."
rm -rf *.o

echo "[${RED}LOG${NC}] Moving shared library into standard directory."
sudo mv bin/libmath.so /usr/lib
sudo chmod 755 /usr/lib/libmath.so

echo "[${RED}LOG${NC}] Done."
