#!/bin/bash
# usage: nvidiaOC.sh


####################################################

GPU_0_FAN=54
GPU_0_VID_CLOCK=150
GPU_0_MEM_CLOCK=800
GPU_0_POWER=118

GPU_1_FAN=55
GPU_1_VID_CLOCK=160
GPU_1_MEM_CLOCK=960
GPU_1_POWER=112

GPU_2_FAN=55
GPU_2_VID_CLOCK=160
GPU_2_MEM_CLOCK=960
GPU_2_POWER=112

####################################################


smiName="$(echo "$(nvidia-smi --format=csv --query-gpu=name)")"
outputName=${smiName#*e}
outputNameNew="$(echo "$outputName" | sed -e 'H;${x;s/\n/,/g;s/^,//;p;};d')"
IFS=',' read -r -a arrayName <<< "$outputNameNew"



clear

echo "The config settings:"

echo
echo "$(tput setaf 2)GPU 0: ${arrayName[1]}"
echo "$(tput setaf 7)------------------------"
echo "FAN:       $(tput setaf 1)$GPU_0_FAN"
echo "$(tput setaf 7)VID CLOCK: $(tput setaf 1)$GPU_0_VID_CLOCK"
echo "$(tput setaf 7)MEM CLOCK: $(tput setaf 1)$GPU_0_MEM_CLOCK"

echo
echo "$(tput setaf 2)GPU 1: ${arrayName[2]}"
echo "$(tput setaf 7)------------------------"
echo "FAN:       $(tput setaf 1)$GPU_1_FAN"
echo "$(tput setaf 7)VID CLOCK: $(tput setaf 1)$GPU_1_VID_CLOCK"
echo "$(tput setaf 7)MEM CLOCK: $(tput setaf 1)$GPU_1_MEM_CLOCK"

echo
echo "$(tput setaf 2)GPU 2: ${arrayName[3]}"
echo "$(tput setaf 7)------------------------"
echo "FAN:       $(tput setaf 1)$GPU_2_FAN"
echo "$(tput setaf 7)VID CLOCK: $(tput setaf 1)$GPU_2_VID_CLOCK"
echo "$(tput setaf 7)MEM CLOCK: $(tput setaf 1)$GPU_2_MEM_CLOCK"


echo "$(tput setaf 7)"
echo -n "Do you want to activate the overclock (y/n)? "
echo " "
read answer
if echo "$answer" | grep -iq "^y" ;then
	echo Yes
	echo Activating new settings..

	# Power mode
	nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1
	nvidia-settings -a [gpu:1]/GPUPowerMizerMode=1
	nvidia-settings -a [gpu:2]/GPUPowerMizerMode=1

	# Fan speed
        nvidia-settings -a [gpu:0]/GPUFanControlState=1 -a [fan:0]/GPUTargetFanSpeed=$GPU_0_FAN
        nvidia-settings -a [gpu:1]/GPUFanControlState=1 -a [fan:1]/GPUTargetFanSpeed=$GPU_1_FAN
        nvidia-settings -a [gpu:2]/GPUFanControlState=1 -a [fan:2]/GPUTargetFanSpeed=$GPU_2_FAN

	# Video clock
	nvidia-settings -a [gpu:0]/GPUGraphicsClockOffset[3]=$GPU_0_VID_CLOCK
	nvidia-settings -a [gpu:1]/GPUGraphicsClockOffset[3]=$GPU_1_VID_CLOCK
	nvidia-settings -a [gpu:2]/GPUGraphicsClockOffset[3]=$GPU_2_VID_CLOCK

	# Memory clock
	nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[3]=$GPU_0_MEM_CLOCK
	nvidia-settings -a [gpu:1]/GPUMemoryTransferRateOffset[3]=$GPU_1_MEM_CLOCK
	nvidia-settings -a [gpu:2]/GPUMemoryTransferRateOffset[3]=$GPU_2_MEM_CLOCK

	# Powerlimit
	sudo nvidia-smi -i 0 -pl "$GPU_0_POWER"
	sudo nvidia-smi -i 1 -pl "$GPU_1_POWER"
	sudo nvidia-smi -i 2 -pl "$GPU_2_POWER"


	echo
	echo "  DONE"
	echo "  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  🔥  "
	echo





else
	echo No
fi
