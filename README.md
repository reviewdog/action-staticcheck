# action-staticcheck

[![Test](https://github.com/reviewdog/action-staticcheck/workflows/Test/badge.svg)](https://github.com/reviewdog/action-staticcheck/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-staticcheck/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-staticcheck/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-staticcheck/workflows/depup/badge.svg)](https://github.com/reviewdog/action-staticcheck/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-staticcheck/workflows/release/badge.svg)](https://github.com/reviewdog/action-staticcheck/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-staticcheck?logo=github&sort=semver)](https://github.com/reviewdog/action-staticcheck/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This action runs [staticcheck](https://staticcheck.io/) with reviewdog on pull requests to improve code review experience.

[![github-pr-review demo](https://user-images.githubusercontent.com/3797062/81496355-1a58f580-92f2-11ea-809b-7e61f863c147.png)](https://github.com/reviewdog/action-staticcheck/pull/1#discussion_r422620536)
<sub>Link to the staticcheck check rule is available as well. e.g. [SA9004](https://staticcheck.io/docs/checks#SA9004)</sub>

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].'
    default: 'github-pr-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for staticcheck ###
  target:
    description: 'Target of staticcheck'
    default: './...'
  staticcheck_flags:
    description: 'staticcheck flags'
    default: ''
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  staticcheck:
    name: runner / staticcheck
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: reviewdog/action-staticcheck@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Report all results.
          filter_mode: nofilter
          # Exit with 1 when it find at least one finding.
          fail_on_error: true
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action template itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)

### Dependencies Update Automation
This repository uses [haya14busa/action-depup](https://github.com/haya14busa/action-depup) to update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/reviewdog/action-template/pull/6)

