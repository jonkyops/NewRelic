function Get-NRTimeSpan {
    <#
    .SYNOPSIS
        Builds a timespan string for NewRelic API calls
    .DESCRIPTION
        Builds a timespan string for NewRelic API calls
    .EXAMPLE
        $Start = (Get-Date).AddDays(-1)
        $End = Get-Date

        Get-NRTimeSpan -Start $Start -End $End

        from=2017-05-27T20:19:02+00:00&to=2017-05-28T20:19:02+00:00

        Returns a timespan string from yesterday to the current date
    .INPUTS
        A start and end Datetime object
    .OUTPUTS
        Timespan string usable in NewRelic API
    #>
    [CmdletBinding()]
    param (
        # The datetime of when to start the timespan
        [parameter(Mandatory,
                   ValueFromPipelineByPropertyName)]
        [DateTime] $Start,
        # The datetime of when to end the timespan
        [parameter(Mandatory,
                   ValueFromPipelineByPropertyName)]
        [DateTime] $End,
        # Use local time
        [switch] $UseLocalTime
    )
    process {
        'from={0}&to={1}' -f ($Start, $End | Format-NRDate -UseLocalTime:$UseLocalTime)
    }
}
