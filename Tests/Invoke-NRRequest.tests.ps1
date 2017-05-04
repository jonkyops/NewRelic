if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\.. -Force
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path -Path $ENV:BHProjectPath -ChildPath $ENV:BHProjectName) -Force

InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    $ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    Describe "Invoke-NRRequest PS$PSVersion" {
        Context 'Returns' {
            # Make sure we get a pscustomobject back, we'll be converting from json in the function
            It 'Returns a powershell custom object' {
                $Splat = @{
                    'ApiKey' = '00000000000000000000000000000000000000000000000'
                    'Uri' = 'newrelic.com'
                    'Method' = 'GET'
                }
                # simulate a working web request
                Mock -CommandName Invoke-WebRequest {
                    return [HtmlWebResponseObject] @{
                        StatusCode = 200
                        Content = @{ Servers = 'Test' } | ConvertTo-Json
                    }
                }

                (Invoke-NRRequest @Splat).GetType() | Should Be 'PSCustomObject'
            }
        }

        Context 'Error Handling' {
            # Bad api key
            $Splat = @{
                'ApiKey' = '00000000000000000000000000000000000000000000000'
                'Uri'= 'https://api.newrelic.com/v2/servers.json?'
                'Method' = 'GET'
            }
            It 'Returns an error when failing to log in' {
                { Invoke-NRRequest @Splat } | Should Throw 'The API key provided is invalid'
            }

            # Bad uri
            $Splat = @{
                'ApiKey' = '00000000000000000000000000000000000000000000000'
                'Uri' = 'https://api.newrelic.com/v2/servers.thisisabaduri?'
                'Method' = 'GET'
            }
            It 'Returns an error when the uri is bad' {
                { Invoke-NRRequest @Splat } | Should Throw 'The uri provided is invalid'
            }
        }
    }
}