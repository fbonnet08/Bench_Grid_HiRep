#!/usr/bin/python3
import subprocess
import datetime

roomtemperature=20  #degree
gpumaxoperatingtemperature=89 #degree

minspeed=50 #percentage [int]
maxspeed=80 #percentage [int]
minramptemperature=60 #degree
maxramptemperature=80 #degree

def MapTemperatureToSpeed(t):
        if not t or t> maxramptemperature or t < roomtemperature: 
                v = maxspeed
        elif t<minramptemperature:
                v = minspeed
        else:
                v = int(minspeed +(t-minramptemperature) *((maxspeed-minspeed)/(maxramptemperature-minramptemperature)))
        
        return int(maxspeed if v>maxspeed else (maxspeed if v<minspeed else v))
                
#fan_speed=$(nvidia-smi -q |grep "Fan Speed"|awk '{print $4}'); echo $fan_speed
def GetGpuFanSpeed():
        readout=subprocess.run(["nvidia-smi", "-q"],
                               stdout=subprocess.PIPE).stdout.decode('utf-8')
        fan_speeds_lst = []
        for line in readout.splitlines():
                rec = line.strip()
                if rec.startswith('Fan Speed'):
                        fan_speeds_lst.append(int(' '.join(rec.split()).split(' ')[3]))
                
        #print("fan_speeds_lst[:]",  fan_speeds_lst[:])
        return fan_speeds_lst[:]

#utils_lst=$(nvidia-smi -q |grep "Gpu"|awk '{print $4}'); echo $utils_lst
def GetGpuUtil():
        readout=subprocess.run(["nvidia-smi", "-q"], stdout=subprocess.PIPE).stdout.decode('utf-8')
        utils_lst = []
        for line in readout.splitlines():
                rec = line.strip()
                if rec.startswith('Gpu'):
                        utils_lst.append(int(' '.join(rec.split()).split(':')[1].split('%')[0] )    )
                
        #print("utils_lst[:]", utils_lst[:])
        return utils_lst[:]

def GetGpuTemperatures():
        readout=subprocess.run(["nvidia-smi", "-q","-d","temperature"], stdout=subprocess.PIPE).stdout.decode('utf-8')
        t=[]
        for line in readout.splitlines():
                rec = line.strip()
                if line.strip().startswith('GPU Current Temp'):
                        #print(rec)
                        t.append(int(' '.join(rec.split()).split(' ')[4].strip()))
        return t

def GetWorkingTemperature():
        t=GetGpuTemperatures()

        if not t:
                #print("no temperature readings")
                return None
        st=sorted(t)            
        medianv=st[len(st)//2]
        minv=min(t)
        maxv=max(t)
        meanv=sum(t)/len(t)

        workingtemperature=None
        if minv < roomtemperature:
                #print("below room temperature [%d<%d]"%(minv,roomtemperature))
                workingtemperature=None
        elif maxv >= gpumaxoperatingtemperature:
                #print("above or on maximum GPU operating temperature [%d>%d]"%(maxv,gpumaxoperatingtemperature))
                workingtemperature=None
        else:
                workingtemperature=maxv
        return workingtemperature,t



def SetSpeedFans(v):
#       print("set to speed %s"%(hex(v)))
        bank=2
        cmd=("ipmitool raw 0x30 0x70 0x66 0x01 %s %s"%("{0:#0{1}x}".format(bank,4),"{0:#0{1}x}".format(v,4))).split()
        readout=subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
#       print(cmd)#
#       print(readout)

if __name__ == "__main__":
        temperature,gputemperatures=GetWorkingTemperature()
        speed=MapTemperatureToSpeed(temperature)
        fan_speeds_lst=GetGpuFanSpeed()
        utils_lst=GetGpuUtil()
        print("%s | %d %d %d %d %d %d | %s | %d %d | %s | %s"%(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),roomtemperature,gpumaxoperatingtemperature,minspeed, maxspeed, minramptemperature, maxramptemperature, "%s"%(' '.join(str(x) for x in gputemperatures)), temperature,speed, "%s"%(' '.join(str(y) for y in fan_speeds_lst[:])),"%s"%(' '.join(str(z) for z in utils_lst[:])) ))

