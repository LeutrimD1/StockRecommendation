# StockRecommendation
A PowerShell script that returns market sentiment for a given stock

# Example
Scale is: 
x <= -0.35: Bearish;
-0.35 < x <= -0.15: Somewhat-Bearish;
-0.15 < x < 0.15: Neutral;
0.15 <= x < 0.35: Somewhat_Bullish;
x >= 0.35: Bullish

Get-MarketSentiment -Symbol AAPL -OutputType d

Returns: 0.07381064

Get-MarketSentiment -Symbol AAPL

Returns: Neutral

# Note
To run this cmdlet in powershell you must 
1. Set your Execution Policy to "RemoteSigned" by this command 
   "Set-ExecutionPolicy RemoteSigned"
2. Use Dot Sourcing when loading the function.
   When referencing the file use two dots. i.e. (. .\Get-MarketSentiment.ps1) this will allow you to use the cmdlet like any other cmdlet in the current session.
