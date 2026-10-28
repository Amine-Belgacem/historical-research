param(
    [string]$Compiler = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\VB98\VB6.EXE",
    [string]$OutputDirectory = (Join-Path $PSScriptRoot 'build')
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Compiler -PathType Leaf)) {
    throw 'VB6 was not found. Supply -Compiler with the path to your licensed VB6 compiler.'
}
$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$projects = @(
    @{ Path = 'source\Template.vbp'; Exe = 'FtpTemplate.exe' },
    @{ Path = 'source\Builder.vbp'; Exe = 'FtpBuilder.exe' },
    @{ Path = 'tests\ConfigTests.vbp'; Exe = 'ConfigTests.exe' }
)
foreach ($project in $projects) {
    $projectFile = Join-Path $PSScriptRoot $project.Path
    $logFile = Join-Path $OutputDirectory ($project.Exe + '.log')
    # VB6 appends to /out logs, so start a fresh log for this build.
    [System.IO.File]::WriteAllText($logFile, '')
    $arguments = @('/make', ('"' + $projectFile + '"'), '/out', ('"' + $logFile + '"'), '/outdir', ('"' + $OutputDirectory + '"'))
    $process = Start-Process -FilePath $Compiler -ArgumentList $arguments -WindowStyle Hidden -PassThru
    if (-not $process.WaitForExit(45000)) {
        $process.Kill()
        throw "Build timed out: $($project.Path)"
    }
    if (Test-Path -LiteralPath $logFile) { Get-Content -LiteralPath $logFile }
    if ($process.ExitCode -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $OutputDirectory $project.Exe))) {
        throw "Build failed: $($project.Path). See $logFile"
    }
}

$testExecutable = Join-Path $OutputDirectory 'ConfigTests.exe'
$testLog = Join-Path $OutputDirectory 'self-test-results.txt'
[System.IO.File]::WriteAllText($testLog, '')
$testProcess = Start-Process -FilePath $testExecutable -WindowStyle Hidden -PassThru
if (-not $testProcess.WaitForExit(30000)) {
    $testProcess.Kill()
    throw 'The configuration self-tests timed out.'
}
if (Test-Path -LiteralPath $testLog) { Get-Content -LiteralPath $testLog }
if ($testProcess.ExitCode -ne 0 -or (Get-Content -LiteralPath $testLog -Raw) -notmatch '(?m)^PASS: \d+ checks\s*$') {
    throw 'The configuration self-tests failed.'
}

# Execute the newly generated display-only demo to verify it reads its own EXE.
$configuredExecutable = Join-Path $OutputDirectory 'SelfConfigured.exe'
$standaloneFolder = Join-Path $OutputDirectory ('standalone-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $standaloneFolder | Out-Null
$standaloneExecutable = Join-Path $standaloneFolder 'SelfConfigured.exe'
Copy-Item -LiteralPath $configuredExecutable -Destination $standaloneExecutable
$verificationProcess = Start-Process -FilePath $standaloneExecutable -ArgumentList '/verify-self' -WindowStyle Hidden -PassThru
if (-not $verificationProcess.WaitForExit(15000)) {
    $verificationProcess.Kill()
    throw 'The self-reading executable verification timed out.'
}
$verificationLog = $standaloneExecutable + '.verification.txt'
if ($verificationProcess.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $verificationLog)) {
    throw 'The generated executable could not read its own settings.'
}
$verification = Get-Content -LiteralPath $verificationLog -Raw
if ($verification -notmatch '(?m)^PASS: settings read from own EXE\s*$' -or
    $verification -notmatch '(?m)^Host=ftp\.embedded\.invalid\s*$' -or
    $verification -notmatch '(?m)^UserName=self-test-user\s*$' -or
    $verification -notmatch '(?m)^PasswordLength=16\s*$') {
    throw 'The generated executable did not restore the expected test settings.'
}
Write-Output 'PASS: the generated EXE ran alone in a separate folder and read its own embedded FTP settings.'
Write-Output "Build and tests passed. Applications are in $OutputDirectory"
