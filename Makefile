chartdir = charts
chartsubdirs = $(wildcard $(chartdir)/*)
charts = $(notdir $(chartsubdirs))
version = $(shell yq r $1/Chart.yaml version)
tarball = $(notdir $1-$(call version,$1).tgz)
all_chart_tarballs = $(foreach c,$(charts),$(call tarball,$(chartdir)/$c))
find_requirements = $(shell find $1/ -type f)

define set_variable_template =
$1 = $2
endef

# set chart_tarball variables
$(foreach t,$(charts),$(eval $(call set_variable_template,$(t)_tarball,$(call tarball,$(chartdir)/$t))))
$(foreach t,$(charts),$(eval $(call set_variable_template,$(call tarball,$(chartdir)/$t)_chart,$t)))

# set chart_requirements variables
$(foreach t,$(charts),$(eval $(call set_variable_template,$(t)_requirements,$(call find_requirements,$(chartdir)/$t))))

.PHONY : var all clean

all : var index.yaml

clean :
	@rm -rf $(all_chart_tarballs) index.yaml
var :
	@echo Chart Directories $(chartsubdirs)
	@echo Chart Tarballs $(all_chart_tarballs)

.SECONDEXPANSION:

$(all_chart_tarballs) : $$($$($$@_chart)_requirements)
	helm package $(chartdir)/$($@_chart)

index.yaml : $(all_chart_tarballs)
	helm repo index .
	@echo index.yaml created

