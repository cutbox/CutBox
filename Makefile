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

check_localized_strings:
	plutil -lint $(LOCALIZATION_FILES)
	echo "# Check localization strings" | tee -a "$GITHUB_STEP_SUMMARY"
	for lang in $(LANGUAGES); do \
		bin/check_localization "CutBox/Localization/$$lang.lproj/Localizable.strings"; done

check_app_strings:
	echo "### Ensure localization strings correlate" | tee -a "$GITHUB_STEP_SUMMARY"
	bin/check_l7n_source

build ::
	bin/build

cli_test ::
	bin/command_line_test

dmg ::
	bin/cutbox_make_dmg CutBox.dmg

ci_get_release_info ::
	bin/ci_get_release_info
