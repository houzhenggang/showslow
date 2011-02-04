all:	updatecode updateusers assets updatedb 

updatecode:
ifneq "$(wildcard .git )" ""
	git pull origin master
	git submodule init
	git submodule update
endif

updateusers:
	cd users && $(MAKE)

updatedb:
	php dbupgrade.php

rel:	release
release: assets
ifndef v
	# Must specify version as 'v' param
	#
	#   make rel v=1.1.1
	#
else
	#
	# Tagging it with release tag
	#
	git tag -a REL_${subst .,_,${v}}
endif

# No need for this really since we patched Timeplot clone on Github
timeplot-patch:
	patch -p0 <timeplot.patch

# from svn-assets project
clean: noassets

assets:

# TODO write a tool to generate hash-based asset_versions and not VCS-based.
# TODO update .htaccess to support letters in hashes
#	if [ -d .svn ]; then svn status --verbose --xml |php svn-assets/svnassets.php > asset_versions.php; fi

# uncomment next line when we'll have any CSS files to process
#find ./ -name '*.css' -not -wholename "./timeplot/*" -not -wholename "./timeline/*" -not -wholename "./ajax/*" -not -wholename "./users/*" | xargs -n1 php svn-assets/cssurlrewrite.php

noassets:
	cp svn-assets/no-assets.php asset_versions.php
	find ./ -name '*_deploy.css' | xargs -n10 rm -f
