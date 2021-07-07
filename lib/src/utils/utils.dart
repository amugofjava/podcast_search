// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class Utils {
  /// List of timezone abbreviation codes and their assumed offset. Subject
  /// to change. Offsets may be updated at a later date.
  static const _timezones = {
    'ACDT': '+10:30',
    'ACST': '+09:30',
    'ACT': '-05:00',
    'ACWST': '+08:45',
    'ADT': '-03:00',
    'AEDT': '+11:00',
    'AEST': '+10:00',
    'AFT': '+04:30',
    'AKDT': '-08:00',
    'AKST': '-09:00',
    'AMST': '-03:00',
    'AMT': '+04:00',
    'ART': '-03:00',
    'AST': '-04:00', // Assume Atlantic
    'AT': '-04:00',
    'AWST': '+08:00',
    'AZOST': '+00:00',
    'AZOT': '-01:00',
    'AZT': '+04:00',
    'BDT': '+08:00',
    'BIT': '-12:00',
    'BNT': '+08:00',
    'BOT': '-04:00',
    'BRST': '-02:00',
    'BRT': '-03:00',
    'BST': '+01:00', // Assume British
    'BTT': '+06:00',
    'CAT': '+02:00',
    'CCT': '+06:30',
    'CDT': '-05:00', // Will have to assume Central rather than Cuba.
    'CEST': '+02:00',
    'CET': '+01:00',
    'CHADT': '+13:45',
    'CHAST': '+12:45',
    'CHOST': '+09:00',
    'CHOT': '+08:00',
    'CHST': '+10:00',
    'CHUT': '+10:00',
    'CIST': '-08:00',
    'CIT': '+08:00',
    'CKT': '-10:00',
    'CLST': '-03:00',
    'CLT': '-04:00',
    'COST': '-04:00',
    'COT': '-05:00',
    'CST': '-06:00', // Will have to assume Central rather than Cuba or China.
    'CT': '-06:00',
    'CVT': '-01:00',
    'CWST': '+08:45',
    'CXT': '+07:00',
    'DAVT': '+07:00',
    'DDUT': '+10:00',
    'EASST': '-05:00',
    'EAST': '-06:00',
    'EAT': '+03:00',
    'ECT': '-05:00',
    'EDT': '-04:00',
    'EEST': '+03:00',
    'EET': '+02:00',
    'EGST': '+00:00',
    'EGT': '-01:00',
    'EIT': '+09:00',
    'EST': '-05:00',
    'ET': '-05:00',
    'FET': '+03:00',
    'FJT': '+12:00',
    'FKST': '-03:00',
    'FKT': '-04:00',
    'FNT': '-02:00',
    'GALT': '-06:00',
    'GAMT': '-09:00',
    'GET': '+04:00',
    'GFT': '-03:00',
    'GILT': '+12:00',
    'GIT': '-09:00',
    'GMT': '+00:00',
    'GST': '-02:00', // Assume South Gorgia
    'GYT': '-04:00',
    'HADT': '-09:00',
    'HAST': '-10:00',
    'HKT': '+08:00',
    'HMT': '+05:00',
    'HOVST': '+08:00',
    'HOVT': '+07:00',
    'ICT': '+07:00',
    'IDT': '+03:00',
    'IOT': '+06:00',
    'IRDT': '+04:30',
    'IRKT': '+08:00',
    'IRST': '+03:30',
    'IST': '+01:00', // Assume Irish
    'JST': '+09:00',
    'KGT': '+06:00',
    'KOST': '+11:00',
    'KRAT': '+07:00',
    'KST': '+09:00',
    'LHDT': '+11:00',
    'LHST': '+10:30',
    'LINT': '+14:00',
    'MAGT': '+11:00',
    'MART': '-09:30',
    'MAWT': '+05:00',
    'MDT': '-06:00',
    'MHT': '+12:00',
    'MIST': '+11:00',
    'MIT': '-09:30',
    'MMT': '+06:30',
    'MSK': '+03:00',
    'MST': '+08:00', // Assume Mountain
    'MT': '-07:00',
    'MUT': '+04:00',
    'MVT': '+05:00',
    'MYT': '+08:00',
    'NCT': '+11:00',
    'NDT': '-02:30',
    'NFT': '+11:00',
    'NPT': '+05:45',
    'NRT': '+12:00',
    'NST': '-03:30',
    'NT': '-03:30',
    'NUT': '-11:00',
    'NZDT': '+13:00',
    'NZST': '+12:00',
    'OMST': '+06:00',
    'ORAT': '+05:00',
    'PDT': '-07:00',
    'PET': '-05:00',
    'PETT': '+12:00',
    'PGT': '+10:00',
    'PHOT': '+13:00',
    'PHT': '+08:00',
    'PKT': '+05:00',
    'PMDT': '-02:00',
    'PMST': '-03:00',
    'PONT': '+11:00',
    'PST': '-08:00', // Assume Pacific
    'PT': '-08:00',
    'PWT': '+09:00',
    'PYST': '-03:00',
    'PYT': '-04:00',
    'RET': '+04:00',
    'ROTT': '-03:00',
    'SAKT': '+11:00',
    'SAMT': '+04:00',
    'SAST': '+02:00',
    'SBT': '+11:00',
    'SCT': '+04:00',
    'SGT': '+08:00',
    'SLST': '+05:30',
    'SRET': '+11:00',
    'SRT': '-03:00',
    'SST': '-11:00',
    'SYOT': '+03:00',
    'TAHT': '-10:00',
    'TFT': '+05:00',
    'THA': '+07:00',
    'TJT': '+05:00',
    'TKT': '+13:00',
    'TLT': '+09:00',
    'TMT': '+05:00',
    'TOT': '+13:00',
    'TRT': '+03:00',
    'TVT': '+12:00',
    'ULAST': '+09:00',
    'ULAT': '+08:00',
    'USZ1': '+02:00',
    'UTC': '+00:00',
    'UYST': '-02:00',
    'UYT': '-03:00',
    'UZT': '+05:00',
    'VET': '-04:00',
    'VLAT': '+10:00',
    'VOLT': '+04:00',
    'VOST': '+06:00',
    'VUT': '+11:00',
    'WAKT': '+12:00',
    'WAST': '+02:00',
    'WAT': '+01:00',
    'WEST': '+01:00',
    'WET': '+00:00',
    'WFT': '+12:00',
    'WGST': '-03:00',
    'WIB': '+07:00',
    'WIT': '+09:00',
    'WST': '+08:00',
    'YAKT': '+09:00',
    'YEKT': '+05:00',
  };

  static const _allowablePatterns = {
    // Mon, 03 Jun 2019 10:00:00 PDT (type 1)
    '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([A-Za-z]{3})': 1,

    // Mon, 03 Jun 2019 10:00:00 +02:30 (type 2)
    '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([\+|\-][0-9][0-9]:[0-9][0-9])':
        2,

    // Mon, 03 Jun 2019 10:00:00 +0230 (type 3)
    '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([\+|\-][0-9][0-9][0-9][0-9])':
        2
  };

  static const _months = {
    'jan': '01',
    'feb': '02',
    'mar': '03',
    'apr': '04',
    'may': '05',
    'jun': '06',
    'jul': '07',
    'aug': '08',
    'sep': '09',
    'oct': '10',
    'nov': '11',
    'dec': '12',
  };

  /// Dart will only correct zoned times in standard ISO format. The specification for
  /// podcasts uses a RFC2822 format date such as 'Mon, 03 Jun 2019 10:00:00 PDT'. This
  /// utility class will convert the date string [DateTime] into the standard ISO format so
  /// the Dart date parsing routines can then parse it.
  ///
  /// This is *not* an ideal implementation. Timezone abbreviation codes are ambiguous
  /// as there are multiple versions of zones such as CST (Central, China or Cuban time?).
  /// However, there is no ideal solution when parsing a date that uses an abbreviated
  /// timezone code, so this will probably suffice for a large proportion of dates in that
  /// format. Hopefully, most pubDate values will use a UTC offset instead.
  static DateTime? parseRFC2822Date(String date) {
    var result;

    _allowablePatterns.forEach((k, v) {
      final exp = RegExp(k);

      if (exp.hasMatch(date)) {
        Match match = exp.firstMatch(date)!;

        // Now, convert date to ISO format
        var month = _months[match.group(3)!.toLowerCase().substring(0, 3)];
        var offset = v == 1 ? _timezones[match.group(6)!] : match.group(6);
        var day = match.group(2)!.padLeft(2, '0');

        var iso = '${match.group(4)}-$month-${day}T${match.group(5)}$offset';

        result = DateTime.parse(iso);
      }
    });

    // If we have not found a match maybe it's an ISO 8601 date
    result ??= DateTime.tryParse(date);

    return result;
  }
}
