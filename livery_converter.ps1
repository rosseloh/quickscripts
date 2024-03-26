### Script for quick X-Plane livery iteration
### Runs DDSTool.exe to convert specified PNG files to DDS and saves them to the
###  current livery's directory in the X-Plane directory, so all you have to do
###  after running it is to reload the file in XP using the texture browser.
###
### This script needs to be customized for every livery you're working on.
###  To do so, enter your xptools path and livery output directory path in their
###  respective variables, and the full paths for each PNG file to convert and 
###  move in the $fileList array.
###
### I'd also recommend renaming the script per-livery, if you plan to keep them
###  in a central location.


## Set these variables to match your particular setup and livery!
# Add your list of PNG files, with fully qualified paths (unless you run
#  the script from the livery's objects folder). Any number can be added, comma-
#  separated.
$fileList = @(
	'"H:\flightsim\liveries\LES-dc3\Bonanza-N498\objects\Fuselage.png"',
	'"H:\flightsim\liveries\LES-dc3\Bonanza-N498\objects\Engine_Front.png"',
	'"H:\flightsim\liveries\LES-dc3\Bonanza-N498\objects\Wing_Left.png"',
	'"H:\flightsim\liveries\LES-dc3\Bonanza-N498\objects\Wing_Right.png"'
)
$xpToolsPath = 'H:\xPlane\xptools'
$outputPath = 'G:\Flight Simulation\X-Plane 12\Aircraft\X-Aviation\Douglas DC-3 v2\liveries\Bonanza Air Lines - N498\objects\'



# Actual logic
$cmdStart = -join($xpToolsPath, '\tools\DDSTool.exe')

foreach ($file in $fileList) {
	$fileName = (Split-Path $file -Leaf).Split('.')[0]
	$outputFile = -join('"', $outputPath, $fileName, '.dds"')
	$params = '--png2dxt --std_mips --gamma_22 --scale_none', $file, $outputFile
	
	$cmd = "& `"$cmdStart`" $params"
	Write-Host Executing $cmd
	Invoke-Expression $cmd
}
