## 0.7.2

- Added retry to Apple charts API call to handle intermittent 503 errors.

## 0.7.1

- Add support for PC2.0 `<podcast:medium>` tag.

## 0.7.0

- Add support for PC2.0 `<podcast:remoteItem>` tag (at channel level).

## 0.6.9

- Bug fix: handle empty fields from iTunes and PodcastIndex API call results.

## 0.6.8

- BREAKING CHANGE: Language is now a text parameter (2-3 letter code) rather than enum. This is because iTunes largely
  ignores language, but PodcastIndex can use it for trending podcasts.

## 0.6.7

- Update example to handle null feed.
- Default podcast image to take iTunes version if available and fallback to channel version to be consistent with
  episode image handling.

## 0.6.6

- Minor bug fixes to the SRT parser.

## 0.6.5

- Add support for PC2.0 `<podcast:block>` tag.

## 0.6.4

- Add support for PC2.0 `<podcast:value>` tag.

## 0.6.3

- Bug fix: Handle lookup failures when fetching iTunes charts.

## 0.6.2

- Add support for Podcasting 2.0 GUID tag.

## 0.6.1

- Publication date is now optional.
- Additional exceptions for certificate & general errors.
- Move to Dio 5.x.

## 0.6.0

- Breaking change: Requires Dart 3.0.
- Add support for PC2.0 transcripts.
- Add support for PC2.0 persons.

## 0.5.5

- Improve PC2.0 chapter support.

## 0.5.4

- Add support for PC2.0 Transcripts (json/srt/subrip);

## 0.5.3

- Breaking change: Country class has been replace by Country enum.
- Breaking change: Language class has been replace by Language enum.
- Breaking change: Attribute class has been replace by Attribute enum.

## 0.5.2

- Add support for RSS content tag.

## 0.5.1

- Breaking change: Search provider is now passed when instantiating a Search object, rather than passing one at search
  time.
- Support for genres across iTunes & PodcastIndex.

## 0.5.0

- Stable null safe release
- Corrected author tag.

## 0.5.0-pre.2

- Add episode level image support via itunes:image tag.

## 0.5.0-pre.1

- Migrate to null-safety version.

## 0.4.1

- Add support for loading local RSS files.

## 0.4.0

- Add support for the podcast namespace (phase 1 tags).
- Add support for loading chapters JSON via url.
- Improve documentation.

## 0.3.9

- Update dependencies
- Add support for searching with PodcastIndex (Preview).

## 0.3.8

- Add optional user defined UserAgent prefix.

## 0.3.7

- Charts can be optionally filtered by genre.

## 0.3.6

- Update dependencies.

## 0.3.5

- Add support for iTunes season and episode tags.

## 0.3.4

- Update dependencies.

## 0.3.3

- If author attribute is not available use the iTunes one instead.
- Replace any dynamic variables with typed equivalent.
- Improve documentation.

## 0.3.2

- Now populates error values in the result set if the connection fails or times out.
- Added missing duration attribute.
- Episode author will use iTunes version if item author is null.

## 0.3.1

- Add support for returning podcast chart.

## 0.3.0

- Fix formatting.

## 0.2.9

- Fix lints for newer version of Pedantic.

## 0.2.8

- Handle null item enclosure.

## 0.2.7

- Add support for standard ISO 8601 publication dates.

## 0.2.6

- Remove redundant new and const keywords.

## 0.2.5

- Updated to latest test package to support Dart 2.6+.

## 0.2.4

- Added guid to Episode entity.

## 0.2.3

- Added missing format from list of possible pubdate formats.

## 0.2.2

- Dropped version of Meta to prevent clash with current SDK.

## 0.2.1

- Corrected issue with dependencies.

## 0.2.0

- Breaking change: Renamed Podcast to Item in search results.
- Added support for parsing a podcast RSS feed and returning podcast and episodes details.

## 0.1.2

- Correct copyright text to fix issues with documentation.

## 0.1.1

- Correct issues reported by health tool.

## 0.1.0

- Initial release.
