#!/bin/bash
#hmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhm
# Create extended DMR id file (DMRids.xtd.dat)
# Ref: www.kf5iw.com/contactdb.php; https://database.radioid.net/static/user.csv
# Options: -u: update DMRids.xtd.dat file; -r: delete (reset) temp DMRIdx.dat file
#          -s: use radio.net database instead of kf5iw
#hmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhmhm
#
updt=0
rst=0
src=0
while getopts urs opt; do
  case $opt in
    u) updt=1;;
    r) rst=1;;
    s) src=1;;
  esac
done
shift $(($OPTIND - 1))
#
ok=1
cd /tmp
#
if [ $src == 0 ]; then
  web="(KF5IW)"
  echo "...downloading latest contact file (KF5IW)"
  curl --fail -o contactdb.php -s http://www.kf5iw.com/contactdb.php
# x=$(sed -n 's|\(.*\)STD/contacts_STD_\(.*\).zip\(.*\)|contacts_STD_\2|p' contactdb.php)
# xx="http://www.kf5iw.com/data/Anytone/D868UV/STD/"$x".zip"
  x=$(sed -n 's|\(.*\)ALL/contacts_ALL_\(.*\).zip\(.*\)|contacts_ALL_\2|p' contactdb.php)
  xx="http://www.kf5iw.com/data/Anytone/D868UV/ALL/"$x".zip"
  curl --fail -o extendedx.zip -f $xx
  if [ $? -eq 0 ]; then
     rm contactdb.php
     rm -f                                         contacts_*.csv
     unzip -a extendedx.zip
     rm -f                                         xcontacts.csv
     mv contacts_*.csv                             xcontacts.csv
     rm extendedx.zip
     sudo sed -i 's/^[0-9]*,//g'                   xcontacts.csv
     sudo sed -i '/^"[0-9]\{1,6\}",/d'             xcontacts.csv
     ok=0
  fi
else
  web="(RadioID.Net)"
  echo "...downloading latest contact file (RADIOID.NET)"
  sudo curl --fail -o xcontacts.csv -f https://database.radioid.net/static/user.csv
  if [ $? -eq 0 ]; then
#   sudo cp xcontacts.csv                          xcontactsx.csv
    sudo sed -i 's|\\n|\x0a|g'                     xcontacts.csv   # temp?  correct line enders
    sudo sed -i 's/,/ /3'                          xcontacts.csv
    sudo sed -i 's/, /,/g'                         xcontacts.csv
    sudo sed -i -e 's/^.*$/"&"/g' -e 's/,/","/g'   xcontacts.csv
    ok=0
  fi
fi
#
if [ "$ok" == 0 ]; then
#
sed -i -e      '1 d
                s|^"",||g
                s|,"","",""$||g'                   xcontacts.csv
#
echo "...abbreviating states"
sed -i -e      's|"Alabama"|"AL"|g
                s|"Alaska"|"AK"|g
                s|"Arizona"|"AZ"|g
                s|"Arkansas","Un|"AR","Un|g
                s|"California"|"CA"|g
                s|"Colorado"|"CO"|g
                s|"Connecticut"|"CT"|g
                s|"Delaware"|"DE"|g
                s|"Florida"|"FL"|g
                s|"Georgia"|"GA"|g
                s|"Hawaii"|"HI"|g
                s|"Idaho"|"ID"|g
                s|"Illinois"|"IL"|g
                s|"Indiana"|"IN"|g
                s|"Iowa"|"IA"|g
                s|"Kansas"|"KS"|g
                s|"Kentucky"|"KY"|g
                s|"Louisiana"|"LA"|g
                s|"Maine"|"ME"|g
                s|"Maryland","Un|"MD","Un|g
                s|"Massachusetts"|"MA"|g
                s|"Michigan"|"MI"|g
                s|"Minnesota"|"MN"|g
                s|"Mississippi"|"MS"|g
                s|"Missouri"|"MO"|g
                s|"Montana"|"MT"|g
                s|"Nebraska"|"NE"|g
                s|"Nevada"|"NV"|g
                s|"New Hampshire"|"NH"|g
                s|"New Jersey"|"NJ"|g
                s|"New Mexico"|"NM"|g
                s|"New York","Un|"NY","Un|g
                s|"North Carolina"|"NC"|g
                s|"North Dakota"|"ND"|g
                s|"Ohio"|"OH"|g
                s|"Oklahoma"|"OK"|g
                s|"Oregon"|"OR"|g
                s|"Pennsylvania"|"PA"|g
                s|"Rhode Island"|"RI"|g
                s|"South Carolina"|"SC"|g
                s|"South Dakota"|"SD"|g
                s|"Tennessee"|"TN"|g
                s|"Texas"|"TX"|g
                s|"Utah"|"UT"|g
                s|"Vermont"|"VT"|g
                s|"Virginia"|"VA"|g
                s|"Washington","Un|"WA","Un|g
                s|"West Virginia"|"WV"|g
                s|"Wisconsin"|"WI"|g
                s|"Wyoming"|"WY"|g
                s|"District of Columbia"|"DC"|g'   xcontacts.csv
