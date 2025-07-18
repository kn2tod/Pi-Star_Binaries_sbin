#!/bin/bash
#########################################################
#                                                       #
#              HostFilesUpdate.sh Updater               #
#                                                       #
#      Written for Pi-Star (http://www.pistar.uk/)      #
#               By Andy Taylor (MW0MWZ)                 #
#                                                       #
#                     Version 2.6                       #
#                                                       #
#   Based on the update script by Tony Corbett G0WFV    #
#                                                       #
#########################################################

# Check that the network is UP and die if its not
if [ "$(expr length `hostname -I | cut -d' ' -f1`x)" == "1" ]; then
	exit 0
fi

# Get the Pi-Star Version
pistarCurVersion=$(awk -F "= " '/Version/ {print $2}' /etc/pistar-release)

APRSHOSTS=/usr/local/etc/APRSHosts.txt
DCSHOSTS=/usr/local/etc/DCS_Hosts.txt
DExtraHOSTS=/usr/local/etc/DExtra_Hosts.txt
DMRIDFILE=/usr/local/etc/DMRIds.dat
DMRHOSTS=/usr/local/etc/DMR_Hosts.txt
DPlusHOSTS=/usr/local/etc/DPlus_Hosts.txt
P25HOSTS=/usr/local/etc/P25Hosts.txt
M17HOSTS=/usr/local/etc/M17Hosts.txt
YSFHOSTS=/usr/local/etc/YSFHosts.txt
FCSHOSTS=/usr/local/etc/FCSHosts.txt
XLXHOSTS=/usr/local/etc/XLXHosts.txt
NXDNIDFILE=/usr/local/etc/NXDN.csv
NXDNHOSTS=/usr/local/etc/NXDNHosts.txt
TGLISTBM=/usr/local/etc/TGList_BM.txt
TGLISTP25=/usr/local/etc/TGList_P25.txt
TGLISTNXDN=/usr/local/etc/TGList_NXDN.txt
TGLISTYSF=/usr/local/etc/TGList_YSF.txt
STRIPPED=/usr/local/etc/stripped.csv
DMRPLUS=/usr/local/etc/TGList_DMRplus.txt
FREEDMR=/usr/local/etc/TGList_FreeDMR.txt
TGIF=/usr/local/etc/TGList_TGIF.txt
AMCOMM=/usr/local/etc/TGList_AmComm.txt
#NEXTIONGROUPS=/usr/local/etc/nextionGroups.txt
NEXTIONGROUPS=/usr/local/etc/groups.txt
NEXTIONUSERS=/usr/local/etc/nextionUsers.csv
# How many backups
FILEBACKUP=1

