---
external help file: NewRelic-help.xml
online version: 
schema: 2.0.0
---

# Invoke-NRRequest

## SYNOPSIS
Builds up and submits a web request to the New Relic API.

## SYNTAX

```
Invoke-NRRequest [-ApiKey] <String> [-Uri] <Uri> [-Method] <String> [[-Body] <String>]
```

## DESCRIPTION
Will build a properly structured web request to use for the New Relic API.
This is mostly used by other
cmdlets and is meant to be generic, thus it will not form the body or URI needed for most requests.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-NRRequest -ApiKey '1234abc' -Uri 'https://newrelic.com/someuri' -Method 'Get'
```

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-NRRequest -ApiKey '1234abc' -Uri 'https://newrelic.com/someuri' -Method 'Post' -Body "{'Name' = 'Value'}"
```

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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
Uri for the request being made

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
Method to be used for the request

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Extra data to be sent with the request, must be in string format able to be parsed as json

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
The object returned is the content block (converted from json) from the web request response.

## NOTES

## RELATED LINKS

