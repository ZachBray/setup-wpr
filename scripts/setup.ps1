function Write-ActionDebug {
  param(
    [Parameter(Mandatory = $true)]
    [object]$Text
  )
  
  $stringText = $Text | Out-String
  $stringText -split '\r?\n' | Where-Object { $_ } | ForEach-Object {
    Write-Host "::debug::$_"
  }
}

Write-ActionDebug "Installation working directory is: $PWD"

if (-not $IsWindows) {
  throw "This action requires Windows."
}

$workingDriveLetter = Split-Path $env:GITHUB_WORKSPACE -Qualifier
$workingFolder = "$workingDriveLetter\$([System.Guid]::NewGuid().ToString())"
New-Item -Path $workingFolder -ItemType Directory | Out-Null

Write-ActionDebug "Working folder is '$workingFolder'"

Push-Location $workingFolder

Write-ActionDebug "Downloading WPT"
$request = Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2196127" -OutFile "wpt.exe"
Write-ActionDebug "Downloaded WPT: $request"

$expectedSha256 = "FEA28F693139CDB55D2C993273B815147F804BB27BCB912F85ABAFC63FC6AAC8"
$actualSha256 = (Get-FileHash -Path "wpt.exe" -Algorithm SHA256).Hash

if ($actualSha256 -ne $expectedSha256) {
  throw "Hash verification failed!"
}
else {
  Write-Host "SHA256 verification of Windows Performance Toolkit installation package succeeded"
}

$installArguments = "/quiet /features OptionId.WindowsPerformanceToolkit"
Write-ActionDebug "Installing WPR with args '$installArguments'"
Start-Process -FilePath "wpt.exe" -ArgumentList $installArguments -Wait
Write-ActionDebug "Installed WPR"

$installLocation = "C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit"

Write-Output $installLocation >> $env:GITHUB_PATH
Write-Output "WPR_INSTALL_LOCATION=$installLocation" >> $env:GITHUB_ENV
Write-Output "Environment variable WPT_INSTALL_LOCATION set to '$installLocation'"
Write-Output "WPR added to PATH"