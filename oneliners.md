One (or nearly one) liner scripts for Powershell, Bash, Python, or similar.

# PowerShell

## Convert AD domain username to SID or vice-versa
Probably requires AD powershell modules
### Input: domain+username, Output: SID
```powershell
((New-Object System.Security.Principal.NTAccount("domain.tld","username")).Translate([System.Security.Principal.SecurityIdentifier])).Value
```

### Input: SID, Output: domain\username
```powershell
((New-Object System.Security.Principal.SecurityIdentifier("SID")).Translate([System.Security.Principal.NTAccount])).Value
```


## Set PC time zone based on last logged in DC location in Sites and Services
### This requires your AD Sites and Services locations to be set correctly.
### Example uses placeholders for site names and time zones
```powershell
switch ([__ComObject].InvokeMember('SiteName', 'GetProperty', $null, (New-Object -ComObject ADSystemInfo), $null)) {
	CSTlocation1 { $locTZ = "Central Standard Time" }
	CSTlocation2 { $locTZ = "Central Standard Time"  }
	ESTLocation { $locTZ = "Eastern Standard Time"  }
}

Set-TimeZone -Name $locTZ -WhatIf
```
