PROJECT:=git2-iOS

first: $(PROJECT).out


fetch: submodulefetch

submodulefetch:
	git submodule update --init --recursive 

# CONFIGURATION is optional. It takes the values Debug and Release, and the pseudo-config BOTH (which is the default).
$(PROJECT).out:
	echo Building "$(PROJECT)" 
	./build-main.sh $(PROJECT)-univ $${CONFIGURATION}

