---
external help file: NewRelic-help.xml
online version: 
schema: 2.0.0
---

# Invoke-NRRequest

## SYNOPSIS
Builds up and submits a web request to the New Relic API.

## SYNTAX

### Api (Default)
```
Invoke-NRRequest -ApiKey <String> -Uri <Uri> -Method <String> [-Body <Hashtable>]
```

### Query
```
Invoke-NRRequest -QueryKey <String> -Uri <Uri> -Method <String> [-Body <Hashtable>]
```

### Insert
```
Invoke-NRRequest -InsertKey <String> -Uri <Uri> -Method <String> [-Body <Hashtable>]
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

# This is a basic get request against https://newrelic.com/someuri, with no body.

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-NRRequest -ApiKey '1234abc' -Uri 'https://newrelic.com/someuri' -Method 'Post' -Body "{'Name' = 'Value'}"
```

# This is a post request against 'https://newrelic.com/someuri' including the body parameter.

## PARAMETERS

### -ApiKey
Api key for connecting to New Relic.
Go to the link below for more details:
https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-keys

```yaml
Type: String
Parameter Sets: Api
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryKey
Query key for running queries against Insights

```yaml
Type: String
Parameter Sets: Query
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InsertKey
Insert key for posting events to Insights

```yaml
Type: String
Parameter Sets: Insert
Aliases: 

Required: True
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Extra data to be sent with the request

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
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

