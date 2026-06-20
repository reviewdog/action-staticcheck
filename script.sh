#!/bin/sh
set -e

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

STATICCHECK_VERSION="2026.1"
echo '::group:: Installing staticcheck ... https://staticcheck.io'
if [ "${INPUT_USE_GO_INSTALL}" = "true" ]; then
  echo "Building staticcheck from source using go install..."
  GOBIN="${TEMP_PATH}" go install "honnef.co/go/tools/cmd/staticcheck@${STATICCHECK_VERSION}"
else
  echo "Downloading prebuilt staticcheck binary..."
  curl -sfL  "https://github.com/dominikh/go-tools/releases/download/${STATICCHECK_VERSION}/staticcheck_linux_amd64.tar.gz" | tar -xvz -C "${TEMP_PATH}" --strip-components=1
fi
staticcheck --version
go version -m "$(which staticcheck)"
echo '::endgroup::'


echo '::group:: Running staticcheck with reviewdog 🐶 ...'
staticcheck ${INPUT_STATICCHECK_FLAGS} -f=json ${INPUT_TARGET:-.} \
  | jq -f "${GITHUB_ACTION_PATH}/to-rdjsonl.jq" -c | \
   reviewdog \
      -f="rdjsonl" \
      -name="staticcheck" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-level="${INPUT_FAIL_LEVEL}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

exit_code=$?
echo '::endgroup::'

exit $exit_code
