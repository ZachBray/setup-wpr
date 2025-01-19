if ([string]::IsNullOrWhiteSpace($Env:TRACE_FILE_NAME)) {
  $Env:TRACE_FILE_NAME = "trace.etl"
}

if (-not (Test-Path "$($Env:WPR_INSTALL_LOCATION)\wpr.exe")) {
  throw 'WPR is not installed. Please ensure the setup-wpr action has run.'
}

Write-Output "Saving trace using '$($Env:WPR_INSTALL_LOCATION)\wpr.exe -stop $($Env:TRACE_FILE_NAME)'"

& "$($Env:WPR_INSTALL_LOCATION)\wpr.exe" -stop $Env:TRACE_FILE_NAME