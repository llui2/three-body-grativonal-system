       program twobodies

       implicit none 
       integer i, npassos
       parameter(npassos = 5000)
       double precision temps,tmax,dt 
       double precision cord0(12),cord1(12)
       double precision xG, xm1, xm2, xm3, radi12, radi13, radi23, V
       common /parametres/ xG,xm1,xm2,xm3

       open(1,file='dades.dat')

c      [m^3/kg·s^2]
       xG = 1.d4
c      [kg]
       xm1 = 10000.d0
       xm2 = 10.d0
       xm3 = 100.d0
c      max time evolution [s]
       tmax = 10.d0
       
       dt = tmax/npassos
       V = 100000.d0

c      (coord. x, coord. y, velocity x, velocity y)    
       cord0= (/    0.d0,0.d0,0.d0,0.d0,
     .              30.d0,0.d0,0.d0,V*0.245d0,
     .              60.d0,0.d0,0.d0,V
     .        /)

       do i=1,npassos

       temps = dt*i
       call miRungeKutta4(temps,dt,cord0,12,cord1)

       write(1,*)temps,cord1(1),cord1(2),cord1(5),cord1(6),
     .               cord1(9),cord1(10)  
       cord0 = cord1

       enddo

       close(1)

       call system ("gnuplot path.gnu")
       call system ("gnuplot animation.gnu")

       end

c----------------------------------------------------------------------
c      ONE STEP RUNGE-KUTTA ORDER 4 SUBROUTINE
c----------------------------------------------------------------------
       subroutine miRungeKutta4(t,dt,yyin,nequs,yyout)
       implicit none
       integer nequs
       double precision yyin(nequs), yyout(nequs)
       double precision t, dt
c      INPUT;
c             nequs         ->     number of equations in the problem
c             yyin          ->     initial values
c             t, dt         ->     current step time, step time
c      OUTPUT;
c             yyout         ->     final values
       integer i
       double precision k1(nequs), k2(nequs), k3(nequs), k4(nequs)
       double precision yytemp(nequs)
       external derivad
c      K1
       call derivad(t,yyin,k1,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k1(i)/2
       enddo
c      K2
       call derivad(t+dt/2,yytemp,k2,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k2(i)/2
       enddo
c      K3
       call derivad(t+dt/2,yytemp,k3,nequs)
       do i=1,nequs
              yytemp(i) = yyin(i)+dt*k3(i)
       enddo
c      K4
       call derivad(t+dt,yytemp,k4,nequs)
       do i=1,nequs
              yyout(i) = yyin(i)+(dt/6)*(k1(i)+2*k2(i)+2*k3(i)+k4(i))
       enddo
       end

c----------------------------------------------------------------------
c      DERIVATIVE OF THE DIFERENTIAL EQUATIONS OF THE PROBLEM
c----------------------------------------------------------------------
       subroutine derivad(t,yin,dyout,nequ)
       implicit none
       integer nequ
       double precision t, yin(nequ), dyout(nequ)
c      INPUT;
c             nequ          ->     number of equations to solve
c             t             ->     numeric value of the independent variable
c             yin           ->     numeric value of the dependent variable
c      OUTPUT;
c             dyout         ->     numeric values of the derivative of the dependent variable
       double precision G,m1,m2,m3
       double precision radi12, radi13, radi23
       double precision f12, f13, f23
       common /parametres/ G,m1,m2,m3

       if (nequ.gt.12) then 
              print*, 'error derivades' 
       endif


       radi12 = sqrt((yin(5)-yin(1))**2+(yin(6)-yin(2))**2)
       f12 = -(G*m1*m2)/radi12**3
       radi13 = sqrt((yin(9)-yin(1))**2+(yin(10)-yin(2))**2)
       f13 = -(G*m1*m3)/radi13**3
       radi23 = sqrt((yin(9)-yin(5))**2+(yin(10)-yin(6))**2)
       f23 = -(G*m2*m3)/radi23**3

c       if (radi12.lt.10) f12 = 0
c       if (radi13.lt.10) f13 = 0
c       if (radi23.lt.10) f23 = 0
       

c      movement equations
       dyout(1) = yin(3)/m1
       dyout(2) = yin(4)/m1
       dyout(3) = f12*(yin(1)-yin(5)) + f13*(yin(1)-yin(9))
       dyout(4) = f12*(yin(2)-yin(6)) + f13*(yin(2)-yin(10))

       dyout(5) = yin(7)/m2
       dyout(6) = yin(8)/m2
       dyout(7) = f12*(yin(5)-yin(1)) + f23*(yin(5)-yin(9))
       dyout(8) = f12*(yin(6)-yin(2)) + f23*(yin(6)-yin(10))

       dyout(9) = yin(11)/m3
       dyout(10) = yin(12)/m3
       dyout(11) = f13*(yin(9)-yin(1)) + f23*(yin(9)-yin(5))
       dyout(12) = f13*(yin(10)-yin(2)) + f23*(yin(10)-yin(6))


       end
c----------------------------------------------------------------------