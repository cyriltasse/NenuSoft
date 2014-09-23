;--------------------------------------------------------------------------------------------------------
  pro REDUCE_FITS_TO_SAV, file, rt, rf, MEDIAN=MEDIAN, RAW=RAW, VISIBILITY=VISIBILITY, VERBOSE=VERBOSE
;--------------------------------------------------------------------------------------------------------
; e.g. file='LSS_1088_20140516_112007'
; rt, rf = reduction factors / time (spectra) & frequencies
; default reduction = Average, MEDIAN if specified
; /RAW --> saves raw data x
; /VISIBILITY --> computes and saves v

if strlowcase(strmid(file,strlen(file)-5,5)) eq '.fits' then filefits=file else filefits=file+'.fits'
header0 = headfits(filefits, exten=0)
header1 = headfits(filefits, exten=1)
a=mrdfits(filefits, 1)
f=a.frq						& nf=n_elements(f)
c=a.chan					& nc=a.nbchan
header2 = headfits(filefits, exten=2)		& nt=sxpar(header2,'NAXIS2')

nf=long(nf/rf)					& nt=long(nt/rt)
f=rebin(f(0:nf*rf-1),nf)			& t=dblarr(nt)
x=fltarr(nt,nf,nc)

for i=0L,nt-1L do begin
  y=mrdfits(filefits, 2, range=[i*rt,(i+1)*rt-1], /silent)
  t(i)=rebin(y.jd,1)
  if keyword_set(MEDIAN) then for j=0L,nf-1L do for k=0,nc-1 do x(i,j,k)=MEDIAN(y.data(j*rf:(j+1)*rf-1,k,*),/even) $
    else x(i,*,*)=rebin(y.data(0:nf*rf-1,*),nf,nc,1)
  if keyword_set(VERBOSE) and ((i mod 100) eq 0) then print,i,' / ',nt,'   ',t(i)
endfor

filesav=strmid(filefits,0,strlen(filefits)-5)+'-'+strtrim(fix(rt),2)+'-'+strtrim(fix(rf),2)
if keyword_set(MEDIAN) then filesav=filesav+'-M'
if keyword_set(RAW) then save,x,f,t,c,nf,nt,nc,rt,rf,file=filesav+'_R.sav'

if keyword_set(VISIBILITY) then begin
  CHAN_TO_VIS, c, x, v, nv, cv
  save,v,f,t,c,nf,nt,nc,nv,rt,rf,cv,file=filesav+'_V.sav'
endif

return
end
