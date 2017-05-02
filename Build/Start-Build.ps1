[Cmdletbinding()]
param (
    $Task = 'Default'
)
# Import-Module -Name PowershellGet

# Removed the forced versioning on the import, was giving me a lot of problems with how the folders were named on
# ubuntu
function Resolve-Module {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline)]
        [string]$Name
    )
    # removed the foreach, might as well use the pipeline
    process {
        $Module = Get-Module -Name $Name -ListAvailable
        Write-Verbose -Message "Resolving Module $($Name)"

        if ($Module) {
            # TODO: Blocking this section out for right now. Causing versioning problems even with the latest pulled from
            # git
            
            # $Version = $Module | Measure-Object -Property Version -Maximum | 
            #                         Select-Object -ExpandProperty Maximum
            # $PsGalleryModule = Find-Module -Name $Name -Repository PSGallery
            # $GalleryVersion = $PsGalleryModule | Measure-Object -Property Version -Maximum | 
            #                                         Select-Object -ExpandProperty Maximum

            # if ($Version -lt $GalleryVersion) {
            #     if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') { 
            #         Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
            #     }

            #     Write-Verbose -Message ("$($Name) Installed Version [$($Version.tostring())] is " +
            #                             "outdated. Installing Gallery Version [$($GalleryVersion.tostring())]")
            #     Install-Module -Name $Name -Force
            #     Import-Module -Name $Name -Force -RequiredVersion $GalleryVersion
            # }
            # TODO: Not as safe to not force the import, but wasn't picking up the module even though it was
            # already imported
            if (-not(Get-Module -Name $Name)) {
                Write-Verbose -Message "Module Installed, Importing $($Name)"
                Import-Module -Name $Name -Force
                
            }
            Write-Verbose -Message "$($Name) installed and imported, continuing"
        }
        else {
            Write-Verbose -Message "$($Name) Missing, installing Module"
            Install-Module -Name $Name -Force
            Import-Module -Name $Name -Force
        }
    }
}

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

# NOTE: module names are case-sensitive for linux
'psake', 'PSDeploy', 'Pester', 'BuildHelpers', 'PSScriptAnalyzer' | Resolve-Module

# if (-not (Get-Module -ListAvailable PSDepend)) {
#     & (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
# }
#Import-Module PSDepend
#$null = Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force

Set-BuildEnvironment -Force

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )