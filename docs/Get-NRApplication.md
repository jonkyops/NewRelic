---
external help file: NewRelic-help.xml
online version: 
schema: 2.0.0
---

# Get-NRApplication

## SYNOPSIS
Builds up and submits a web request to the New Relic API.

## SYNTAX

### NoFilter (Default)
```
Get-NRApplication -ApiKey <String>
```

### ID
```
Get-NRApplication -ApiKey <String> [-ID <Int32>]
```

### Name
```
Get-NRApplication -ApiKey <String> [-Name <String>]
```

## DESCRIPTION
Will build a properly structured web request to use for the New Relic API.
This is mostly used by other
cmdlets and is meant to be generic, thus it will not form the body or URI needed for most requests.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-NRApplication -ApiKey '1234abc'
```

# Returns all applications for the account

### -------------------------- EXAMPLE 2 --------------------------
```
Get-NRApplication -ApiKey '1234abc' -Id '111931'
```

# Returns just the application object for the specified ID

### -------------------------- EXAMPLE 3 --------------------------
```
Get-NRApplication -ApiKey '1234abc' -Name 'MyWebApp'
```

# Returns just the application object for the specified name

## PARAMETERS

### -ApiKey
Api key for connecting to New Relic.
Go to the link below for more details:
https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the application, can accept wildcards '*'

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ID
ID of the application

```yaml
Type: Int32
Parameter Sets: ID
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
The object returned is the application block (converted from json) from the web request response.

## NOTES

## RELATED LINKS

