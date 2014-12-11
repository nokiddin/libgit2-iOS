PROJECT:=git2-iOS

first: $(PROJECT).out

$(PROJECT).out:
	echo Building "$(PROJECT)" 
	./build-main.sh $(PROJECT)-univ

