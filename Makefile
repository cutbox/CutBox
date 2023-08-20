setup ::
	bin/setup

test ::
	bin/test

test_ci ::
	bin/test_ci

test_themes ::
	bin/test_themes

check_localizable_strings ::
	plutil -lint CutBox/*lproj/*.strings

build ::
	bin/build

cli_test ::
	bin/command_line_test

dmg ::
	bin/cutbox_make_dmg CutBox.dmg

ci_get_release_info ::
	bin/ci_get_release_info
