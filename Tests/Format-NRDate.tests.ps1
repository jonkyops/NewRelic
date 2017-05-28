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

    Describe "Format-NRDate PS$PSVersion" {
        Context 'Returns' { 
            It 'Returns a string' {
                (Format-NRDate).GetType() | Should Be 'string'
            }

            It 'Returns a string that can be converted to a date' {
                (Get-Date -Date (Format-NRDate)).GetType() | Should Be 'DateTime'
            }

            It 'Returns the correct date' {
                $Date = Get-Date -Format s
                Get-Date -Date (Format-NRDate -Date $Date) -Format s | Should Be $Date
            }

            It 'Returns the local time' {
                $Date = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
                Format-NRDate -Date $Date -UseLocalTime | Should Be $Date
            }
        }

        Context 'Inputs' {
            It 'Accepts a datetime object' {
                {Format-NRDate -Date (Get-Date)} | Should Not throw
            }

            It 'Accepts a string with a datetime format' {
                (Get-Date -Date (Format-NRDate -Date '01/01/2017')).GetType() | Should Be 'DateTime'
            }
        }
    }
}
