import pyfits
import PrintRecArray
import numpy as np


def test():
    NameFits="/media/tasse/data/NENUFAR/20140524_030807/LSS_20140524_030807.fits"
    Fits=ClassNenuFITS(NameFits)
    
    return Fits

class ClassNenuFITS():
    def __init__(self,NameFits):
        self.NameFits=NameFits
        self.LFITS=pyfits.open(NameFits)
        print self
        self.ExtractInfos()
        self.buildFuckingMapping()

    def __str__(self):
        s=""
        n=30
        sep="="*n+"\n"
        s+= self.LFITS[0].header.__str__()+"\n"+sep
        s+= self.LFITS[1].header.__str__()+"\n"+sep
        s+= self.LFITS[2].header.__str__()+"\n"+sep
        s+= PrintRecArray.giveStr(self.LFITS[1].data)

        return s

    def buildFuckingMapping(self):
        c= self.ChanInfo.reshape(2,self.ChanInfo.size/2).T
        m=np.zeros((6,6),int)-1
        for i in range(self.nNumDesc):
            m[c[i,0],c[i,1]]=i
        self.mapping=m
        
    def ExtractInfos(self):
        h0=self.LFITS[0].header
        self.FRQRANGE=h0["FRQRANGE"] # '[10.01 MHz, 87.99 MHz]' / Frequency range                            
        self.dt=h0["DT"]/1000.       #      999.994 /rate in milliseconds                            
        self.df=h0["ACC"]            #        48828 /Integration factor                 

        self.nNumDesc=self.LFITS[1].data.nbchan[0]

        h1=self.LFITS[1].header
        #nf=TFORM2


        h2=self.LFITS[2].header
        self.nt=int(h2["NAXIS2"])
        strShape=h2["TDIM3"]
        ss=strShape.replace("(","").replace(")","").split(",")
        self.nf,self.n_numbers=int(ss[0]),int(ss[1])
        self.ChanInfo=self.LFITS[1].data.chan
        
        nch=self.ChanInfo.size
        ant=self.ChanInfo/2
        p=self.ChanInfo-2*ant

        self.A0,self.A1=ant.reshape(2,nch/2)
        self.pA0,self.pA1=p.reshape(2,nch/2)
        
        
        
        # stop
        # nbl=A0.size/2
        # stop
        # a=1
        # b=1
        # c=-2*nbl
        # Delta=b**2-4*a*c
        # x0=-b+np.sqrt(Delta)/(2*a)
        # x1=-b-np.sqrt(Delta)/(2*a)
        # print nbl,x0,x1

    def ReadData(self):
        #dtype([('JD', '>f8'), ('MSEC', '>f8'), ('DATA', '>f4', (25568,))])
        self.dataAll=self.LFITS[2].data
        self.data=self.dataAll.DATA
        self.times=self.dataAll.JD
        self.data=self.data.reshape((self.nt,self.nNumDesc,self.nf))
        

    def BuildMSData(self):

        na=3
        nbl=(na**2-na)/2+na

        self.nbl=nbl
        dataOut=np.zeros((self.nt*nbl,self.nf,4),dtype=np.complex64)


        # import pylab
        # pylab.ion()
        # pylab.clf()
        # m=10000000
        for pi in range(2):
            
            for pj in range(2):
                for ai in range(3):
                    for aj in range(3):
                        print pi,pj,ai,aj
                        i=2*ai+pi
                        j=2*aj+pj
                        ichan=self.mapping[i,j]
                        if ichan==-1: continue
                        ThisData=self.data[:,ichan,:]
                        # pylab.imshow(ThisData[::10,:].T,vmin=-m,vmax=m)
                        # pylab.draw()
                        # pylab.show(False)
                        # pylab.pause(0.1)
                        if i>=j:
                            dataOut[ai::nbl,:,pi+2*pj]+=ThisData
                        else:
                            dataOut[ai::nbl,:,pi+2*pj]+=1j*ThisData

        self.dataMS=dataOut
        
        
