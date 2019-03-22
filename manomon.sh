#!/bin/bash
# manomon 1.0 - MANOCoin Masternode Monitoring 

#Processing command line params
if [ -z $1 ]; then dly=1; else dly=$1; fi   # Default refresh time is 1 sec

datadir="/$USER/.manocoin$2"   # Default datadir is /root/.manocoin
 
# Install jq if it's not present
dpkg -s jq 2>/dev/null >/dev/null || sudo apt-get -y install jq

#It is a one-liner script for now
watch -ptn $dly "echo '===========================================================================
Outbound connections to other MANO nodes [MANO datadir: $datadir]
===========================================================================
Node IP               Ping    Rx/Tx     Since  Hdrs   Height  Time   Ban
Address               (ms)   (KBytes)   Block  Syncd  Blocks  (min)  Score
==========================================================================='
mano-cli -datadir=$datadir getpeerinfo | jq -r '.[] | select(.inbound==false) | \"\(.addr),\(.pingtime*1000|floor) ,\
\(.bytesrecv/1024|floor)/\(.bytessent/1024|floor),\(.startingheight) ,\(.synced_headers) ,\(.synced_blocks)  ,\
\((now-.conntime)/60|floor) ,\(.banscore)\"' | column -t -s ',' && 
echo '==========================================================================='
uptime
echo '==========================================================================='
echo 'Masternode Status: \n# mano-cli masternode status' && mano-cli -datadir=$datadir masternode status
echo '==========================================================================='
echo 'Sync Status: \n# mano-cli mnsync status' &&  mano-cli -datadir=$datadir mnsync status
echo '==========================================================================='
echo 'Masternode Information: \n# mano-cli getinfo' && mano-cli -datadir=$datadir getinfo
echo '==========================================================================='
echo 'Usage: manomon.sh [refresh delay] [datadir index]'
echo 'Example: manomon.sh 10 22 will run every 10 seconds and query manod in /$USER/.manocoin22'
echo '\n\nPress Ctrl-C to Exit...'"
