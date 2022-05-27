echo "Signing subframeworks"
pushd "${TARGET_BUILD_DIR}"/"${PRODUCT_NAME}".app/Frameworks/YOURFRAMEWORKNAME.framework/Frameworks
for EACH in *.framework; do
echo "-- signing ${EACH}"
/usr/bin/codesign --force --deep --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --entitlements "${TARGET_TEMP_DIR}/${PRODUCT_NAME}.app.xcent" --timestamp=none $EACH
done
popd

echo "BUILD DIR ${TARGET_BUILD_DIR}"

