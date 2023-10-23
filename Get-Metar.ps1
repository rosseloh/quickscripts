### METAR Retrieval Script        ###
### 10/23/2023 rosseloh           ###

# 7.1 is required for "-UFormat" in Get-Date to provide UTC output
#Requires -Version 7.1

# Initialize the session
Clear-Host
$new = 1
$quit = 0
$previous = $null
$latest = $null
<#
	$latest array, populated later, includes: 
		requested ICAO code
		system date/time code
		METAR result
		TAF result
		METAR date/time code
#>

# Menu options because I'm dumb and waste time on pointless things
$sameIcao = New-Object System.Management.Automation.Host.ChoiceDescription '&Check Again', 'Check the METAR for the same ICAO code'
$newIcao = New-Object System.Management.Automation.Host.ChoiceDescription '&Enter a new ICAO code', 'Enter a new ICAO code to check'
$quit = New-Object System.Management.Automation.Host.ChoiceDescription '&Quit', 'Quit the script'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($sameIcao, $newIcao, $quit)
$message = "What next?"

function Get-METARText ( $icao ) {
	$metar = (Invoke-WebRequest -URI https://aviationweather.gov/cgi-bin/data/metar.php?ids=$icao).Content
	if ( $metar -eq "" ) { $metar = "Invalid ICAO Code" }
	$taf = (Invoke-WebRequest -URI https://aviationweather.gov/cgi-bin/data/taf.php?ids=$icao).Content -replace "(?m)^\s+"
	if ( $taf -eq "" ) { $taf = "Invalid ICAO Code" }
	[array]$tafSplit = $taf.Split("`n")
	$date = $date = Get-Date -UFormat "%m/%d %R" -AsUTC # local system date and time in zulu
	$dateAndTime = ($metar -split " ")[1]  # date and time as pulled from the METAR in zulu, used to compare if a result is new or not
	return @( $icao, $date, $metar, $tafSplit, $dateAndTime)
}

# Main Loop

do {
	if ( $new -eq 1 ) {
		Clear-Host
		do {
			$icao = (Read-Host -Prompt "Enter a valid ICAO code").ToUpper() 
		} while ( $icao -eq "" ) 
	}
	
	$latest = Get-METARText ($icao)
	Clear-Host
	
	Write-Host
	Write-Host		
	Write-Host -ForegroundColor DarkRed -NoNewLine "Results as of "
	Write-Host -ForegroundColor DarkRed -NoNewLine $latest[1]
	Write-Host -ForegroundColor DarkRed "z:"
	Write-Host
	Write-Host -NoNewLine -ForegroundColor DarkRed "METAR`t"
	Write-Host -NoNewLine $latest[2]
	if ( $previous ) {
		if ( $latest[4] -eq $previous[1] -And $latest[0] -eq $previous[0] ) { # check if date and ICAO code matches 
			Write-Host -NoNewLine -ForegroundColor DarkGreen "`t- METAR unchanged since last query -" 
		}
	}
	Write-Host
	Write-Host
	Write-Host -NoNewLine -ForegroundColor DarkRed "TAF"
	$i = 0
	foreach ( $taf in $latest[3] ) {
		if ( $i -gt 0 ) { Write-Host -NoNewLine `t }
		Write-Host -NoNewLine `t
		Write-Host $taf
		$i++
	}
	$previous = @($latest[0], $latest[4])
	$result = $host.ui.PromptForChoice($title, $message, $options, 0)
	switch ( $result ) {
		0 { $new = 0 }
		1 { $new = 1 }
		2 { $quit = 1 }
	}
} until ( $quit -eq 1 )



