# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) pythonscript concat_files octave_rc.log move_spice spice1 spice2 spice3 spice4
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	
pythonscript:
	@echo
	@echo ************Introduza o número de aluno************
	python2.7 t2_datagen.py > data.txt
	
concat_files: pythonscript
	sed -i '1,14d' ../mat/rc_circuit.m
	cat data.txt ../mat/rc_circuit.m > rc_circuit_copy.m
	cp -f rc_circuit_copy.m ../mat/rc_circuit.m
	@rm -rf *_copy.m
	
octave_rc.log:
	octave ../mat/rc_circuit.m

move_spice: octave_rc.log
	mv circuitoL2init.net ../sim
	mv circuitoL2vs0.net ../sim
	mv circuitoL2natural.net ../sim
	mv circuitoL2natforced.net ../sim

spice1: spice1.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB| grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	
spice2: spice2.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB| grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab2.tex;)

spice3: spice3.log
	ps2pdf spicenat.ps spicenat.pdf
	
spice4: spice4.log
	ps2pdf spicenatforced.ps spicenatforced.pdf
	ps2pdf ampfreqresponse.ps ampfreqresponse.pdf
	ps2pdf phasefreqresponse.ps phasefreqresponse.pdf
	

spice1.log: ../sim/circuitoL2init.net
	ngspice -b $< -o $@
	
spice2.log: ../sim/circuitoL2vs0.net
	ngspice -b $< -o $@

spice3.log: ../sim/circuitoL2natural.net
	ngspice -b $< -o $@
	
spice4.log: ../sim/circuitoL2natforced.net
	ngspice -b $< -o $@


#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps
	@rm -rf *_tab.tex octave-workspace *.eps *_del.tex *_tab2.tex
	@rm -rf *_mesh.tex *_node.tex *.txt *_delete.m *.net

.PHONY: all clean ngspice octave


