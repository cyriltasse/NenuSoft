import ModParsetType
import ClassMS
import os
import numpy as np


class Conform():
    def __init__(self,MSname,SPW):

    #MS=ClassMS.ClassMS("/media/6B5E-87D0/TestOlegVLA/3C147_nobl_spw2.MS",Col="CORRECTED_DATA")
        self.Cols=["DATA","CORRECTED_DATA"]
        print SPW
        self.MS=ClassMS.ClassMS(MSname,Col=self.Cols,SelectSPW=SPW)
        print "done read"
        self.MS1name=self.MS.MSName+".reformed"
        self.RevertFreqs=False
        if self.MS.dFreq<0:
            self.RevertFreqs=True
        #self.RevertFreqs=True

        time1=self.MS.times_all
        print "sort"
        list_t1=sorted(list(set(time1.tolist())))
        print "done sort"
        t1=np.array(list_t1)
        dt1=t1[1::]-t1[0:-1]
        self.Dt=np.median(dt1)
        

    


    def putInMS(self):
        MS=self.MS
        MS1name=self.MS1name
        
        from pyrap.tables import table
        MSout=ClassMS.ClassMS(MS1name,Col=self.Cols)
        
        idx=0
        AntMap=np.zeros((MS.na,MS.na),dtype=np.int32)
        for i in range(MS.na):
            for j in range(i,MS.na):
                #AntMap[i,j]=idx
                AntMap[MSout.A0[idx],MSout.A1[idx]]=idx
                idx+=1

        t0=MS.times_all[0]
        it=np.int64(np.round((MS.times_all-t0)/self.Dt))*MSout.nbl
        Rowmap=it+AntMap[MS.A0,MS.A1]
        
        indIn=np.arange(MS.uvw.shape[0])
        MSout.flag_all.fill(1)
        
        #replace:
        MSout.uvw[Rowmap,:]=MS.uvw[:,:]
        #MSout.times_all[Rowmap]=MS.times_all[:]
        MSout.A0[Rowmap]=MS.A0[:]
        MSout.A1[Rowmap]=MS.A1[:]
        
        if not(self.RevertFreqs):
            for i in range(len(self.Cols)):
                MSout.data[i][Rowmap,:,:]=MS.data[i][:,:,:]
            MSout.flag_all[Rowmap,:,:]=MS.flag_all[:,:,:]
        else:
            for i in range(len(self.Cols)):
                MSout.data[i][Rowmap,::-1,:]=MS.data[i][:,:,:]
            MSout.flag_all[Rowmap,::-1,:]=MS.flag_all[:,:,:]

        MSout.SaveAllDataStruct()

        t=table(MS.MSName+"::SPECTRAL_WINDOW",ack=False,readonly=False)
        chanFreqs=t.getcol('CHAN_FREQ')
        chanWidth=t.getcol('CHAN_WIDTH')
        t.close()
        for spw in range(chanFreqs.shape[0]):
            ind=np.argsort(chanFreqs[spw])
            chanFreqs[spw][:]=chanFreqs[spw][ind]
            chanWidth[spw][:]=np.abs(chanWidth[spw][ind])

        t=table(MSout.MSName+"::SPECTRAL_WINDOW",ack=False,readonly=False)
        t.putcol('CHAN_FREQ',chanFreqs)
        t.putcol('CHAN_WIDTH',chanWidth)
        t.close()



def test():
    
    import sys
    MSname="1365275227_TriAust"#sys.argv[1]
    C=Conform(MSname,None)
    C.makems()
    C.putInMS()




if __name__=="__main__":
    import sys
    MSname=sys.argv[1]
    SPW=None
    print sys.argv
    if len(sys.argv)==3:
        SPW=[int(sys.argv[2])]

    print 
    C=Conform(MSname,SPW)
    C.makems()
    C.putInMS()

