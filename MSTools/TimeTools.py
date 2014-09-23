import ephem
import pyrap.quanta as qa
import pyrap.measures as pm

def GiveStrDate(tt):
    time_start = qa.quantity(tt, 's')
    me = pm.measures()
    dict_time_start_MDJ = me.epoch('utc', time_start)
    time_start_MDJ=dict_time_start_MDJ['m0']['value']
    JD=time_start_MDJ+2400000.5-2415020
    d=ephem.Date(JD)

    return d.datetime().isoformat().replace("T","/")
