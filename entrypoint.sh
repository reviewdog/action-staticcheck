#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ -n "${RUNNER_TOOL_CACHE}" ]; then
  # https://github.com/actions/toolkit/blob/83dd3ef0f1e5bc93c5ab7072e1edf1715a01ba9d/packages/tool-cache/src/tool-cache.ts#L547
  mkdir -p "${RUNNER_TOOL_CACHE}/action-staticcheck"
  ls "${RUNNER_TOOL_CACHE}/action-staticcheck" # debug
  export XDG_CACHE_HOME="${RUNNER_TOOL_CACHE}/action-staticcheck"
fi

staticcheck ${INPUT_STATICCHECK_FLAGS} -f=json ${INPUT_TARGET:-.} \
  | tmpl -f=jsonl /json.tmpl \
  | reviewdog \
      -efm="%f:%l:%c: %m" \
      -name="staticcheck" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
