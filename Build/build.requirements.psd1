@{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath = $True
    }

    # Grab some modules without depending on PowerShellGet
    'psake' = @{ DependencyType = 'PSGalleryModule' }
    'PSDeploy' = @{ DependencyType = 'PSGalleryModule' }
    'BuildHelpers' = @{ DependencyType = 'PSGalleryModule' }
    'Pester' = @{ DependencyType = 'PSGalleryModule' }
    'PlatyPS' = @{ DependencyType = 'PSGalleryModule' }
}