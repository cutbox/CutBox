#!/usr/bin/env bash

if [ "$ACTION" = "indexbuild" ]; then
  echo "Not running Cuckoo generator during indexing."
  exit 0
fi

# Skip for preview builds
if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  echo "Not running Cuckoo generator during preview builds."
  exit 0
fi

OUTPUT_FILE="${PROJECT_DIR}/CutBoxUnitTests/GeneratedMocks.swift"

echo "Generated Mocks File = ${OUTPUT_FILE}"

INPUT_DIR="${PROJECT_DIR}/Source"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"${PODS_ROOT}/Cuckoo/run" generate --testable "${PROJECT_NAME}" \
  --output "${OUTPUT_FILE}" \
    "${INPUT_DIR}/Components/PopupBackgroundView.swift" \
    "${INPUT_DIR}/Components/PopupContainerView.swift" \
    "${INPUT_DIR}/Components/PopupPanel.swift"
