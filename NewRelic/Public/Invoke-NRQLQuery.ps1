function Invoke-NRQLQuery {
    <#
    .SYNOPSIS
        Invokes a NRQL query
    .DESCRIPTION
        Invokes either and insert or query request against New Relic Insights
    .EXAMPLE
        $Query = Select * FROM 
        Invoke-NRQLQuery -AccountId '1111111' `
                         -Query "SELECT count(errorMessage) FROM Transaction FACET errorMessage limit 5 SINCE 7 DAYS AGO" `
                         -QueryKey 'xxxxxxxxxxxxx'
        
        Returns the results from the query run against the accountId
    #>
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    param (
        # Account ID to run the query against
        $AccountId,
        # The NRQL query to be run
        [Parameter(ParameterSetName = 'Query')]
        $Query,
        # QueryKey to run the NRQL query with
        [Parameter(ParameterSetName = 'Query')]
        $QueryKey
    )
    begin {
        try { Add-Type -AssemblyName System.Web }
        catch { throw }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Query' {
                $BaseUri = 'https://insights-api.newrelic.com/v1/accounts/{0}/query?nrql={1}'
                $NRRequestParams = @{
                    QueryKey = $QueryKey
                    Method   = 'GET'
                    Uri      = $BaseUri -f $AccountId, [System.Web.HttpUtility]::UrlEncode($Query)
                }
            }
            Default { throw }
        } 
        Invoke-NRRequest @NRRequestParams
    }
}
