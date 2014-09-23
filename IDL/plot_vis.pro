;----------------------------------------------------------------------------------------------------
  pro PLOT_VIS, filesav, VERBOSE=VERBOSE
;----------------------------------------------------------------------------------------------------
; e.g. filesav='LSS_1088_20140516_112007-10-2[-M]_V'

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

; Fabrication des amplitudes et phases

case nv of
  1: begin
     rien=''
     end
  3: begin
	np=38
	p=fltarr(nnn,mmm,np)	& p_tit=strarr(np)	& p_log=bytarr(np)
	y=float(v(*,*,0,0,0)+v(*,*,1,1,0))	& p(*,*,0)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[0]='S '+cv[0]		& p_log[0]=1	& S0=y+(y eq 0)
	y=float(v(*,*,0,0,0)-v(*,*,1,1,0))	& p(*,*,1)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[1]='|Q| '+cv[0]		& p_log[1]=1
	y=y/S0					& p(*,*,2)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[2]='q '+cv[0]		& p_log[2]=0
	y=float(v(*,*,0,1,0)+v(*,*,1,0,0))	& p(*,*,3)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[3]='|U| '+cv[0]		& p_log[3]=1
	y=y/S0					& p(*,*,4)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[4]='u '+cv[0]		& p_log[4]=0
	y=imaginary(-v(*,*,0,1,0)+v(*,*,1,0,0)) & p(*,*,5)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[5]='|V| '+cv[0]		& p_log[5]=1
	y=y/S0					& p(*,*,6)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[6]='v '+cv[0]		& p_log[6]=0
	y=float(v(*,*,0,0,1)+v(*,*,1,1,1))	& p(*,*,7)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[7]='S '+cv[1]		& p_log[7]=1	& S1=y+(y eq 0)
	y=float(v(*,*,0,0,1)-v(*,*,1,1,1))	& p(*,*,8)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[8]='|Q| '+cv[1]		& p_log[8]=1
	y=y/S1					& p(*,*,9)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[9]='q '+cv[1]		& p_log[9]=0
	y=float(v(*,*,0,1,1)+v(*,*,1,0,1)) 	& p(*,*,10)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[10]='|U| '+cv[1]	& p_log[10]=1
	y=y/S1					& p(*,*,11)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[11]='u '+cv[1]		& p_log[11]=0
	y=imaginary(-v(*,*,0,1,1)+v(*,*,1,0,1))	& p(*,*,12)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[12]='|V| '+cv[1]	& p_log[12]=1
	y=y/S1					& p(*,*,13)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[13]='v '+cv[1]		& p_log[13]=0
	SQ=sqrt(float(v(*,*,0,0,0)*v(*,*,0,0,1)))	& SQ=SQ+(SQ eq 0)	& z=v(*,*,0,0,2)/SQ
	y=float(z)				& p(*,*,14)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[14]='Re('+cv[0]+'NW*'+cv[1]+'NW)'		& p_log[14]=0
	y=imaginary(z)				& p(*,*,15)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[15]='Im('+cv[0]+'NW*'+cv[1]+'NW)'		& p_log[15]=0
	y=abs(z)				& p(*,*,16)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[16]='Abs('+cv[0]+'NW*'+cv[1]+'NW)'		& p_log[16]=0
	y=atan(imaginary(z),float(z))*!radeg	& p(*,*,17)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[17]='Ph('+cv[0]+'NW*'+cv[1]+'NW) [deg]'		& p_log[17]=0
	SQ=sqrt(float(v(*,*,1,1,0)*v(*,*,1,1,1)))	& SQ=SQ+(SQ eq 0)	& z=v(*,*,1,1,2)/SQ
	y=float(z)				& p(*,*,18)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[18]='Re('+cv[0]+'NE*'+cv[1]+'NE)'		& p_log[18]=0
	y=imaginary(z)				& p(*,*,19)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[19]='Im('+cv[0]+'NE*'+cv[1]+'NE)'		& p_log[19]=0
	y=abs(z)				& p(*,*,20)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[20]='Abs('+cv[0]+'NE*'+cv[1]+'NE)'		& p_log[20]=0
	y=atan(imaginary(z),float(z))*!radeg	& p(*,*,21)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[21]='Ph('+cv[0]+'NE*'+cv[1]+'NE) [deg]'		& p_log[21]=0
	z=(v(*,*,0,0,2)+v(*,*,1,1,2))/sqrt(S0*S1)
	y=float(z)				& p(*,*,22)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[22]='Re(S_norm('+cv[0]+'*'+cv[1]+'))'		& p_log[22]=0
	y=imaginary(z)				& p(*,*,23)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[23]='Im(S_norm('+cv[0]+'*'+cv[1]+'))'		& p_log[23]=0
	y=abs(z)				& p(*,*,24)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[24]='Abs(S_norm('+cv[0]+'*'+cv[1]+'))'		& p_log[24]=0
	y=atan(imaginary(z),float(z))*!radeg	& p(*,*,25)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[25]='Ph(S_norm('+cv[0]+'*'+cv[1]+')) [deg]'	& p_log[25]=0
	z=v(*,*,0,1,2)
	y=float(z)				& p(*,*,26)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[26]='Re('+cv[0]+'NW*'+cv[1]+'NE)'		& p_log[26]=1
	y=imaginary(z)				& p(*,*,27)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[27]='Im('+cv[0]+'NW*'+cv[1]+'NE)'		& p_log[27]=1
	z=z/sqrt(S0*S1)
	y=float(z)				& p(*,*,28)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[28]='Re(('+cv[0]+'NW*'+cv[1]+'NE)_norm)'	& p_log[28]=0
	y=imaginary(z)				& p(*,*,29)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[29]='Im(('+cv[0]+'NW*'+cv[1]+'NE)_norm)'	& p_log[29]=0
	y=abs(z)				& p(*,*,30)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[30]='Abs(('+cv[0]+'NW*'+cv[1]+'NE)_norm)'	& p_log[30]=0
	y=atan(imaginary(z),float(z))*!radeg	& p(*,*,31)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[31]='Ph(('+cv[0]+'NW*'+cv[1]+'NE)_norm) [deg]'	& p_log[31]=0
	z=v(*,*,1,0,2)
	y=float(z)				& p(*,*,32)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[32]='Re('+cv[0]+'NE*'+cv[1]+'NW)'		& p_log[32]=1
	y=imaginary(z)				& p(*,*,33)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[33]='Im('+cv[0]+'NE*'+cv[1]+'NW)'		& p_log[33]=1
	z=z/sqrt(S0*S1)
	y=float(z)				& p(*,*,34)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[34]='Re(('+cv[0]+'NE*'+cv[1]+'NW)_norm)'	& p_log[34]=0
	y=imaginary(z)				& p(*,*,35)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[35]='Im(('+cv[0]+'NE*'+cv[1]+'NW)_norm)'	& p_log[35]=0
	y=abs(z)				& p(*,*,36)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[36]='Abs(('+cv[0]+'NE*'+cv[1]+'NW)_norm)'	& p_log[36]=0
	y=atan(imaginary(z),float(z))*!radeg	& p(*,*,37)=rebin(y(0:nnn*nn-1,0:mmm*mm-1),nnn,mmm)	& p_tit[37]='Ph(('+cv[0]+'NE*'+cv[1]+'NW)_norm) [deg]'	& p_log[37]=0
     end
  6: begin
     rien=''
     end
endcase

for i=0,np-1 do begin
  if keyword_set(VERBOSE) then print,p_tit[i]
  if p_log[i] eq 1 then SPDYNPS,10.*alog10(abs(p(*,*,i))>1),(min(t)-t0)*24.,(max(t)-t0)*24.,min(f),max(f), $
	't (hours from '+t0_string+')','f (MHz)',DELPATH(filesav)+'   '+p_tit[i],0,0,0,0.01,0.99,1,'' $
  else SPDYNPS,p(*,*,i),(min(t)-t0)*24.,(max(t)-t0)*24.,min(f),max(f), $
	't (hours from '+t0_string+')','f (MHz)',DELPATH(filesav)+'   '+p_tit[i],0,0,0,0.01,0.99,1,'.'
endfor

device,/close                                                                                                                                                                                    
set_plot,'X'
return
end
