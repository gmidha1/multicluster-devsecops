.PHONY: default
default: help

.PHONY: help
# No need to add a comment here as help is described in common/
help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) common/Makefile | sort | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

%:
	make -f common/Makefile $*

install: deploy ## installs the pattern, inits the vault and loads the secrets
	make vault-init
	make load-secrets
	echo "Installed"

common-test:
	make -C common -f common/Makefile test

test:
	make -f common/Makefile CHARTS="$(wildcard charts/all/*)" PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test
	make -f common/Makefile CHARTS="$(wildcard charts/hub/[b-z]*) $(wildcard charts/hub/acs/*)" PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test
	#make -f common/Makefile CHARTS="$(wildcard charts/region/*)" PATTERN_OPTS="-f values-region-one.yaml" test

super-linter: ## Runs super linter locally
	make -f common/Makefile DISABLE_LINTERS="-e VALIDATE_ANSIBLE=false -e VALIDATE_TEKTON=false" super-linter
