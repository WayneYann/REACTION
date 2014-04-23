#!/bin/sh
# to execute:  sh conp.sh logname  &

sh 1> ${1}.log 2>&1 << ENDSH

set -x

#cd /scr/$LOGNAME              #go to user's scratch directory
#mkdir "${1}$$"                #make subdirectory /myrun##
#cd "${1}$$"                   #go to /myrun##

cat << EOF > makefile

include chemmake.h

OBJS = conp.o cklib.o vode.o math.o
INPS = therm.dat chem.inp conp.inp
OUTS = chem.out chem.bin conp.out
EXES = chem.exe conp.exe

chem.exe: ckinterp.o
	  $(LINK) chem.exe ckinterp.o

conp.exe: $(OBJS)
	  $(LINK) conp.exe $(OBJS)
EOF

cat << EOF > chem.inp
ELEMENTS H   O   N  END
SPECIES  H2 H O2 O OH HO2 H2O2 H2O N N2 NO END
REACTIONS
   H2+O2=2OH                      0.170E+14  0.00  47780
   OH+H2=H2O+H                    0.117E+10  1.30   3626 ! D-L&W
   O+OH=O2+H                      0.400E+15 -0.50      0 ! JAM 1986
   O+H2=OH+H                      0.506E+05  2.67   6290 ! KLEMM,ET AL
   H+O2+M=HO2+M                   0.361E+18 -0.72      0 ! DIXON-LEWIS
       H2O/18.6/  H2/2.86/  N2/1.26/
   OH+HO2=H2O+O2                  0.750E+13  0.00      0 ! D-L
   H+HO2=2OH                      0.140E+15  0.00   1073 ! D-L
   O+HO2=O2+OH                    0.140E+14  0.00   1073 ! D-L
   2OH=O+H2O                      0.600E+09  1.30      0 ! COHEN-WEST.
   H+H+M=H2+M                     0.100E+19 -1.00      0 ! D-L
     H2O/0.0/  H2/0.0/
   H+H+H2=H2+H2                   0.920E+17 -0.60      0
   H+H+H2O=H2+H2O                 0.600E+20 -1.25      0
   H+OH+M=H2O+M                   0.160E+23 -2.00      0 ! D-L
       H2O/5/
   H+O+M=OH+M                     0.620E+17 -0.60      0 ! D-L
       H2O/5/
   O+O+M=O2+M                     0.189E+14  0.00  -1788 ! NBS
   H+HO2=H2+O2                    0.125E+14  0.00      0 ! D-L
   HO2+HO2=H2O2+O2                0.200E+13  0.00      0
   H2O2+M=OH+OH+M                 0.130E+18  0.00  45500
   H2O2+H=HO2+H2                  0.160E+13  0.00   3800
   H2O2+OH=H2O+HO2                0.100E+14  0.00   1800
   O+N2=NO+N                      0.140E+15  0.00  75800
   N+O2=NO+O                      0.640E+10  1.00   6280
   OH+N=NO+H                      0.400E+14  0.00      0
END
EOF


cat << EOF > conp.inp
1 1000
H2 1
O2 3
N2 .1
END
3.0E-4 3.0E-5
EOF

touch makefile; make chem.exe conp.exe
chem.exe; conp.exe < conp.inp > conp.out

ENDSH
