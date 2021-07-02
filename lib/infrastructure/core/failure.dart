/// Throws this [Exception] when device not have internet connection
class NoInternetConection implements Exception {}
/// Throws this [Exception] when `IsService` function return a [EmptyList]
class EmptyList implements Exception {}
/// Throws this [Exception] when catch a `Http` exception or 
/// if `IsService` function return a nonzero errorCode
class ServerError implements Exception {}
/// Throws this [Exception] when `Formater` deleteImageFormatAndDecode method 
/// throw an error 
class ImageDecoderError implements Exception {}
/// Throws this [Exception] when `Formater` parseDateTime method throw an error 
class DateParserError implements Exception {}
/// Throws this [Exception] when `Formater` downloadProfileImageOrDecodeString
/// method throw an error 
class ImageDownloaderError implements Exception {}

//class FormaterError implements Exception {}

/// Throws this [Exception] when `Formater` splitDisplayName method throw an 
/// error 
class NameParserError implements Exception {}

/// Throws this [Exception] when `LocalRepository`method throw an error 
class LocalCacheError implements Exception {}