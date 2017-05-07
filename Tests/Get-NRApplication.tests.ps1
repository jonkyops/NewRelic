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

    Describe "Get-NRApplication PS$PSVersion" {
        BeforeAll {
            $ApiKey = '00000000000000000000000000000000000000000000000'
            
            <#
                This is meant to simulate the behavior of a web request like the ones mentioned here:
                https://docs.newrelic.com/docs/apis/rest-api-v2/application-examples-v2/summary-data-examples-v2
                
                It uses an array of all 3 apps (like an unfiltered request), 
                then looks for how the URI is formed (in the case of searching for a specific ID), 
                and if there is a body (in the case of looking for a specific name)
            #>
            Mock -CommandName Invoke-NRRequest {
                param (
                    [Uri]$Uri,
                    $Body
                )
                # These are all mock app objects meant to resemble what would normally be returned from this request
                $App1 = [PSCustomObject] @{
                    "id" = 1129082
                    "name" = "My Web Page"
                    "language" = "java"
                    "health_status" = "green"
                    "reporting" = true
                    "last_reported_at" = "2014-07-29T23 =45 =07+00 =00"
                    "application_summary" = @{
                        "response_time" = 304
                        "throughput" = 4570
                        "error_rate" = 0.0016
                        "apdex_target" = 523
                        "apdex_score" = 0.97
                    }
                    "end_user_summary" = @{
                        "response_time" = 3.73
                        "throughput" = 0.333
                        "apdex_target" = 0
                        "apdex_score" = 1
                    }
                    "settings" = @{
                        "app_apdex_threshold" = 0.5
                        "end_user_apdex_threshold" = 7
                        "enable_real_user_monitoring" = true
                        "use_server_side_config" = true
                    }
                    "links" = @{
                        "application_instances" = (
                            2928655,
                            3941052,
                            3940275,
                            3944066,
                            3943114,
                            3943147
                        )
                        "alert_policy" = 41534
                        "servers" = @()
                        "application_hosts" = (
                            2927654,
                            3940051,
                            3943274,
                            3943065,
                            3943513,
                            3943146
                        )
                    }
                }
                $App2 = [PSCustomObject] @{
                    "id" = 1129083
                    "name" = "My Web Page 2"
                    "language" = "python"
                    "health_status" = "red"
                    "reporting" = true
                    "last_reported_at" = "2014-07-29T23 =45 =07+00 =00"
                    "application_summary" = @{
                        "response_time" = 304
                        "throughput" = 4570
                        "error_rate" = 0.0016
                        "apdex_target" = 523
                        "apdex_score" = 0.97
                    }
                    "end_user_summary" = @{
                        "response_time" = 3.73
                        "throughput" = 0.333
                        "apdex_target" = 0
                        "apdex_score" = 1
                    }
                    "settings" = @{
                        "app_apdex_threshold" = 0.6
                        "end_user_apdex_threshold" = 8
                        "enable_real_user_monitoring" = true
                        "use_server_side_config" = true
                    }
                    "links" = @{
                        "application_instances" = (
                            2928655,
                            3941052,
                            3940275,
                            3944066,
                            3943114,
                            3943147
                        )
                        "alert_policy" = 41534
                        "servers" = @()
                        "application_hosts" = (
                            2927654,
                            3940051,
                            3943274,
                            3943065,
                            3943513,
                            3943146
                        )
                    }
                }
                $App3 = [PSCustomObject] @{
                    "id" = 1129095
                    "name" = "My Web Page 3"
                    "language" = "Java"
                    "health_status" = "red"
                    "reporting" = true
                    "last_reported_at" = "2014-07-29T23 =45 =07+00 =00"
                    "application_summary" = @{
                        "response_time" = 304
                        "throughput" = 4570
                        "error_rate" = 0.0016
                        "apdex_target" = 523
                        "apdex_score" = 0.97
                    }
                    "end_user_summary" = @{
                        "response_time" = 3.73
                        "throughput" = 0.333
                        "apdex_target" = 0
                        "apdex_score" = 1
                    }
                    "settings" = @{
                        "app_apdex_threshold" = 0.6
                        "end_user_apdex_threshold" = 8
                        "enable_real_user_monitoring" = true
                        "use_server_side_config" = true
                    }
                    "links" = @{
                        "application_instances" = (
                            2928655,
                            3941052,
                            3940275,
                            3944066,
                            3943114,
                            3943147
                        )
                        "alert_policy" = 41534
                        "servers" = @()
                        "application_hosts" = (
                            2927654,
                            3940051,
                            3943274,
                            3943065,
                            3943513,
                            3943146
                        )
                    }
                }
                $AllApps = $App1, $App2, $App3

                # specifying name
                # expected body is like 'filter[name]=My+Web+Page'
                if ($Body -and $Uri -notlike 'https://api.newrelic.com/v2/applications/*.json') {
                    # Extract the name from the body
                    $Name = ($Body.Get_Item('filter[name]')) -replace [regex]::escape('+'),' '

                    # Return the object that matches the name
                    $ReturnedApps = $AllApps | Where-Object { $_.Name -eq $Name }
                }
                elseif ($Uri -like 'https://api.newrelic.com/v2/applications/*.json') {
                    # extract just the ID
                    [int]$Id = $Uri.Segments[-1] -replace '.json'

                    # Return the object that matches the id
                    $ReturnedApps = $AllApps | Where-Object { $_.Id -eq $Id }
                }
                else { 
                    Write-Debug -Message 'Entering else'
                    $ReturnedApps = $AllApps
                }

                # return an object with the correct property name
                if ($ReturnedApps.Length -gt 1) {
                    [PSCustomObject] @{ "applications" = $ReturnedApps }
                }
                else {
                    [PSCustomObject] @{ "application" = $ReturnedApps }
                }
            }
        }
        
        # Not sure how good these tests are, since it's not accounting for adding the filters or body
        Context 'Returns' {
            It 'Returns a powershell custom object when getting all apps back' {
                (Get-NRApplication -ApiKey $ApiKey -ID '1129083').GetType() | Should Be 'System.Management.Automation.PSCustomObject'
            }

            It 'Returns a powershell custom object when specifying an application' {
                (Get-NRApplication -ApiKey $ApiKey -ID '1129083').GetType() | Should Be 'System.Management.Automation.PSCustomObject'
            }

            It 'Returns all applications when no name or id is specified' {
                (Get-NRApplication -ApiKey $ApiKey).Length | Should Be 3
            }

            It 'Returns a specific application when name is specified' {
                $Name = 'My Web Page'
                (Get-NRApplication -ApiKey $ApiKey -Name $Name).Name | Should Be 'My Web Page'
            }

            It 'Returns a specific application when id is specified' {
                $Id = 1129083
                (Get-NRApplication -ApiKey $ApiKey -Id $Id).Name | Should Be 'My Web Page 2'
            }

            It 'Returns applications based on pipeline input for names' {
                $Names = 'My Web Page 2', 'My Web Page 3'
                
                ($Names | Get-NRApplication -ApiKey $ApiKey).Id | Should Be (1129083, 1129095)
            }

            It 'Returns applications based on pipeline input for ID' {
                $Ids = 1129083, 1129095
                
                ($Ids | Get-NRApplication -ApiKey $ApiKey).Name | Should Be ('My Web Page 2', 'My Web Page 3')
            }
        }

        Context 'Error Handling' {
            # using ID and name params returns an error
            $ApiKey = '00000000000000000000000000000000000000000000000'
            $Id = 1129083
            $Name = 'My Web Page 2'
            $ErrorMessage = 'Parameter set cannot be resolved using the specified named parameters'

            It 'Returns an error when using both -Name and -ID' {
               {Get-NRApplication -ApiKey $ApiKey -Id $Id -Name $Name} | Should Throw $ErrorMessage
            }
        }
    }
}
