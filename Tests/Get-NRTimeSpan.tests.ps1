if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\.. -Force
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path -Path $ENV:BHProjectPath -ChildPath $ENV:BHProjectName) -Force

InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    Describe "Get-NRTimeSpan PS$PSVersion" {
        
        # Not sure how good these tests are, since it's not accounting for adding the filters or body
        Context 'Returns' { 
            It 'Returns a string' {
                $Start = (Get-Date).AddDays(-1)
                $End = Get-Date
                (Get-NRTimeSpan -Start $Start -End $End).GetType() | Should Be 'string'
            }

            It 'Returns a string with the correct time span' {
                $TimeSpan = Get-NRTimeSpan -Start (Get-Date).AddDays(-1) -End (Get-Date)
                $Dates = $TimeSpan -split '&' -replace 'from=' -replace 'to='

                (New-TimeSpan -Start $Dates[0] -End $Dates[1]).Days | Should Be 1
            }
        }
    }
}
