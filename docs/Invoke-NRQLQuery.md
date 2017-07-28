---
external help file: NewRelic-help.xml
online version: 
schema: 2.0.0
---

# Invoke-NRQLQuery

## SYNOPSIS
Invokes a NRQL query

## SYNTAX

```
Invoke-NRQLQuery [-AccountId <Object>] [-Query <Object>] [-QueryKey <Object>]
```

## DESCRIPTION
Invokes either and insert or query request against New Relic Insights

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Query = Select * FROM
```

Invoke-NRQLQuery -AccountId '1111111' \`
                 -Query "SELECT count(errorMessage) FROM Transaction FACET errorMessage limit 5 SINCE 7 DAYS AGO" \`
                 -QueryKey 'xxxxxxxxxxxxx'

Returns the results from the query run against the accountId

## PARAMETERS

### -AccountId
Account ID to run the query against

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
The NRQL query to be run

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryKey
QueryKey to run the NRQL query with
Posting events has not been tested yet
# Json body of the event being posted
\[Parameter(ParameterSetName='Insert')\]
$Body,
# InsertKey to run the insert with
\[Parameter(ParameterSetName='Insert')\]
$InsertKey

```yaml
Type: Object
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

## NOTES

## RELATED LINKS

