I decided to start automating my trades of bitcoin when I reached a balance of just 3 BTC. My thinking was basically that the volatility of bitcoin was sufficient that, assuming a value per btc of USD$1000 (which is a poor estimate, but makes math easier; furthermore, I feel that is not an unreasonable target for CY2014), a one- or two-percent swing, daily, is enough to net $30-$60, if the trades are executed well (and for purposes of discussion, let’s omit Gox’s [six-tenths-of-a-percent fee](https://www.mtgox.com/fee-schedule)).

My goal here was to make enough money from playing the bitcoin volatility to cover my “expenses” during a given day – that is, various things like eating out or perhaps even getting gas and having pocket cash. So while $45 a day does not seem objectively like a lot of money, it certainly works for these little expenses.

Additionally, I have been pretty consistently pushing another $1,000 a month into bitcoin (in theory this works out to about $20,000 of my gross income). If we assume the same sort of performance (and the same valuation of bitcoin, which is of course not a safe assumption), we can see an increase in daily income of $15 per month, on average. By the end of CY2014, this would work out to a daily income of $210, with a total of $14,000 invested (and again, assuming a stable value of $1,000 per btc, this is roughly 14btc; this is not a safe assumption). And if all these not-safe assumptions worked out, I could expect to be making, by January of 2015, about the same in cash per day as I net from my own salary.

This struck me as an admirable goal: seek 1-2 percent volatility per day, aim to trade wisely for that delta, make the trade, and be done. In fact, my friend [Dan](http://risacher.org/blog/) used to do something very like this by trading [Transmeta](https://web.archive.org/web/20090901205919/http://www.transmeta.com/index2.html) stock on a regime of “buy at $2, sell at $4”. Because the stock was fairly volatile, he found he was doubling his money a few times a year, and he didn’t keep so much money in the stock that he would be ruined if it were to vanish completely. The difference is that Bitcoin is far more volatile than even $TMTA was.

I started, then, looking for “bitcoin trading bots” on Google, and the very first hit was [Gekko](https://github.com/askmike/gekko).

![Console interface for Gekko](https://github.com/avriette/misc/blob/master/a_week_with_gekko/gekko_console.png?raw=true)

Gekko is a [nodejs](http://nodejs.org/about/) (I like node. A lot.) program that uses the [exponential moving averages](https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average) for bitcoin to estimate trends and make trades. The author, Mike, tells me he was inspired to write Gekko after coming across [this post](https://bitcointalk.org/index.php?topic=60501.0) on the ever popular [bitcointalk](https://bitcointalk.org/index.php) forum. To be honest, I don’t really understand what EMAs are, mathematically. What struck me about the method, though, is it aims to buy or sell based upon a trend. That is, the software aims to fully divest before a downward trend becomes “too downward to hold,” and to (fully) invest when an upward trend is spotted (and we are not presently holding). This sounds great, right?

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

I ran both these processes from [3 Jan through 10 Jan](http://bitcoincharts.com/charts/mtgoxUSD#rg60zczsg2014-01-03zeg2014-01-10ztgSzm1g10zm2g25zv), where there was certainly substantial volatility – an almost 200-dollar, 18.2% swing – and both processes “lost” ***simulated*** money. The more aggressive process lost 4.52% over the week, and the less aggressive process lost 7.19%. Kind of disappointing.

So [Mike](http://mikevanrossum.nl/), a student currently working on a graduate project on cryptocurrencies (which includes Gekko), agreed with me on the nominal use case of Gekko as it stands. It is helpful to share an anecdote:

I had just put a thousand more dollars (doubling my investment, and having “convinced” my spouse this was A Good Idea) into my Coinbase account. I wound up having a tough time sleeping that night, for reasons unrelated to Bitcoin. So I found myself awake at 0830 UTC or so, writing down some thoughts on why I was unhappy. As I sat, bleary-eyed, staring at my editor, the little [bitcoin monitor](http://codestream.de/bitcoin-monitor.html) I use to sort of passively watch the market had turned an angry red color, and seemed to be down in the mid-500’s. *That’s strange,* I thought, *I am pretty sure I remember it being up above 800 when I went to bed…* And so I put down my editor, and looked at my Coinbase account, and sure enough, I’d taken an enormous hit while I was asleep.

China, as it happened, had a rough night in Bitcoin-land.

I wound up staying up past sunrise to see it through, tightened my belt a little, and put another $750 in, confident that the market was healthy and would rebound, bought in the low $500’s, and managed to mitigate the loss by with a quick profit on the $750 purchase.

But this thought disturbed me – I cannot be awake around the clock to be there when China <del>shits the bed</del> <del>[shuts down](http://www.telegraph.co.uk/finance/currency/10558945/Chinas-answer-to-Amazon-Alibaba-bans-Bitcoin.html)</del> [*regulates* the market](http://techcrunch.com/2013/12/18/bitcoin-drops-50-overnight-as-chinas-biggest-btc-exchange-stops-deposits-in-chinese-yuan/).

Mike agrees. *”Gekko is not a money-making machine,”* he says. Gekko is only able to analyze trends, and only then using the very simplistic method of using EMA. *”A lot of people spend hours and evenings on [discovering the best settings](https://bitcointalk.org/index.php?topic=60501.msg3918750#msg3918750).”* This is to say, Gekko is probably good to be that process that makes a hurried trade when China or some other regulatory body steps in and breaks things, preventing me from losing 50% of my investment while I sleep. But it is not guaranteed to do this. *”…you'd be surprised how many complaint emails I get from people telling me they lost money. I want to make it really clear that if you don't understand what EMA is and you never backtested / paper tested it [what I am doing now] you really should not let Gekko play with all your money.”* Additionally, since Gekko uses EMA to gauge trends, strange changes like a surprise move from Chinese or other regulatory bodies, hacking events, the Winkelvosses deciding to dump, and so forth, do not represent trends, and Gekko may not understand sufficiently quickly to prevent loss. *”…to simplify: if we know that every time someone sells 100 BTC the price is going to drop for the rest of the day because people are panic selling, we watch for that happening and assume the price will go down again and make profit by taking advantage of this knowledge. [However], if China does something which has never happened before (like banning / restricting something) EMA really [doesn’t predict] what that behavior is going to look like.”*

So what, then, are my plans, and Mike’s, for the future of our efforts at trading automatically? Well, our philosophy diverges a little bit. Gekko makes a few tongue-in-cheek (or not…) [jokes](http://www.quotefully.com/movie/Wall+Street/Bud+Fox) about ‘greed is good’ (which seem appropriate, given the round-the-clock, unregulated nature of the bitcoin market). I have a philosophy of “get in, take profit, get out.” Gekko’s philosophy is really more “get in and hold as long as possible, sell, and get back in at the bottom.” How to reconcile this?

In the works for Gekko, and partially implemented, is attaching it to a [message queue](https://en.wikipedia.org/wiki/Message_queue). Gekko is able to emit events to the queue, such as “in an upward/downward trend” or “buy/sell.” I can, additionally, write a small piece of software (Perl is really my strongest language, despite my liking node a lot) that manages my “limited greed” strategy, plug it into [SQS](https://aws.amazon.com/sqs/), and check with Gekko for trending, or indeed fires off an event to Gekko saying “please make this trade,” rather than my own having to [re-invent or borrow wheels](https://metacpan.org/pod/Finance::MtGox).

The future, then, for me, is to write a small set of subroutines in Perl that describe, succinctly, the philosophy outlined above, and to test these for another week or two with not-real money, and re-evaluate whether to put Real Money behind the logic. At the same time, Gekko is gaining a web interface (already has an irc interface!), and support for the queue. I hope that by the end of January, I’ll be able to consult Gekko for EMA advice, and use that to determine whether I’ve been “greedy enough” to sell and divest for the day, and whether to buy in the following day, as well as probably to send those trade events to Gox (through Gekko).