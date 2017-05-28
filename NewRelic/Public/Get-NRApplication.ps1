function Get-NRApplication {
    <#
    .SYNOPSIS
        Builds up and submits a web request to the New Relic API.
    .DESCRIPTION
        Will build a properly structured web request to use for the New Relic API. This is mostly used by other
        cmdlets and is meant to be generic, thus it will not form the body or URI needed for most requests.
    .EXAMPLE
        Get-NRApplication -ApiKey '1234abc'

        # Returns all applications for the account
    .EXAMPLE
        Get-NRApplication -ApiKey '1234abc' -Id '111931'

        # Returns just the application object for the specified ID
    .EXAMPLE
        Get-NRApplication -ApiKey '1234abc' -Name 'MyWebApp'

        # Returns just the application object for the specified name
    .OUTPUTS
        System.Management.Automation.PSCustomObject
        The object returned is the application block (converted from json) from the web request response.
    #>
    [CmdletBinding(DefaultParameterSetName='NoFilter')]
    [Alias('gnra')]
    [OutputType([PSCustomObject])]
    Param (
        # Api key for connecting to New Relic. Go to the link below for more details:
        # https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys
        [Parameter(ParameterSetName='NoFilter', Mandatory)]
        [Parameter(ParameterSetName='Name', Mandatory)]
        [Parameter(ParameterSetName='ID', Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $ApiKey,

        # Name of the application, can accept wildcards '*'
        [Parameter(ParameterSetName='Name',
                   ValueFromPipeline)]
        [String] $Name,

        # ID of the application
        [Parameter(ParameterSetName='ID',
                   ValueFromPipeline)]
        [Int] $ID
    )

    begin {
        Write-Verbose -Message 'Starting get request for applications'
        $BaseUri = 'https://api.newrelic.com/v2/applications{0}.json'
    }

    process {
        # build up the base invoke-nrrequest command
        $Splat = @{
            ApiKey = $ApiKey
            Method = 'GET'
        }

        Write-Verbose -Message 'Building up NRRequest params'
        switch ($PSCmdlet.ParameterSetName) {
            'Name' { 
                Write-Debug -Message 'Using the Name parameter set'
                Write-Verbose -Message ('Working on: {0}' -f $Name)
                # set up the name we'll be adding to the body
                $BodyName = $Name -replace ' ', '+'
                Write-Debug -Message ('BodyName: {0}' -f $BodyName)
                
                # go with the base URI and add the body
                $Uri = $BaseUri -f ''
                $Body = @{ 'filter[name]' = $BodyName }
                Write-Debug -Message ('Body: {0}' -f ($Body | Out-String))
                Write-Debug -Message ('Body Type: {0}' -f ($Body.GetType()))
                $Splat.Add('Body', $Body)
            }
            'ID' {
                Write-Verbose -Message ('Working on: {0}' -f $ID)
                Write-Debug -Message 'Using the ID parameter set'
                # Add the app id to the base URI
                $Uri = $BaseUri -f ('/{0}' -f $ID)
            }
            'NoFilter' {
                Write-Verbose -Message ('Getting all applications')
                Write-Debug -Message 'Using the NoFilter parameter set' 
                $Uri = $BaseUri -f ''
            }
            Default {}
        }
        Write-Debug -Message ('Uri: {0}' -f $Uri)
        $Splat.Add('Uri', $Uri)

        Write-Debug -Message ('Splat: {0}' -f ($Splat | Out-String))

        Write-Verbose -Message 'Invoking NR request'
        $Results = Invoke-NRRequest @Splat
        Write-Debug -Message ('Results: {0}' -f $Results)

        # Property name we're looking for will be 'Applications' if multiple are returned and 'Application' 
        # if it's only one
        Write-Verbose 'Returning results'
        if ($Results.PSobject.Properties.name -contains 'Applications') {
            Write-Debug -Message 'Applications property, entering if block'
            Write-Debug -Message ('Applications: {0}' -f ($Results.Applications | Out-String))
            $Results.Applications
        }
        else {
            Write-Debug -Message 'Application property, entering else block'
            Write-Debug -Message ('Application: {0}' -f ($Results.Application | Out-String))
            $Results.Application
        }
    }

    end { Write-Verbose -Message 'Complete' }
}
