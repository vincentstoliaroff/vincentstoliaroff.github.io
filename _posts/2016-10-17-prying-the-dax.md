---
layout: post
title: Prying the Dax -  Post in progress
categories:
- blog
---
================

### 0. Opening up the DAX!

The Dax (**D**eutscher **A**ktieninde**x**) is the most famous Stock Index of the german economy, consisting of the 30 major German companies traded on the Frankfurt Stock Exchange and quoted on the Xetra platform. It comes in 2 flavors:
- A *total return Index* called the *performance-index* (Isin:DE0008469008)
- And a *price index* called the *Kursindex* in german (Isin:DE0008467440)

The most ubiquitous (in news report) is the *performance-index* quoting as of mid-2016 between 10'000 and 11'000 Points. The Definition of the index is based on the *Laspeyres* Price Index methodologie. The relative weights of the Index component are based on their

For different purposes, it would be nice to have the whole history of the Dax weighing scheme. This information is not readily available online but can be reconstructed with a bit of data scrapping/wrangling. In this post, I will show how I did it.

### 1. Building the Dataset.

#### 1.1 Webscrapping

The DAX components are daily published as XL files on the website of the [Deutsche Börse](%3Chttp://www.dax-indices.com/EN/index.aspx?pageID=4).

The R script used to download the raw data is [here](http://vincentstoliaroff.github.io/vincentstoliaroff.github.io/).

The urls are easy to loop on. It took me about 30 minutes to get 6 years of Data History. I didn't really try to optimize the code. The key functions I used are:
- `httr::http_error`: to test the existence of urls ressources: as I loop on every possible dates, weekends and holidays should not be requested.  
- `gdata::read.xls`: to download and read the XL spreadsheet all at once. Here, the only thing to take care of, was the import of "n/a" which by default would induce a `char` type for the numeric variables downloaded (when encountered).  
- `dplyr::bind_rows`: to merge every downloaded dataset in one For consistency, the dataframe column names are identical to those in the XL file but white space are removed.  

This final "raw" dataset is [here]()

#### 1.2 Data-wrangling

Next, we should ensure that data are reliable.

##### Primary Key Chaining

The Isin Code, Trading Ticker and Name of a given company are not necessary stable over time. For example, Adidas was labelled as *Adidas AG O.N.* till the 8th of October 2010 and *Adidas AG NA O.N.* afterwards. Since we would like to use those 3 variables as primary keys it is worth checking every change in it for chaining consistency.

##### Number of Constituent and In/Out Reshuffling

Over time the Index Sponsor can decide to *reshuffle* the Index. Checking the time series of each constituent, we find out that a few in/out updates occured in the last years.

On 2012/09/21 -&gt; 2012/09/24 Out: MAN SE ST O.N. METRO AG ST O.N. In: CONTINENTAL AG O.N. LANXESS AG

2015/09/18 -&gt; 2015/09/21 Out: LANXESS AG In: VONOVIA SE NA O.N.

2016/03/18 -&gt; 2016/03/21 Out: K+S AG NA O.N. In: PROSIEBENSAT.1 NA O.N.

##### Stock Split

With stock split, the price continuity is directly affected.

##### Weighing Scheme

It would be nice if the data were ready to consume. Like most of Index Providers though, the [STOXX](https://www.stoxx.com/home) company does not discloses the dax *actual* composition. This information is fee-liable and reserved to professional market participants only. What they publish is a lagged version of the weighing scheme: the raw dataset is more or less a equivalent to a [state transition table](https://en.wikipedia.org/wiki/State_transition_table) with missing current state.

The wrangled dataset is [here](). We can now recompute the Index directly from the price of its constituents and their weighing factors. The formula for re-computation is detailled [here](http://dax-indices.com/EN/MediaLibrary/Document/Leitfaden_Aktienindizes.pdf) on page 38.

<!--
pi0  = price at base date (30.12.87) or at IPO-date
pit  = actual price (Xetra)
qi0  = no. of shares at base date (30.12.87) or at IPO-date
qit  = no. of shares (last review date)
ffit  = actual free float factor
ci  = correction factor
Kt  = chaining factor
Index = Kt * (Sum(pit * ffit * qit * ci) / Sum(pi0 * qi0)) * Base
Index = (Sum(pit * Fit) / A) * Base
-->
  
### 2. A few Graphics


### 3. Stay tuned! To come next

The painful task of extracting and cleansing the data is now over... Let's start having fun now with mining, statistics and trading... In the next posts, we will discuss:
- different VaR computation methodologies for the DAX basket.
- A few trading strategies based on DAX Portfolio
