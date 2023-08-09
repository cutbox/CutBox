build ::
	xcodebuild

test_bin :: build
	cp -v build/Release/cutbox ../test_bin/

install :: build
	cp -v build/Release/cutbox /usr/local/bin/cutbox

verify_test :: test_bin
	../test_bin/cutbox -h
