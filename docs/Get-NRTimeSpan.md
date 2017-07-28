---
external help file: NewRelic-help.xml
online version: 
schema: 2.0.0
---

# Get-NRTimeSpan

## SYNOPSIS
Builds a timespan string for NewRelic API calls

## SYNTAX

```
Get-NRTimeSpan [-Start] <DateTime> [-End] <DateTime> [-UseLocalTime]
```

## DESCRIPTION
Builds a timespan string for NewRelic API calls

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Start = (Get-Date).AddDays(-1)
```

$End = Get-Date

Get-NRTimeSpan -Start $Start -End $End

from=2017-05-27T20:19:02+00:00&to=2017-05-28T20:19:02+00:00

Returns a timespan string from yesterday to the current date

## PARAMETERS

### -Start
The datetime of when to start the timespan

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -End
The datetime of when to end the timespan

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UseLocalTime
Use local time

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### A start and end Datetime object

## OUTPUTS

### Timespan string usable in NewRelic API

## NOTES

## RELATED LINKS

