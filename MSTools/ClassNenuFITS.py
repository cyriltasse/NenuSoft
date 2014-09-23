import pyfits
import PrintRecArray
def test():
    NameFits="/media/tasse/data/NENUFAR/20140524_030807/LSS_20140524_030807.fits"
    Fits=ClassNenuFITS(NameFits)
    return Fits

class ClassNenuFITS():
    def __init__(self,NameFits):
        self.NameFits=NameFits
        self.LFITS=pyfits.open(NameFits)
        print self

    def __str__(self):
        return PrintRecArray.giveStr(self.LFITS[1].data)
