#!/bin/bash
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# applying git url patches to allow the use of private repositories
awk 'BEGIN{for(v in ENVIRON) print v}' | grep '^GIT_URL_OVERRIDE' | while read -r url_patch
do
 echo git config --global url."${!url_patch%%;*}".insteadOf "${!url_patch##*;}"
done

staticcheck ${INPUT_STATICCHECK_FLAGS} -f=json ${INPUT_TARGET:-.} \
  | jq -f /to-rdjsonl.jq -c \
  | reviewdog \
      -f="rdjsonl" \
      -name="staticcheck" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
