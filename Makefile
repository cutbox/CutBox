setup ::
	bin/setup

test ::
	bin/test

test_ci ::
	bin/test_ci

test_themes ::
	bin/test_themes

LANGUAGES := cn ja ko th de fr es
LOCALIZATION_FILES := $(wildcard CutBox/Localization/*.lproj/Localizable.strings)

lint_localized_strings:
	plutil -lint $(LOCALIZATION_FILES)

check_localized_strings:
	for lang in $(LANGUAGES); do \
		bin/check_localization "CutBox/Localization/$$lang.lproj/Localizable.strings"; done

check_app_strings:
	bin/check_l7n_source

build ::
	bin/build

cli_test ::
	bin/command_line_test

dmg ::
	bin/cutbox_make_dmg CutBox.dmg

ci_get_release_info ::
	bin/ci_get_release_info
