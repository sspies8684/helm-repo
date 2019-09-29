chartdir = charts
chartsubdirs = $(wildcard $(chartdir)/*)
charts = $(notdir $(chartsubdirs))

all : index.yaml
var :
	echo $(charts)

% : charts/%
	helm package $<

.PHONY : var all

index.yaml : $(charts)
	helm repo index .