#
echo "...abbreviating provinces"
sed -i -e      's|"Alberta"|"AB"|g
                s|"British Columbia"|"BC"|g
                s|"Manitoba"|"MB"|g
                s|"New Brunswick"|"NB"|g
                s|"Newfoundland"|"NL"|g
                s|"Labrador"|"NL"|g
                s|"Newfoundland and Labrador"|"NL"|g
                s|"Northwest Territories"|"NT"|g
                s|"Northern Territories"|"NT"|g
                s|"Nova Scotia"|"NS"|g
                s|"Nunavut"|"NU"|g
                s|"Ontario","Can|"ON","Can|g
                s|"Prince Edward Island"|"PE"|g
                s|"Quebec"|"QC"|g
                s|"Saskatchewan"|"SK"|g
                s|"Yukon"|"YT"|g
                s|"St. Johns,,CAN"|"St. Johns,NL,CAN"|g
                s|,"New South Wales","A|,"NSW","A|g'   xcontacts.csv
#
echo "...abbreviating countries"
sed -i -e      's|"United States"|"US"|g
                s|"United Kingdom"|"UK"|g
                s|"United Arab Emirates"|"UAE"|g
                s|"Korea S Republic of"|"Korea"|g
                s|"Korea Republic of"|"Korea"|g
                s|"Bosnia and Hercegovina"$|"Bosnia"|g
                s|"Bosnia and Hercegovina"$|"BiH"|g
                s|"Austria"|"AUT"|g
                s|"Australia"|"AUS"|g
                s|"Ireland"|"IRL"|g
                s|"New Zealand"|"NZL"|g
                s|"Sweden"|"SWE"|g
                s|"Canada"|"CAN"|g
                s|"Germany"|"DEU"|g
                s|"Puerto Rico"|"PR"|g
                s|"Argentina Republic"|"Argentina"|g
                s|"Czech Republic"|"Czech"|g
                s|"British Virgin Islands"|"BVI"|g
                s|"U.S. Virgin Islands"|"USVI"|g
                s|"Netherlands"|"NLD"|g
                s|"Switzerland"|"CHE"|g
                s|"Czech Republic"|"CZE"|g
                s|"Denmark"|"DNK"|g
                s|"Norway"|"NOR"|g
                s|"France"|"FRA"|g
                s|"Russia"|"RUS"|g
                s|"Ukraine"|"UKR"|g
                s|"Greece"|"GRE"|g
                s|"Spain"|"ESP"|g
                s|"Brazil"|"BRA"|g
                s|"Poland"|"POL"|g
                s|"Mexico"|"MEX"|g
                s|"South Africa"|"ZAF"|g
                s|"Turkey"|"TUR"|g
                s|"Croatia"|"HRV"|g
                s|"Argentina"|"ARG"|g
                s|"Slovakia"|"SVK"|g
                s|"Slovenia"|"SVN"|g
                s|"Israel"|"ISR"|g
                s|"Romania"|"ROU"|g
                s|"Portugal"|"PRT"|g
                s|"Thailand"|"THA"|g
                s|"Trinidad and Tobago"|"TTO"|g
                s|"Bulgaria"|"BGR"|g
                s|"Japan"|"JPN"|g
                s|"Hungary"|"HUN"|g
                s|"Indonesia"|"IDN"|g
                s|"Philippines"$|"PHL"|g
                s|"Dominican Republic"|"DOM"|g
                s|"Belgium"|"BEL"|g
                s|"Finland"|"FIN"|g
                s|"Malaysia"$|"MYS"|g
                s|"Ecuador"|"ECU"|g
                s|"Serbia"|"SRB"|g
                s|"Uruguay"$|"URY"|g
                s|"New Caledonia"$|"NCL"|g
                s|"Saudi Arabia"$|"SAU"|g
                s|"Lithuania"$|"LTU"|g
                s|"Colombia"$|"COL"|g
                s|"Venezuela"$|"VEN"|g
                s|"Pakistan"$|"PAK"|g
                s|"India"$|"IND"|g
                s|"Uzbekistan"$|"UZB"|g
                s|"Kazakhstan"$|"KAZ"|g
                s|"Algeria"$|"DZA"|g
                s|"Morocco"$|"MAR"|g
                s|"Montenegro"$|"MNE"|g
                s|"Luxemburg"$|"LUX"|g
                s|"Italy"$|"ITA"|g'                xcontacts.csv
