<script language="jscript" runat="server" charset="utf-8">
/*
File: json2.asp
AXE(ASP Xtreme Evolution) JSON parser based on Douglas Crockford json2.js.
This class is the result of Classic ASP JSON topic revisited by Fabio Zendhi 
Nagao (nagaozen). JSON2.ASP is a better option over JSON.ASP because it embraces
the AXE philosophy of real collaboration over the languages. It works under the
original json parser, so this class is strict in the standard rules, it also 
brings more of the Javascript json feeling to other ASP languages (eg. no more 
oJson.getElement("foo") stuff, just oJson.foo and you get it).
License:
This file is part of ASP Xtreme Evolution.
Copyright (C) 2007-2012 Fabio Zendhi Nagao
ASP Xtreme Evolution is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
ASP Xtreme Evolution is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public License
along with ASP Xtreme Evolution. If not, see <http://www.gnu.org/licenses/>.
Class: JSON
JSON (Javascript Object Notation) is a lightweight data-interchange format. It 
is easy for humans to read and write. It is easy for machines to parse and 
generate. It is based on a subset of the Javascript Programming Language, 
Standard ECMA-262 3rd Edition - December 1999. JSON is a text format that is 
completely language independent but uses conventions that are familiar to 
programmers of the C-family of languages, including C, C++, C#, Java, 
Javascript, Perl, Python, and many others. These properties make JSON an ideal 
data-interchange language.
Notes:
    - JSON parse/stringify from the Douglas Crockford json2.js <https://raw.githubusercontent.com/douglascrockford/JSON-js/master/json2.js>.
    - JSON.toXML is based on the Prof. Stefan Gössner "Converting Between XML and JSON" pragmatic approach <http://www.xml.com/pub/a/2006/05/31/converting-between-xml-and-json.html>.
    - JSON.minify is based on <https://github.com/getify/JSON.minify/blob/master/minify.json.js> and exists because of <https://plus.google.com/+DouglasCrockfordEsq/posts/RK8qyGVaGSr>.
About:
    - Written by Fabio Zendhi Nagao <http://zend.lojcomm.com.br/> @ August 2010
Function: parse
This method parses a JSON text to produce an object or array. It can throw a SyntaxError exception.
Parameters:
    (string) - Valid JSON text.
Returns:
    (mixed) - a Javascript value, usually an object or array.
Example:
(start code)
dim Info : set Info = JSON.parse(join(array( _
    "{", _
    "  ""firstname"": ""Fabio"",", _
    "  ""lastname"": ""??"",", _
    "  ""alive"": true,", _
    "  ""age"": 27,", _
    "  ""nickname"": ""nagaozen"",", _
    "  ""fruits"": [", _
    "    ""banana"",", _
    "    ""orange"",", _
    "    ""apple"",", _
    "    ""papaya"",", _
    "    ""pineapple""", _
    "  ],", _
    "  ""complex"": {", _
    "    ""real"": 1,", _
    "    ""imaginary"": 2", _
    "  }", _
    "}" _
)))
Response.write(Info.firstname & vbNewline) ' prints Fabio
Response.write(Info.alive & vbNewline) ' prints True
Response.write(Info.age & vbNewline) ' prints 27
Response.write(Info.fruits.get(0) & vbNewline) ' prints banana
Response.write(Info.fruits.get(1) & vbNewline) ' prints orange
Response.write(Info.complex.real & vbNewline) ' prints 1
Response.write(Info.complex.imaginary & vbNewline) ' prints 2
' You can also enumerate object properties ...
dim key : for each key in Info.enumerate()
    Response.write( key & vbNewline )
next
' which prints:
' firstname
' lastname
' alive
' age
' nickname
' fruits
' complex
set Info = nothing
(end code)
Function: stringify
This method produces a JSON text from a Javascript value.
Parameters:
    (mixed) - any Javascript value, usually an object or array.
    (mixed) - an optional parameter that determines how object values are stringified for objects. It can be a function or an array of strings.
    (mixed) - an optional parameter that specifies the indentation of nested structures. If it is omitted, the text will be packed without extra whitespace. If it is a number, it will specify the number of spaces to indent at each level. If it is a string (such as '\t' or '&nbsp;'), it contains the characters used to indent at each level.
Returns:
    (string) - a string that contains the serialized JSON text.
Example:
(start code)
dim Info : set Info = JSON.parse("{""firstname"":""Fabio"", ""lastname"":""??""}")
Info.set "alive", true
Info.set "age", 27
Info.set "nickname", "nagaozen"
Info.set "fruits", array("banana","orange","apple","papaya","pineapple")
Info.set "complex", JSON.parse("{""real"":1, ""imaginary"":1}")
Response.write( JSON.stringify(Info, null, 2) & vbNewline ) ' prints the text below:
'{
'  "firstname": "Fabio",
'  "lastname": "??",
'  "alive": true,
'  "age": 27,
'  "nickname": "nagaozen",
'  "fruits": [
'    "banana",
'    "orange",
'    "apple",
'    "papaya",
'    "pineapple"
'  ],
'  "complex": {
'    "real": 1,
'    "imaginary": 1
'  }
'}
set Info = nothing
(end code)
Function: toXML
This method produces a XML text from a Javascript value.
Parameters:
    (mixed) - any Javascript value, usually an object or array.
    (string) - an optional parameter that determines what tag should be used as a container for the output. Defaults to none.
Returns:
    (string) - a string that contains the serialized XML text.
Example:
(start code)
dim Info : set Info = JSON.parse("{""firstname"":""Fabio"", ""lastname"":""??""}")
Info.set "alive", true
Info.set "age", 27
Info.set "nickname", "nagaozen"
Info.set "fruits", array("banana","orange","apple","papaya","pineapple")
Info.set "complex", JSON.parse("{""real"":1, ""imaginary"":1}")
Response.write( JSON.toXML(Info) & vbNewline ) ' prints the text below:
'<firstname>Fabio</firstname>
'<lastname>??</lastname>
'<alive>true</alive>
'<age>27</age>
'<nickname>nagaozen</nickname>
'<fruits>banana</fruits>
'<fruits>orange</fruits>
'<fruits>apple</fruits>
'<fruits>papaya</fruits>
'<fruits>pineapple</fruits>
'<complex>
'    <real>1</real>
'    <imaginary>1</imaginary>
'</complex>
set Info = nothing
(end code)
Function: minify
This method can be used as a helper to enable comments in json-like 
configuration files. According to Douglas Crockford, using comments are fine if
you pipe the code before handing it to your JSON parser. See 
<https://plus.google.com/118095276221607585885/posts/RK8qyGVaGSr>
Parameters:
    (string) - a json-like configuration string
Returns:
    (json) - valid minified json
*/

if (typeof JSON !== 'object') {
    JSON = {};
}

if(!String.prototype.substitute) {
    String.prototype.substitute = function(object, regexp){
        return this.replace(regexp || (/\\?\{([^{}]+)\}/g), function(match, name){
            if(match.charAt(0) == '\\') return match.slice(1);
            return (object[name] != undefined) ? object[name] : '';
        });
    }
}


</script>