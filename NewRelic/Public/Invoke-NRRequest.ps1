function Invoke-NRRequest {
    <#
    .SYNOPSIS
        Builds up and submits a web request to the New Relic API
    .DESCRIPTION
        Will build a properly structured web request to use for the New Relic API. This is mostly used by other
        cmdlets and is meant to be generic, thus it will not form the body or URI needed for most requests.
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        The object returned is the content block (converted from json) from the web request response
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    [Alias('inrr')]
    [OutputType([PSCustomObject])]
    Param (
        # Api key for connecting to New Relic. Go to the link below for more details:
        # https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # [ValidateLength(47,47)]
        [string] $ApiKey,
        
        # Uri for the request being made
        [Parameter(Mandatory=$true)]
        [uri] $Uri,

        # Method to be used for the request
        [Parameter(Mandatory=$true)]
        [ValidateSet('get','post','put','delete')]
        [string] $Method,

        # Extra data to be sent with the request, must be in string format able to be parsed as json
        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ | ConvertFrom-Json})]
        [string] $Body
    )
    
    begin {
    }
    
    process {
        Write-Verbose -Message 'Creating the X-Api-Key header'
        $Headers = @{'X-Api-Key' = $ApiKey}
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
            return $Response.Content
        }
        catch [System.Net.WebException] {
            Write-Debug -Message 'Entering catch block'
            $Error0 = $Error[0]
            ($Error0.ErrorDetails | ConvertFrom-Json).Error.Title
            #write-verbose -message ($_|gm).tostring()
            #return ($_|gm).tostring()
        }
        finally {
            Write-Debug -Message 'Entering finally block'
        }
    }
    
    end {
    }
}