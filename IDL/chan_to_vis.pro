;----------------------------------------------------------------
  pro CHAN_TO_VIS, c, x, v, nv, cv
;----------------------------------------------------------------
; c(nc,2) = channel organisation
; x(nt,nf,nc) = input array
; v(nt,nf,2,2,nv) = output array
; cv = MR names

s=size(x)
nt=s(1) & nf=s(2) & nc=s(3)
m=intarr(6,6)-1
for i=0,nc-1 do m(c(i,0),c(i,1))=i
t=bytarr(6,6)
for i=0,nc-1 do t(c(i,0),c(i,1))=1
t=[t(0,0),t(2,2),t(4,4)]
tt=fix(total(t))
zero=fltarr(nt,nf)

case tt of
  1: begin
	nv=1
	v=complexarr(nt,nf,2,2,nv)
	cv=strarr(1)
	if t(0) eq 1 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(0,0)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(1,0)),-x(*,*,m(0,1)))
		v(*,*,1,0,0)=complex(x(*,*,m(1,0)),x(*,*,m(0,1)))
		v(*,*,1,1,0)=complex(x(*,*,m(1,1)),zero)
		cv(0)='MR1'
	endif
	if t(1) eq 1 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(2,2)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(3,2)),-x(*,*,m(2,3)))
		v(*,*,1,0,0)=complex(x(*,*,m(3,2)),x(*,*,m(2,3)))
		v(*,*,1,1,0)=complex(x(*,*,m(3,3)),zero)
		cv(0)='MR2'
	endif
	if t(2) eq 1 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(4,4)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(5,4)),-x(*,*,m(4,5)))
		v(*,*,1,0,0)=complex(x(*,*,m(5,4)),x(*,*,m(4,5)))
		v(*,*,1,1,0)=complex(x(*,*,m(5,5)),zero)
		cv(0)='MR3'
	endif
     end
  2: begin
	nv=3
	v=complexarr(nt,nf,2,2,nv)
	cv=strarr(2)
	if t(0) eq 0 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(2,2)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(3,2)),-x(*,*,m(2,3)))
		v(*,*,1,0,0)=complex(x(*,*,m(3,2)),x(*,*,m(2,3)))
		v(*,*,1,1,0)=complex(x(*,*,m(3,3)),zero)
		v(*,*,0,0,1)=complex(x(*,*,m(4,4)),zero)
		v(*,*,0,1,1)=complex(x(*,*,m(5,4)),-x(*,*,m(4,5)))
		v(*,*,1,0,1)=complex(x(*,*,m(5,4)),x(*,*,m(4,5)))
		v(*,*,1,1,1)=complex(x(*,*,m(5,5)),zero)
		v(*,*,0,0,2)=complex(x(*,*,m(4,2)),x(*,*,m(2,4)))
		v(*,*,0,1,2)=complex(x(*,*,m(5,2)),x(*,*,m(2,5)))
		v(*,*,1,0,2)=complex(x(*,*,m(4,3)),x(*,*,m(3,4)))
		v(*,*,1,1,2)=complex(x(*,*,m(5,3)),x(*,*,m(3,5)))
		cv=['MR2','MR3']
	endif
	if t(1) eq 0 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(0,0)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(1,0)),-x(*,*,m(0,1)))
		v(*,*,1,0,0)=complex(x(*,*,m(1,0)),x(*,*,m(0,1)))
		v(*,*,1,1,0)=complex(x(*,*,m(1,1)),zero)
		v(*,*,0,0,1)=complex(x(*,*,m(4,4)),zero)
		v(*,*,0,1,1)=complex(x(*,*,m(5,4)),-x(*,*,m(4,5)))
		v(*,*,1,0,1)=complex(x(*,*,m(5,4)),x(*,*,m(4,5)))
		v(*,*,1,1,1)=complex(x(*,*,m(5,5)),zero)
		v(*,*,0,0,2)=complex(x(*,*,m(4,0)),x(*,*,m(0,4)))
		v(*,*,0,1,2)=complex(x(*,*,m(5,0)),x(*,*,m(0,5)))
		v(*,*,1,0,2)=complex(x(*,*,m(4,1)),x(*,*,m(1,4)))
		v(*,*,1,1,2)=complex(x(*,*,m(5,1)),x(*,*,m(1,5)))
		cv=['MR1','MR3']
	endif
	if t(2) eq 0 then begin
		v(*,*,0,0,0)=complex(x(*,*,m(0,0)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(1,0)),-x(*,*,m(0,1)))
		v(*,*,1,0,0)=complex(x(*,*,m(1,0)),x(*,*,m(0,1)))
		v(*,*,1,1,0)=complex(x(*,*,m(1,1)),zero)
		v(*,*,0,0,1)=complex(x(*,*,m(2,2)),zero)
		v(*,*,0,1,1)=complex(x(*,*,m(3,2)),-x(*,*,m(2,3)))
		v(*,*,1,0,1)=complex(x(*,*,m(3,2)),x(*,*,m(2,3)))
		v(*,*,1,1,1)=complex(x(*,*,m(3,3)),zero)
		v(*,*,0,0,2)=complex(x(*,*,m(2,0)),x(*,*,m(0,2)))
		v(*,*,0,1,2)=complex(x(*,*,m(3,0)),x(*,*,m(0,3)))
		v(*,*,1,0,2)=complex(x(*,*,m(2,1)),x(*,*,m(1,2)))
		v(*,*,1,1,2)=complex(x(*,*,m(3,1)),x(*,*,m(1,3)))
		cv=['MR1','MR2']
	endif
     end
  3: begin
	nv=6
	v=complexarr(nt,nf,2,2,nv)
	cv=strarr(3)
		v(*,*,0,0,0)=complex(x(*,*,m(0,0)),zero)
		v(*,*,0,1,0)=complex(x(*,*,m(1,0)),-x(*,*,m(0,1)))
		v(*,*,1,0,0)=complex(x(*,*,m(1,0)),x(*,*,m(0,1)))
		v(*,*,1,1,0)=complex(x(*,*,m(1,1)),zero)
		v(*,*,0,0,1)=complex(x(*,*,m(2,2)),zero)
		v(*,*,0,1,1)=complex(x(*,*,m(3,2)),-x(*,*,m(2,3)))
		v(*,*,1,0,1)=complex(x(*,*,m(3,2)),x(*,*,m(2,3)))
		v(*,*,1,1,1)=complex(x(*,*,m(3,3)),zero)
		v(*,*,0,0,2)=complex(x(*,*,m(4,4)),zero)
		v(*,*,0,1,2)=complex(x(*,*,m(5,4)),-x(*,*,m(4,5)))
		v(*,*,1,0,2)=complex(x(*,*,m(5,4)),x(*,*,m(4,5)))
		v(*,*,1,1,2)=complex(x(*,*,m(5,5)),zero)
		v(*,*,0,0,3)=complex(x(*,*,m(2,0)),x(*,*,m(0,2)))
		v(*,*,0,1,3)=complex(x(*,*,m(3,0)),x(*,*,m(0,3)))
		v(*,*,1,0,3)=complex(x(*,*,m(2,1)),x(*,*,m(1,2)))
		v(*,*,1,1,3)=complex(x(*,*,m(3,1)),x(*,*,m(1,3)))
		v(*,*,0,0,4)=complex(x(*,*,m(4,0)),x(*,*,m(0,4)))
		v(*,*,0,1,4)=complex(x(*,*,m(5,0)),x(*,*,m(0,5)))
		v(*,*,1,0,4)=complex(x(*,*,m(4,1)),x(*,*,m(1,4)))
		v(*,*,1,1,4)=complex(x(*,*,m(5,1)),x(*,*,m(1,5)))
		v(*,*,0,0,5)=complex(x(*,*,m(4,2)),x(*,*,m(2,4)))
		v(*,*,0,1,5)=complex(x(*,*,m(5,2)),x(*,*,m(2,5)))
		v(*,*,1,0,5)=complex(x(*,*,m(4,3)),x(*,*,m(3,4)))
		v(*,*,1,1,5)=complex(x(*,*,m(5,3)),x(*,*,m(3,5)))
		cv=['MR1','MR2','MR3']
     end
endcase

return
end
