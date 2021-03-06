# FILE     Makefile
# PACKAGE  ThermoProps 
# AUTHOR   Edward S. Blurock
#
# CONTENT
#   GNU Makefile for the STURM documentation.
#
# COPYRIGHT (C) 1997 Reaction Library

include ../../etc/Reaction/MakeDef

#V Variable definitions.
PackageRoot:=$(shell cd ..; pwd)
export PackageRoot
texidirs:=$(filter-out %/Config,$(shell cd ../../src; find * -type d -print ))


#F Targets.

all: dvi info texi html

dvi: texi
	@echo Building "doc/ThermoProps.dvi" ...
	-@texi2dvi ThermoProps.texi
	@mv ThermoProps.dvi ..
	@echo Building "doc/ThermoProps.dvi" finished.

info: texi
	@echo Building "info/ThermoProps.info*" ...
	-@makeinfo --no-validate --error-limit 10 ThermoProps.texi
	@$(RM) -f ../../info/*.info*
	@mv *.info* ../../info
	@echo Building "info/ThermoProps.info*" finished.

html: texi
	@echo Building "doc/*.html" ...
	@$(RM) -f ../*.html
	-@cd ..; texi2html -expandinfo -split_node -verbose -menu Texi/ThermoProps.texi
	@echo Building "doc/*.html" finished.

texi:
	@echo Creating directories ...
	@-umask 000; mkdir Functions 2>/dev/null
	@-umask 000; cd Functions; mkdir $(texidirs) 2>/dev/null
	@echo Building .texi files in \"Functions/*\" ...
	@find Functions/* -type d -exec \
	  $(MAKE) --no-print-directory -f $(CodeBaseRoot)/etc/Reaction/Makefile.doc -C {} all \;
	@echo Building function specifications \"Functions.texi\" ...
	@$(RM) Functions.texi
	@makesturmappendix Functions >Functions.texi
	@echo Building "Packages.texi" ...
	@$(RM) Packages.texi
	@cp Packages.head Packages.texi
	@echo >>Packages.texi @menu
	@find >>Packages.texi \
	  * -type d ! -name Functions \
	  -exec echo '*' {} Package:: \; -o '(' -name Functions -prune ')'
	@echo >>Packages.texi @end menu
	@find >>Packages.texi * -name Main.texi -exec echo @include {} \;
	@echo Building package description in \"ThermoProps/\" ...
	@cd ThermoProps; rm -f Classes.texi Overview.texi;\
	 touch Classes.texi Overview.texi;\
	 package2texi <../../../include/Reaction/ThermoPropsType.hh
	@echo Building .texi files finished.


clean::
	$(RM) -f *.aux *.log *.cp *.fn *.ky *.tp *.toc *.vr *.pg *.fns *.cps

cleaner::
	find Functions -type d -exec \
	  $(MAKE) -s -f $(CodeBaseRoot)/etc/Reaction/Makefile.doc CLEAN=1 -C {} cleaner \;
	$(RM) Functions.texi Packages.texi *.dvi *.info*
	$(RM) ThermoProps/Classes.texi ThermoProps/Overview.texi
	$(RM) ../*.html ../*.dvi ../../info/*.info*

#f Special targets.

.PHONY:	dvi info texi
