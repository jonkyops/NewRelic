function Format-NRDate {
    <#
    .SYNOPSIS
        Returns a string with the specified date for NewRelic API
    .DESCRIPTION
        Returns a string with the specified date (defaults to current datetime) for NewRelic API calls.
        This is usually passed to Format-NRTimeSpan as a start or end time.
    .EXAMPLE
        Format-NRDate

        2017-05-28T11:54:33-05:00

        Will return the current date (in the local timezone) in a format acceptable for NewRelic API
    .EXAMPLE
        Get-Date -Day 30 -Month 1 -Year 2017 | Format-NRDate

        2017-05-28T11:54:33-05:00

        Will return the date of 01/30/2017 (in universal time) in a format acceptable for NewRelic API
    .INPUTS
        A datetime object
    .OUTPUTS
        String in format suitable for a newrelic api call
    #>
    [CmdletBinding()]
    param(
        # DateTime to be formatted
        [Parameter(ValueFromPipeline)]
        [DateTime] $Date = $(Get-Date),
        # Specified that local time should be used
        [Switch] $UseLocalTime
    )
    process {
        if (-not($UseLocalTime)) {
            # Couldn't find a way to specify the timezone with the formatting here, so hardcoding it
            (Get-Date -Date $Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss+00:00')
        }
        else {
            (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
        }
    }
}