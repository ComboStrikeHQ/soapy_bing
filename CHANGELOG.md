# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2019-01-28
### Added
- This CHANGELOG
- The BindAds API now supports a `ReportTimeZone` parameter, which we set to
  `GreenwichMeanTimeDublinEdinburghLisbonLondon` (GMT) by default. It can be
  changed via the `settings` parameter (see README). A list of time zone names
  is available
  [here](https://docs.microsoft.com/en-us/bingads/reporting-service/reporttimezone?view=bingads-12).

### Changed
- Use BingAds API version 12. The client's API remains unchanged. The returned
  data structures may have changed. Details are listed in the [BingAds API
  docs](https://docs.microsoft.com/en-us/bingads/guides/migration-guide?view=bingads-12#reporting).
