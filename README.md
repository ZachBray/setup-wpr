[![Tests](https://github.com/chad-golden/setup-wpr/actions/workflows/test.yml/badge.svg)](https://github.com/chad-golden/setup-wpr/actions/workflows/test.yml)

# Windows Performance Recorder Setup Action
This action sets up Windows Performance Recorder (WPR) in your GitHub Actions workflow. It provides functionality to install WPR, start recording traces, and stop recording with configurable output.

## Common Use Cases
Windows Performance Recorder (WPR) is used to diagnose performance issues and system behavior in Windows environments. Common use cases include:
- Debugging high CPU/memory usage/slow disk IO in applications
- Investigating slow startup or response times
- Analyzing system resource usage patterns
- Profiling performance bottlenecks in CI/CD pipelines
- Identifying bottlenecks in automated tests

This action automates WPR setup and trace collection in GitHub Actions workflows, making it easier to capture performance data during automated testing or deployment processes.

## Features
- Installs and configures Windows Performance Recorder (wpr.exe)
- Includes supporting actions for starting and stopping trace recording
- Works across multiple Windows versions (2019, 2022, 2025)
- Allows custom trace file output locations

## Usage
This action is split into three components:
- Setup: Installs and configures WPR
- Start: Begins trace recording
- Stop: Ends trace recording and saves the file

You may also wish to interact with WPR directly in your scripts if any of the components do not suit your needs, see `wpr.exe -help` for more details on WPR's capabilities.

### Basic Example

This example installs WPR, starts a trace, runs a build script, stops the trace, and finally uploads the trace file (`D:\my-trace.etl`) to the workflow artifacts section. The trace can be analyzed using Windows Performance Toolkit (WPT).

```yaml
steps:
- name: Setup WPR
  uses: chad-golden/setup-wpr@main

- name: Start trace
  uses: chad-golden/setup-wpr/start@main

- name: Build
  run: .\Build.ps1

- name: Stop trace
  uses: chad-golden/setup-wpr/stop@main
  with:
    trace-file-name: D:\my-trace.etl

- name: Upload Trace
  uses: actions/upload-artifact@v4
  with:
    name: trace-${{ matrix.runs-on }}-${{ github.run_id }}
    path: D:\my-trace.etl
```

## Inputs

### Start Action
- `start-options` (optional): Specify WPR recording profiles
  - Default: `-start GeneralProfile`
  - Example: `-start CPU -start FileIO`

### Stop Action
- `trace-file-name` (optional): Output path for the ETL trace file
  - Default: `D:\trace.etl`

## Requirements

- Windows runner (supports 2019, 2022, 2025)
- PowerShell 7 (pwsh)