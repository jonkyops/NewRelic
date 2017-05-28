function Invoke-NRRequest {
    <#
    .SYNOPSIS
        Builds up and submits a web request to the New Relic API.
    .DESCRIPTION
        Will build a properly structured web request to use for the New Relic API. This is mostly used by other
        cmdlets and is meant to be generic, thus it will not form the body or URI needed for most requests.
    .EXAMPLE
        Invoke-NRRequest -ApiKey '1234abc' -Uri 'https://newrelic.com/someuri' -Method 'Get'

        # This is a basic get request against https://newrelic.com/someuri, with no body.
    .EXAMPLE
        Invoke-NRRequest -ApiKey '1234abc' -Uri 'https://newrelic.com/someuri' -Method 'Post' -Body "{'Name' = 'Value'}"

        # This is a post request against 'https://newrelic.com/someuri' including the body parameter.
    .OUTPUTS
        System.Management.Automation.PSCustomObject
        The object returned is the content block (converted from json) from the web request response.
    #>
    [CmdletBinding(DefaultParameterSetName='Api')]
    [Alias('inrr')]
    [OutputType([PSCustomObject])]
    Param (
        # Api key for connecting to New Relic. Go to the link below for more details:
        # https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys
        [Parameter(Mandatory,
                   ParameterSetName='Api')]
        [ValidateNotNullOrEmpty()]
        [string] $ApiKey,

        # Query key for running queries against Insights
        [Parameter(Mandatory,
                   ParameterSetName='Query')]
        [ValidateNotNullOrEmpty()]
        [string] $QueryKey,

        # Insert key for posting events to Insights
        [Parameter(Mandatory,
                   ParameterSetName='Insert')]
        [ValidateNotNullOrEmpty()]
        [string] $InsertKey,

        # Uri for the request being made
        [Parameter(Mandatory)]
        [uri] $Uri,

        # Method to be used for the request
        [Parameter(Mandatory)]
        [ValidateSet('get','post','put','delete')]
        [string] $Method,

        # Extra data to be sent with the request
        [Parameter(Mandatory=$false)]
        [ValidateScript({ $_ | ConvertTo-Json })]
        [hashtable] $Body
    )

    process {
        Write-Verbose -Message 'Creating the Key header'
        switch ($PSCmdlet.ParameterSetName) {
            'Api' {
                Write-Verbose -Message 'Using X-Api-Key header'
                $Headers = @{ 'X-Api-Key' = $ApiKey }
            }
            'Query' {
                Write-Verbose -Message 'Using X-Query-Key header'
                $Headers = @{ 'X-Query-Key' = $QueryKey }
            }
            'Insert' {
                Write-Verbose -Message 'Using X-Insert-Key header'
                $Headers = @{ 'X-Insert-Key' = $InsertKey }
            }
        }
        
        Write-Debug -Message ('Headers: {0}' -f ($Headers | Out-String))

        Write-Verbose -Message 'Building the request params'
        $RequestParams = @{
            Uri = $Uri
            Method = $Method
            ContentType = 'application/json'
            Headers = $Headers
        }

        Write-Verbose -Message 'Checking if a body was specified'
        if ($Body) {
            Write-Verbose -Message 'Body was specified, adding'
            $RequestParams.Add('Body', $Body)
        }
        Write-Debug -Message ('Full Request: {0}' -f ($RequestParams | Out-String))

        Write-Verbose -Message 'Invoking request'
        try {
            Write-Debug -Message 'Starting request try/catch'
            $Response = Invoke-WebRequest @RequestParams
            Write-Debug -Message ('Response: {0}' -f $Response | Out-String)
            Write-Verbose -Message 'Request complete'

            Write-Debug -Message 'Returning response.content'
            $Response.Content | ConvertFrom-Json
        }
        catch {
            Write-Debug -Message 'Entering catch block'
            $Error0 = $_
            Write-Debug -Message ('Full error: {0}' -f ($Error0 | Format-List -Property * -Force | Out-String))

            # if the request goes through, but returns an error, it'll usually have ErrorDetails
            if ($Error0.ErrorDetails) {
                throw ($Error0.ErrorDetails | ConvertFrom-Json).Error.Title
            }
            else {
                # This usually happens if the Uri is malformed
                throw $Error0.Exception
            }
        }
    }
}
