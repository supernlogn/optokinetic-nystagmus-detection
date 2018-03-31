# Time-series-assigment for auth class
matlab project to predict optokinetic nystagmus from eye movement data

## What is optokinetic nystagmus:
1.  Wikipedia: https://en.wikipedia.org/wiki/Optokinetic_response
2.  dizziness-and-balance.com: https://www.dizziness-and-balance.com/practice/nystagmus/okn.htm

The results are based on this [published work](https://www.sciencedirect.com/science/article/pii/S0010480997914415) 
Both linear systems and non-linear are used to explain the behaviour of the system.

There is also a report, but is written in greek. There is currently a work in progress to translate it in english.

## Execution priors
Before executing/developing any script inside this project make sure,
you have donwloaded the data:

To get the data execute the script below:
```bash
curl -O http://users.auth.gr/dkugiu/Teach/TimeSeriesTHMMY/dat6v1.dat
curl -O http://users.auth.gr/dkugiu/Teach/TimeSeriesTHMMY/dat6v2.dat
```

The [tisean package](https://www.pks.mpg.de/~tisean/archive_3.0.0.html) is also used to calculate the correlation dimension. Please follow the instructions of the page link given. If still there are issues please report them to the issues tab.
