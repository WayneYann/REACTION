      PROGRAM EQDRIV
C
C///////////////////////////////////////////////////////////////////
C
C            INTERACTIVE DRIVER FOR STANJAN-III EQUILIBRIUM PROGRAM
C
C     WRITTEN BY:
C         ROBERT J. KEE, ANDREW E. LUTZ, and FRAN M. RUPLEY
C         COMPUTATIONAL MECHANICS DIVISION
C         SANDIA NATIONAL LABORATORIES
C         LIVERMORE, CA  94550
C         (415) 294-3272
C
C   THIS PROGRAM IS CURRENTLY DIMENSIONED FOR 50 SPECIES, 10 ELEMENTS.
C
C/////////////////////////////////////////////////////////////////////
C
C*****precision > double
        IMPLICIT DOUBLE PRECISION (A-H, O-Z), INTEGER (I-N)
C*****END precision > double
C*****precision > single
C        IMPLICIT REAL (A-H, O-Z), INTEGER (I-N)
C*****END precision > single
C
C        ACTUAL FIRST DIMENSION FOR ARRAYS
C
      PARAMETER (LENRCK=5000, LENICK=5000, LENCCK=100, LENIEQ=5000,
     1           LENREQ=5000, LINKCK=25, LOUT=6, LIN=5, LSAVE=7,
     2           KDIM=100, MDIM=10)
C
      CHARACTER*16  CCKWRK(LENCCK), KSYM(KDIM), ATOM(MDIM)
      DIMENSION ICKWRK(LENICK), RCKWRK(LENRCK), IEQWRK(LENIEQ),
     1          REQWRK(LENREQ), REAC(KDIM), XCON(KDIM), KCON(KDIM)
      LOGICAL LCNTUE, EQST, LPRNT
      DATA LCNTUE, EQST, LPRNT /.FALSE., .FALSE., .TRUE./
C
      OPEN (LINKCK, FORM='UNFORMATTED', STATUS='UNKNOWN',
     1              FILE='chem.bin')
      OPEN (LSAVE,  FORM='UNFORMATTED', STATUS='UNKNOWN',
     1              FILE='save.bin')
C
  100 CONTINUE
C
C     INITIALIZE INPS FOR PROBLEM
C
      CALL EQSTRT (LIN, LOUT, LENICK, LENRCK, LENCCK, LINKCK,
     1            MDIM, KDIM, ICKWRK, RCKWRK, CCKWRK, MM, KK,
     2            ATOM, KSYM, NOP, KMON, REAC, TIN, TEST, PIN,
     3            PEST, LCNTUE, NCON, KCON, XCON)
C
C     INTERFACE TO STANJAN
C
      CALL EQUIL (LOUT, LPRNT, LSAVE, EQST, LCNTUE, ICKWRK, RCKWRK,
     1            LENIEQ, IEQWRK, LENREQ, REQWRK, MM, KK, ATOM,
     2            KSYM, NOP, KMON, REAC, TIN, TEST, PIN, PEST,
     3            NCON, KCON, XCON)
C
      IF (LCNTUE) GO TO 100
C
      STOP
      END
