# Get public and private function definition files.

$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($Import in @($Public + $Private)) {
    try {
        . $Import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($Import.fullname): $_"
    }
}

# Cmdlets and associated data types are defined in PowerShellLoggingModule.dll.  This script file just handles detaching the HostIOInterceptor object when the module unloads.
# $dllPath = Join-Path -Path $MyInvocation.MyCommand.ScriptBlock.Module.ModuleBase -ChildPath PowerShellLoggingModule.dll
# try {
#     Import-Module -Name $dllPath -ErrorAction Stop
# }
# catch {
#     throw
# }

# $MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
#     [PSLogging.HostIOInterceptor]::Instance.RemoveAllSubscribers()
#     [PSLogging.HostIOInterceptor]::Instance.DetachFromHost()
# }