#
echo "...miscellaneous edits"
# Oddities, typos, corrections, etc.
sed -i -e      's|, Mr."|"|g
                s|, Mr"|"|g
                s|, Ii"|, II"|g
                s| Ii"| II"|g
                s| Ii "| II "|g
                s|, Iii"|, III"|g
                s| Iii"| III"|g
                s| Iii "| III "|g
                s|, Iv"|, IV"|g
                s| Iv | IV |g
                s|, sr"|, Sr"|g
                s|, SR"|, Sr"|g
                s|, JR"|, Jr"|g
                s|, jr"|, Jr"|g
                s| Phd"| PHD"|g
                s| -",|",|g
                s|"IT","ITA"|"","ITA"|g
                s|"it","ITA"|"","ITA"|g
                s|"All Others"|""|g
                s|,"All Regions",|,"",|g
                s|Kennesaw State University|KSU|g
                s|Amateur Radio Club|ARC|g
                s|Amateur Radio Emergency Service|ARES|g
                s|New York City|NYC|g
                s|New york city|NYC|g
                s|Nyc |NYC |g
                s| Vink Vink"| Vink"|g
                s|"-","China"|"","China"|g
                s| -",|",|g
                s|--|-|g
                s|"-",|"",|g
                s|"Norcross\."|"Norcross"|g
                s|"Cummings","GA"|"Cumming","GA"|g
                s|"New York","NY"|"NY","NY"|g
                s|"washington"|"Washington"|g'     xcontacts.csv
#               s|Amateur Radio Emergency Communications|AREC|g
#
echo "...final cleanup"
# converts from quoted CSV to regular CSV; remove extraneous commas, spaces, quotes
sed -i -e      's|","|<|g
                s|, | |g
                s|,| |g
                s|"||g
                s|<|,|g'                           xcontacts.csv
sed -i -e      's|   | |g
                s|  | |g
                s| ,|,|g'                          xcontacts.csv
#
# temp: cleanup up errant "city":
#sed -i '/,Bilecik,TUR$/!s/,Bilecik,\([[:alpha:]]*\)$/,,\1/g' xcontacts.csv 
#
wc -l /tmp/xcontacts.csv | awk '{print "...", $1, "entries downloaded"}'
#
sed  -i "1 s/^/#       Updated $(date '+%d-%b-%Y %T %Z') $web\n/" xcontacts.csv
#
if [ $updt == 1 ]; then
fs=$(grep "/dev/root" /proc/mounts | sed -n "s/.*\(r[ow]\).*/\1/p")
#rpi-rw
if [ "$fs" == "ro" ]; then
  sudo mount -o remount,rw / ; sudo mount -o remount,rw /boot
fi
#
echo "...completing update"
xfile=/usr/local/etc/DMRIds.xtd.dat
if [ -r ${xfile} ]; then
# How many backups
nfiles=1
# Create backup of old files
  if [ ${nfiles} -ne 0 ]; then
     cp ${xfile} ${xfile}.$(date +%Y%m%d)
  fi
# Prune backups
  fcnt=$(ls ${xfile}.* | wc -l)
  fdel=$(expr ${fcnt} - ${nfiles})
  if [ ${fcnt} -gt ${nfiles} ]; then
     for f in $(ls -tr ${xfile}.* | head -${fdel})
     do
       rm $f
     done
  fi
fi
#
sudo cp /tmp/xcontacts.csv ${xfile}
sudo rm -f                 xcontacts.csv
sudo rm -f                 extendedx.zip
#
if [ $rst == 1 ]; then
  echo "...rebuilding temp id file"
  sudo rm -f /tmp/DMRIdx.dat
fi
#rpi-ro
if [ "$fs" == "ro" ]; then
  sudo mount -o remount,ro / ; sudo mount -o remount,ro /boot
fi
fi
else
  echo "  ... download failed"
fi