if ([string]::IsNullOrWhiteSpace($Env:WPR_ARG_LIST)) {
  $Env:WPR_ARG_LIST = "-start GeneralProfile"
}

if (-not (Test-Path "$($Env:WPR_INSTALL_LOCATION)\wpr.exe")) {
  throw 'WPR is not installed. Please ensure the setup-wpr action has run.'
}

Start-Process -FilePath "$($Env:WPR_INSTALL_LOCATION)\wpr.exe" -ArgumentList $Env:WPR_ARG_LIST -Wait

Write-Output "Trace started using '$($Env:WPR_INSTALL_LOCATION)\wpr.exe $($Env:WPR_ARG_LIST)'"