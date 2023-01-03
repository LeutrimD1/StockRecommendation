<#
.SYNOPSIS
  PowerShell script to get average market sentiment across multiple outlets for a given stock symbol.
.DESCRIPTION
  Uses AlphaVantage.co's API to get Sentiments for a stock and returns the average of those.
.PARAMETER <Symbol>
  Stock Symbol [string]
.INPUTS
  Stock Symbol [string]
.OUTPUTS
  Market Sentiment [string], rating average[decimal]
.NOTES
  Version:        1.0
  Author:         <Leutrim Dema>
  Creation Date:  <1/2/2023>
  Purpose/Change: Initial script development
  
.EXAMPLE
  GetMarketSentiment -Symbol AAPL
  GetMarketSentiment -Symbol AAPL -OutputType d
#>

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Get-MarketSentiment {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = 'The stock ticker of interest'
        )]
        [string]
        $Symbol,

        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [ValidateSet('w', 'd')]
        [string]
        $OutputType = 'w'
    )
    $apikey = 'W9MJPQUR43VIHCMN'
    $uri = 'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers={0}&apikey={1}' -f $Symbol, $apikey

    try {
        $invokeWebRequestSplat = @{
            Uri = $uri
            ErrorAction = 'Stop'
        }
        $rawWebData = Invoke-WebRequest @invokeWebRequestSplat

        $jsonWebData = ConvertFrom-Json $rawWebData

        $numberOfTickers = 0
        $total = 0.0
        foreach($item in $jsonWebData.feed.ticker_sentiment){
            if($item.ticker -eq $Symbol){
                $numberOfTickers += 1
                $total += $item.ticker_sentiment_score
            }
        }

        if($numberOfTickers -eq 0){
            Write-Host 'There is no data for this ticker currently. Try a different ticker'
            return 
        }

        $average = $total / $numberOfTickers
        
        if($OutputType -eq 'w'){
            switch($average){
                {$_ -le -0.35} {Write-Host 'Bearish'}
                {$_ -gt -0.35 -and $_ -le -0.15} {Write-Host 'Somewhat-Bearish'}
                {$_ -gt -0.15 -and $_ -lt 0.15} {Write-Host 'Neutral'}
                {$_ -ge 0.15 -and $_ -lt 0.35} {Write-Host 'Somewhat_Bullish'}
                {$_ -ge 0.35} {Write-Host 'Bullish'}
            }
        }else{
            Write-Host $average
        }
    }
    catch {
        Write-Error $_
        return 
    }
}
