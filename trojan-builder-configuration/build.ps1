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
    @{ Path = 'source\Template.vbp'; Exe = 'TrojanConfigTemplate.exe' },
    @{ Path = 'source\Builder.vbp'; Exe = 'TrojanConfigBuilder.exe' }
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

Write-Output "Build passed. Applications are in $OutputDirectory"
