
EXTENSION = systemapic
EXTVERSION = 0.0.0dev

SED = sed

SPSCRIPTS = \
  scripts/SP_ExtensionReload.sql \
  $(END)

UPGRADABLE = \
  $(EXTVERSION)next \
  $(END)

UPGRADES = \
  $(shell echo $(UPGRADABLE) | \
     $(SED) 's/^/$(EXTENSION)--/' | \
     $(SED) 's/$$/--$(EXTVERSION).sql/' | \
     $(SED) 's/ /--$(EXTVERSION).sql $(EXTENSION)--/g')

DATA_built = \
  $(EXTENSION)--$(EXTVERSION).sql \
  $(EXTENSION)--$(EXTVERSION)--$(EXTVERSION)next.sql \
  $(UPGRADES) \
  $(EXTENSION).control

EXTRA_CLEAN = *.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

$(EXTENSION)--$(EXTVERSION).sql: $(SPSCRIPTS) systemapic_version.sql Makefile 
	echo '\echo Use "CREATE EXTENSION $(EXTENSION)" to load this file. \quit' > $@
	if test -n "$(SPSCRIPTS)"; then cat $(SPSCRIPTS) >> $@; fi
	cat systemapic_version.sql >> $@

$(EXTENSION)--%--$(EXTVERSION).sql: $(EXTENSION)--$(EXTVERSION).sql
	cp $< $@

$(EXTENSION)--$(EXTVERSION)--$(EXTVERSION)next.sql: $(EXTENSION)--$(EXTVERSION).sql
	cp $< $@

$(EXTENSION).control: $(EXTENSION).control.in Makefile
	$(SED) -e 's/@@VERSION@@/$(EXTVERSION)/' $< > $@

systemapic_version.sql: systemapic_version.sql.in Makefile
	$(SED) -e 's/@@VERSION@@/$(EXTVERSION)/' $< > $@

