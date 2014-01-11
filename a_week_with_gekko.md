I decided to start automating my trades of bitcoin when I reached a balance of just 3 BTC. My thinking was basically that the volatility of bitcoin was sufficient that, assuming a value per btc of USD$1000 (which is a poor estimate, but makes math easier; furthermore, I feel that is not an unreasonable target for CY2014), a one- or two-percent swing, daily, is enough to net $30-$60, if the trades are executed well (and for purposes of discussion, let’s omit Gox’s [six-tenths-of-a-percent fee](https://www.mtgox.com/fee-schedule)).

My goal here was to make enough money from playing the bitcoin volatility to cover my “expenses” during a given day – that is, various things like eating out or perhaps even getting gas and having pocket cash. So while $45 a day does not seem objectively like a lot of money, it certainly works for these little expenses.

Additionally, I have been pretty consistently pushing another $1,000 a month into bitcoin (in theory this works out to about $20,000 of my gross income). If we assume the same sort of performance (and the same valuation of bitcoin, which is of course not a safe assumption), we can see an increase in daily income of $15 per month, on average. By the end of CY2014, this would work out to a daily income of $210, with a total of $14,000 invested (and again, assuming a stable value of $1,000 per btc, this is roughly 14btc; this is not a safe assumption). And if all these not-safe assumptions worked out, I could expect to be making, by January of 2015, about the same in cash per day as I net from my own salary.

This struck me as an admirable goal: seek 1-2 percent volatility per day, aim to trade wisely for that delta, make the trade, and be done. In fact, my friend [Dan](http://risacher.org/blog/) used to do something very like this by trading [Transmeta](https://web.archive.org/web/20090901205919/http://www.transmeta.com/index2.html) stock on a regime of “buy at $2, sell at $4”. Because the stock was fairly volatile, he found he was doubling his money a few times a year, and he didn’t keep so much money in the stock that he would be ruined if it were to vanish completely. The difference is that Bitcoin is far more volatile than even $TMTA was.

I started, then, looking for “bitcoin trading bots” on Google, and the very first hit was [Gekko](https://github.com/askmike/gekko).

Gekko is a [nodejs](http://nodejs.org/about/) (I like node. A lot.) program that uses the [exponential moving averages](https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average) for bitcoin to estimate trends and make trades. The author (name here) tells me he was inspired to write Gekko after coming across [this post](https://bitcointalk.org/index.php?topic=60501.0) on the ever popular [bitcointalk](https://bitcointalk.org/index.php) forum. To be honest, I don’t really understand what EMAs are, mathematically. What struck me about the method, though, is it aims to buy or sell based upon a trend. That is, the software aims to fully divest before a downward trend becomes “too downward to hold,” and to (fully) invest when an upward trend is spotted (and we are not presently holding). This sounds great, right?

Well, in practice, it does not really work for my purposes. The problem with using EMA to determine whether to make a trade or not is that it is really more suitable to a longer-term strategy. In my own case, I am happy with a one- or two-percent gain, and wish to have as little exposure as possible to the volatility of bitcoin other than that (this is to say that, while over 2013 we may have seen a [fifty-fold increase](http://www.forbes.com/sites/kashmirhill/2013/12/26/how-you-should-have-spent-100-in-2013-hint-bitcoin/) in the value of the currency, I am skeptical of a repeat for 2014, and would prefer to have a daily income rather than “bet the farm” on the same thing happening again; my feeling on this may change).

I decided to run Gekko in two configurations (which at the time of writing need to be housed in separate directories; this is being fixed), one on the default settings of:

    // Exponential Moving Averages settings:
    config.EMA = { 
      // timeframe per candle
      interval: 60, // in minutes
      // EMA weight (α)
      // the higher the weight, the more smooth (and delayed) the line
      short: 10, 
      long: 21, 
      // amount of candles to remember and base initial EMAs on
      candles: 100,
      // the difference between the EMAs (to act as triggers)
      sellTreshold: -0.25,
      buyTreshold: 0.25
    };  

And the other, at somewhat more aggressive or twitchy:

    // Exponential Moving Averages settings:
    config.EMA = { 
      // timeframe per candle
      interval: 15, // in minutes
      // EMA weight (α)
      // the higher the weight, the more smooth (and delayed) the line
      short: 8, 
      long: 12, 
      // amount of candles to remember and base initial EMAs on
      candles: 100,
      // the difference between the EMAs (to act as triggers)
      sellTreshold: -0.20,
      buyTreshold: 0.20
    };  

I ran both these processes from [3 Jan through 10 Jan](http://bitcoincharts.com/charts/mtgoxUSD#rg60zczsg2014-01-03zeg2014-01-10ztgSzm1g10zm2g25zv), where there was certainly substantial volatility – an almost 200-dollar, 18.2% swing – and both processes “lost” simulated money. The more aggressive process lost 4.52% over the week, and the less aggressive process lost 7.19%. 