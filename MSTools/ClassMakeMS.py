
import ModParsetType
import os

class ClassMakeMS():
    def __init__(self,binMakeMS="makems"):
        self.binMakeMS=binMakeMS

        
    def makems(self,
               AntennaTable=None,
               StrRA=None,
               StrDEC=None,
               Nchan=None,
               WriteAutoCorr=None,
               t0=None,nt=None,dt=None,
               f0m=None,nf=None,df=None):
        D={}
        MS=self.MS
        MS1name=self.MS1name
        
        DateTime=GiveDate(t0)
        # Date,Time=DateTime.datetime().date().isoformat(),DateTime.datetime().time().isoformat()
        # SDateTime=Date+'/'+Time

        D["AntennaTableName"]={"id":0,"val":MS.MSName+"/ANTENNA"}
        D["Declination"]={"id":0,"val":StrDEC}
        D["RightAscension"]={"id":0,"val":StrRA}
        D["MSName"]={"id":0,"val":self.MSName}
        D["WriteAutoCorr"]={"id":0,"val":WriteAutoCorr}

        D["NBands"]={"id":0,"val":1}
        D["WriteAutoCorr"]={"id":0,"val":"T"}

        D["StartFreq"]={"id":0,"val":f0-df/2.}
        D["StepFreq"]={"id":0,"val":df}
        D["NFrequencies"]={"id":0,"val":nf}

        D["StartTime"]={"id":0,"val":DateTime}#"29-sep-2005/13:00:00"}
        D["StepTime"]={"id":0,"val":dt}
        D["NTimes"]={"id":0,"val":nt}

        D["VDSPath"]={"id":0,"val":"."}
        D["WriteImagerColumns"]={"id":0,"val":"T"}
    
        ModParsetType.DictToParset(D,"makems.tmp.cfg")
        os.system("cat makems.tmp.cfg")
        os.system("%s makems.tmp.cfg"%(self.binMakeMS))

