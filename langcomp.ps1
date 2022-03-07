$head = "#include `"resource.h`"

#define APSTUDIO_READONLY_SYMBOLS
#ifndef APSTUDIO_INVOKED
#include `"targetver.h`"
#endif
#include `"winres.h`"
#include `"verrsrc.h`"

#undef APSTUDIO_READONLY_SYMBOLS

#if !defined(AFX_RESOURCE_DLL)
";
$tail = "#endif
";
$body = "";

$default_json = Get-Content -Raw -Encoding UTF8 -Path $args[1] | ConvertFrom-Json;

Get-ChildItem -Path $args[0] -Filter *.json | % {
    $json = Get-Content -Raw -Encoding UTF8 $_.FullName | ConvertFrom-Json;
    $body += "LANGUAGE " + $json.langid + ", " + $json.sublangid + "`nSTRINGTABLE`nBEGIN`n";
    $default_json.strings | Get-Member -MemberType NoteProperty | % {
        $value_escaped = "";
        $value = $json.strings."$($_.Name)";
		If ($value -eq $null -or $value -eq "") {
			$value = $default_json.strings."$($_.Name)";
		}

# I wish resource compiler supported escape sequences properly
#        $value_bytes = [System.Text.Encoding]::UTF32.GetBytes($value);
#        For($i = 0; $i -lt $value_bytes.Length; $i += 4) {
#            $codepoint = [BitConverter]::ToInt32($value_bytes, $i);
#            $value_escaped += "\U{0:X8}" -f $codepoint;
#        }
        
        # until 0xFF we can just \x escape everything, instead of proper C++ escaping.
        # over 0xFF we can pass through everything, nothing needs escape there.
        $value.ToCharArray() | % {
            If([long]$_ -lt 128) {
                $value_escaped += "\x{0:X2}" -f [long]$_;
            } Else {
                $value_escaped += $_;
            }
        };
        $body += "`tIDS_$($_.Name)`t`"$value_escaped`"`n";
    }
    $body += "END`n";
};

$head + $body + $tail | Set-Content -Encoding Unicode -Path $args[2];
