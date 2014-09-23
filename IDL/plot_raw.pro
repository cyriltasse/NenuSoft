;----------------------------------------------------------------------------------------------------
  pro PLOT_RAW, filesav, VERBOSE=VERBOSE
;----------------------------------------------------------------------------------------------------
; e.g. filesav='LSS_1088_20140516_112007-10-2[-M]_R'

if strlowcase(strmid(filesav,strlen(filesav)-4,4)) ne '.sav' then filesav=filesav+'.sav'
restore,filesav,VERBOSE=VERBOSE

set_plot,'PS'
device, bits=8
!p.font=0
!p.charsize=1.3
device,/landscape
device,file=strmid(filesav,0,strlen(filesav)-3)+'ps'

CALDAT,t[0],month,day,year,hour,minute,second
t0=JULDAY(month,day,year,0.,0.,0.d0)
t0_string=strtrim(fix(year),2)+'/'+strtrim(fix(month),2)+'/'+strtrim(fix(day),2)

nn=ceil(nt/3000.)	& nnn=nt/nnmm=ceil(nf/2000.)	& mmm=nf/mm

for i=0,nc-1 do $
  SPDYNPS,10.*alog10(abs(rebin(x(0:nnn*nn-1,0:mmm*mm-1,i),nnn,mmm))>1),(min(t)-t0)*24.,(max(t)-t0)*24.,min(f),max(f), $
  't (hours from '+t0_string+')','f (MHz)',DELPATH(filesav)+'   '+strtrim(c(i,0),2)+','+strtrim(c(i,1),2),0,0,0,0.01,0.99,1,'.'

device,/close                                                                                                                                                                                    
set_plot,'X'
return
end
