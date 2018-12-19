xquery version "3.1";

declare variable $path-to-json external;
fn:json-to-xml(unparsed-text($path-to-json))