# Check we are root
if [ "$(id -u)" != "0" ];then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Create backup of old files
if [ ${FILEBACKUP} -ne 0 ]; then
	cp ${APRSHOSTS} ${APRSHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${DCSHOSTS} ${DCSHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${DExtraHOSTS} ${DExtraHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${DMRIDFILE} ${DMRIDFILE}.$(date +%Y%m%d) 2>/dev/null
	cp ${DMRHOSTS} ${DMRHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${DPlusHOSTS} ${DPlusHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${P25HOSTS} ${P25HOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${M17HOSTS} ${M17HOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${YSFHOSTS} ${YSFHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${FCSHOSTS} ${FCSHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${XLXHOSTS} ${XLXHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${NXDNIDFILE} ${NXDNIDFILE}.$(date +%Y%m%d) 2>/dev/null
	cp ${NXDNHOSTS} ${NXDNHOSTS}.$(date +%Y%m%d) 2>/dev/null
	cp ${TGLISTBM} ${TGLISTBM}.$(date +%Y%m%d) 2>/dev/null
	cp ${TGLISTP25} ${TGLISTP25}.$(date +%Y%m%d) 2>/dev/null
	cp ${TGLISTNXDN} ${TGLISTNXDN}.$(date +%Y%m%d) 2>/dev/null
	cp ${TGLISTYSF} ${TGLISTYSF}.$(date +%Y%m%d) 2>/dev/null
	cp ${STRIPPED} ${STRIPPED}.$(date +%Y%m%d) 2>/dev/null
	cp ${DMRPLUS} ${DMRPLUS}.$(date +%Y%m%d) 2>/dev/null
	cp ${FREEDMR} ${FREEDMR}.$(date +%Y%m%d) 2>/dev/null
	cp ${AMCOMM} ${AMCOMM}.$(date +%Y%m%d) 2>/dev/null
	cp ${TGIF} ${TGIF}.$(date +%Y%m%d) 2>/dev/null
	cp ${NEXTIONGROUPS} ${NEXTIONGROUPS}.$(date +%Y%m%d) 2>/dev/null
	cp ${NEXTIONUSERS} ${NEXTIONUSERS}.$(date +%Y%m%d) 2>/dev/null
fi

# Prune backups
FILES="${APRSHOSTS}
${DCSHOSTS}
${DExtraHOSTS}
${DMRIDFILE}
${DMRHOSTS}
${DPlusHOSTS}
${P25HOSTS}
${M17HOSTS}
${YSFHOSTS}
${FCSHOSTS}
${XLXHOSTS}
${NXDNIDFILE}
${NXDNHOSTS}
${TGLISTBM}
${TGLISTP25}
${TGLISTNXDN}
${TGLISTYSF}
${STRIPPED}
${DMRPLUS}
${FREEDMR}
${AMCOMM}
${TGIF}
${NEXTIONGROUPS}
${NEXTIONUSERS}"

for file in ${FILES}
do
  BACKUPCOUNT=$(ls ${file}.* 2>/dev/null | wc -l)
  BACKUPSTODELETE=$(expr ${BACKUPCOUNT} - ${FILEBACKUP})
  if [ ${BACKUPCOUNT} -gt ${FILEBACKUP} ]; then
	for f in $(ls -tr ${file}.* | head -${BACKUPSTODELETE})
	do
		rm $f
	done
  fi
done

# Generate Host Files
curl --fail -o ${APRSHOSTS} -s http://www.pistar.uk/downloads/APRS_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${DCSHOSTS} -s http://www.pistar.uk/downloads/DCS_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${DMRHOSTS} -s http://www.pistar.uk/downloads/DMR_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
if [ -f /etc/hostfiles.nodextra ]; then
  # Move XRFs to DPlus Protocol
  curl --fail -o ${DPlusHOSTS} -s http://www.pistar.uk/downloads/DPlus_WithXRF_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
  curl --fail -o ${DExtraHOSTS} -s http://www.pistar.uk/downloads/DExtra_NoXRF_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
else
  # Normal Operation
  curl --fail -o ${DPlusHOSTS} -s http://www.pistar.uk/downloads/DPlus_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
  curl --fail -o ${DExtraHOSTS} -s http://www.pistar.uk/downloads/DExtra_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
fi
curl --fail -o ${DMRIDFILE} -s http://www.pistar.uk/downloads/DMRIds.dat --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${P25HOSTS} -s http://www.pistar.uk/downloads/P25_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${M17HOSTS} -s http://www.pistar.uk/downloads/M17_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${YSFHOSTS} -s http://www.pistar.uk/downloads/YSF_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${FCSHOSTS} -s http://www.pistar.uk/downloads/FCS_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
#curl --fail -s http://www.pistar.uk/downloads/USTrust_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}" >> ${DExtraHOSTS}
curl --fail -o ${XLXHOSTS} -s http://www.pistar.uk/downloads/XLXHosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${NXDNIDFILE} -s http://www.pistar.uk/downloads/NXDN.csv --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${NXDNHOSTS} -s http://www.pistar.uk/downloads/NXDN_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${TGLISTBM} -s http://www.pistar.uk/downloads/TGList_BM.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${TGLISTP25} -s http://www.pistar.uk/downloads/TGList_P25.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${TGLISTNXDN} -s http://www.pistar.uk/downloads/TGList_NXDN.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${TGLISTYSF} -s http://www.pistar.uk/downloads/TGList_YSF.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${STRIPPED} -s https://database.radioid.net/static/user.csv --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -o ${NEXTIONGROUPS} -s http://www.pistar.uk/downloads/groups.txt --user-agent "Pi-Star_${pistarCurVersion}"
curl -sSL http://www.pistar.uk/downloads/nextionUsers.csv.gz --user-agent "Pi-Star_${pistarCurVersion}" | gunzip -c > ${NEXTIONUSERS}

#curl --fail -o ${DMRPLUS}  -s https://www.pistar.uk/downloads/anytone/download_dmrplustalkgroups.php --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -s https://www.pistar.uk/downloads/anytone/download_dmrplustalkgroups.php --user-agent "Pi-Star_${pistarCurVersion}" | awk -F"," '{print $2, $3}' | sed -n 's/"\([0-9]*\)" "\(TG[0-9A-Z]*\)[ ;]\(.*\)"/\1;0;\3;\2/p' > ${DMRPLUS}
#curl --fail -o ${FREEDMR}  -s https://www.pistar.uk/downloads/anytone/download_freedmrtalkgrops.php  --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -s https://www.pistar.uk/downloads/anytone/download_freedmrtalkgrops.php  --user-agent "Pi-Star_${pistarCurVersion}" | awk -F"," '{print $2, $3}' | sed -n 's/"\([0-9]*\)" "[ ]\(.*\)[ ]"/\1;0;\2;TG\1/p' > ${FREEDMR}
#curl --fail -o ${TGIF}     -s https://www.pistar.uk/downloads/anytone/download_tgiftalkgroups.php    --user-agent "Pi-Star_${pistarCurVersion}"
curl --fail -s https://www.pistar.uk/downloads/anytone/download_tgiftalkgroups.php    --user-agent "Pi-Star_${pistarCurVersion}" | awk -F"," '{print $2, $3}' | sed -n 's/"\([0-9]*\)" "\(TG[0-9A-Z]*\)[ ;]\(.*\)"/\1;0;\3;\2/p' > ${TGIF}
curl --fail -s http://status.amcomm.network/talkgroups/amcommdmrtalkgoups.CSV | awk -F"," {'print ($2";0;"$3";TG"$2)'} | sort -g | sed -e '1 d' -e 's/"//g' -e 's/;[[:space:]]*/;/g' > ${AMCOMM}

# If there is a DMR Over-ride file, add it's contents to DMR_Hosts.txt
if [ -f "/root/DMR_Hosts.txt" ]; then
	cat /root/DMR_Hosts.txt >> ${DMRHOSTS}
fi

# Add custom YSF Hosts
if [ -f "/root/YSFHosts.txt" ]; then
	cat /root/YSFHosts.txt >> ${YSFHOSTS}
fi

# Fix DMRGateway issues with brackets
if [[ -f "/etc/dmrgateway" && "$(grep "Name=.*(" /etc/dmrgateway)" ]]; then
	sed -i '/Name=.*(/d' /etc/dmrgateway
	sed -i '/Name=.*)/d' /etc/dmrgateway
fi

# Add some fixes for P25Gateway
if [[ $(/usr/local/bin/P25Gateway --version | awk '{print $3}' | cut -c -8) -gt "20180108" && "$(grep "Hosts=" /etc/p25gateway)" ]];  then
	sed -i 's/Hosts=\/usr\/local\/etc\/P25Hosts.txt/HostsFile1=\/usr\/local\/etc\/P25Hosts.txt\nHostsFile2=\/usr\/local\/etc\/P25HostsLocal.txt/g' /etc/p25gateway
	sed -i 's/HostsFile2=\/root\/P25Hosts.txt/HostsFile2=\/usr\/local\/etc\/P25HostsLocal.txt/g' /etc/p25gateway
fi
if [ -f "/root/P25Hosts.txt" ]; then
	cat /root/P25Hosts.txt > /usr/local/etc/P25HostsLocal.txt
fi

# Add local over-ride for TGList-BM
if [ -f "/root/TGList_BM.txt" ]; then
	cat /root/TGList_BM.txt >> ${TGLISTBM}
fi

# Add local over-ride for M17Hosts
if [ -f "/root/M17Hosts.txt" ]; then
	cat /root/M17Hosts.txt >> ${M17HOSTS}
fi

# Fix up new NXDNGateway Config Hostfile setup
if [[ $(/usr/local/bin/NXDNGateway --version | awk '{print $3}' | cut -c -8) -gt "20180801" && "$(grep "HostsFile=" /etc/nxdngateway)" ]];  then
	sed -i 's/HostsFile=\/usr\/local\/etc\/NXDNHosts.txt/HostsFile1=\/usr\/local\/etc\/NXDNHosts.txt\nHostsFile2=\/usr\/local\/etc\/NXDNHostsLocal.txt/g' /etc/nxdngateway
fi
if [ ! -f "/root/NXDNHosts.txt" ]; then
	touch /root/NXDNHosts.txt
fi
if [ ! -f "/usr/local/etc/NXDNHostsLocal.txt" ]; then
	touch /usr/local/etc/NXDNHostsLocal.txt
fi

# Add custom NXDN Hosts
if [ -f "/root/NXDNHosts.txt" ]; then
	cat /root/NXDNHosts.txt > /usr/local/etc/NXDNHostsLocal.txt
fi

# If there is an XLX over-ride
if [ -f "/root/XLXHosts.txt" ]; then
        while IFS= read -r line; do
                if [[ $line != \#* ]] && [[ $line = *";"* ]]
                then
                        xlxid=`echo $line | awk -F  ";" '{print $1}'`
			xlxip=`echo $line | awk -F  ";" '{print $2}'`
                        #xlxip=`grep "^${xlxid}" /usr/local/etc/XLXHosts.txt | awk -F  ";" '{print $2}'`
			xlxroom=`echo $line | awk -F  ";" '{print $3}'`
                        xlxNewLine="${xlxid};${xlxip};${xlxroom}"
                        /bin/sed -i "/^$xlxid\;/c\\$xlxNewLine" /usr/local/etc/XLXHosts.txt
                fi
        done < /root/XLXHosts.txt
fi

# Add local over-ride for APRSHosts
if [ -f "/root/APRSHosts.txt" ]; then
        cat /root/APRSHosts.txt >> ${APRSHOSTS}
fi

# Yaesu FT-70D radios only do upper case
if [ -f "/etc/hostfiles.ysfupper" ]; then
	sed -i 's/\(.*\)/\U\1/' ${YSFHOSTS}
	sed -i 's/\(.*\)/\U\1/' ${FCSHOSTS}
fi

# Fix up ircDDBGateway Host Files on v4
if [ -d "/usr/local/etc/ircddbgateway" ]; then
	if [[ -f "/usr/local/etc/ircddbgateway/DCS_Hosts.txt" && ! -L "/usr/local/etc/ircddbgateway/DCS_Hosts.txt" ]]; then
		rm -rf /usr/local/etc/ircddbgateway/DCS_Hosts.txt
		ln -s /usr/local/etc/DCS_Hosts.txt /usr/local/etc/ircddbgateway/DCS_Hosts.txt
	fi
	if [[ -f "/usr/local/etc/ircddbgateway/DExtra_Hosts.txt" && ! -L "/usr/local/etc/ircddbgateway/DExtra_Hosts.txt" ]]; then
		rm -rf /usr/local/etc/ircddbgateway/DExtra_Hosts.txt
		ln -s /usr/local/etc/DExtra_Hosts.txt /usr/local/etc/ircddbgateway/DExtra_Hosts.txt
	fi
	if [[ -f "/usr/local/etc/ircddbgateway/DPlus_Hosts.txt" && ! -L "/usr/local/etc/ircddbgateway/DPlus_Hosts.txt" ]]; then
		rm -rf /usr/local/etc/ircddbgateway/DPlus_Hosts.txt
		ln -s /usr/local/etc/DPlus_Hosts.txt /usr/local/etc/ircddbgateway/DPlus_Hosts.txt
	fi
	if [[ -f "/usr/local/etc/ircddbgateway/CCS_Hosts.txt" && ! -L "/usr/local/etc/ircddbgateway/CCS_Hosts.txt" ]]; then
		rm -rf /usr/local/etc/ircddbgateway/CCS_Hosts.txt
		ln -s /usr/local/etc/CCS_Hosts.txt /usr/local/etc/ircddbgateway/CCS_Hosts.txt
	fi
fi

# Extended DMR Id File update
if [ -f /usr/local/sbin/HostFilesUpdate-Ext.sh ]; then
	nohup /usr/local/sbin/HostFilesUpdate-Ext.sh -s -u -r &>/tmp/nohupx &
fi

exit 0
