# langcomp

## About

langcomp is a small PowerShell script for converting easily-managable json string localizations into Microsoft `.rc` files.

## Why?

* `.rc` files must either only contain ASCII characters, with special characters escaped
* or must be encoded in UCS2 (which git dislikes and recognizes as binary)
* managing a separate file for each language is much harder
* resource compiler syntax is much more complex and confusing for a non-programmer

## How to use?

Add this to your compilation:

`langcomp.ps1 <folder for .jsons> <output .rc name>`

The json format is the following:

```json
{
	"langid":              "LANG_JAPANESE",
	"sublangid":           "SUBLANG_DEFAULT",
	"strings": {
		"BANANA":              "バナナ",
	}
}
```

Saving this as an UTF-8 .json into the source folder will generate the following block in the output RC file:

```
LANGUAGE LANG_JAPANESE, SUBLANG_DEFAULT
STRINGTABLE
BEGIN
	IDS_BANANA	"バナナ"
END
```

## License

	langcomp - Localization to resource file compiler
	Copyright (C) 2020  namazso
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.

As an exception, code portions that "end up" in the output resource are exempt from this license, and are public domain. That is, using this in your build won't impose any additional restrictions on the generated resource file.