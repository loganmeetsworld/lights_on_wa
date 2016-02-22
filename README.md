## Logan's Product Plan
1. __Problem Statement__: The majority of digital Campaign Finance work has been done at the federal level because the FEC provides a standarized form of data and regulation. However, when we talk about money in politics, we usually emphasize corruption at the local level. A 10k donation to a multi-million dollar senate campaign may not make a big difference, but the same donation to a small judicial race might. Thus it may be much more important to track money at the state and county level. However, the data and regulation at the state level varies vastly across state and county lines. Until now, no webapp or API exists to help track state candidates in Washington. "Lights on Washington" is an API and web application that scrapes data from the Public Disclosure Commission ([pdc](pdc)) website, using this information to allow users to search and save candiates for state office in Washington. Beyond the immediate impact of the app, I want to well-document and test-drive (TDD) building this app so that hopefully people from other states can build their own applications to track campaign finance.  

1. __Market Research__: 
  - Friends of Lights on Wa: There are several organizations already doing work in this space. At the federal level there are countless apps and orgs including the Sunlight Foundation, Open Secrets, ProPublica, and many journalists. At the state level I have been hugely impressed by the app [Illinois Sunshine](is) built by DataMade with the help of the Illinois Campaign for Political Reform group. They took data from the Illinois Board of Elections and put it into easy to read tables that update with new information daily. I have reached out to DataMade for more information on how they established that relationship.
  - Friends don't fully address the problem: While Illinois Sunshine provides a lot of information and wrote an API, they do not have any data visualizations of the data and their app is in Python. It is all open source, however, which will be helpful in comparing them to my app. Also, all the data is specific to Illinois only, which has different laws on campaign finance from Washington. 
  - Differentiation: So far there is no application that directly addresses camapign finance in the state of Washington and no app that visualizes data at the state level. There is also no app that allows you to save candidates and return to your portal with those candidates. Most apps are only exploratory, they don't let you track candidates or committees over time. 

1. __User Personas__: My main target groups are journalists and concerned citizens who are seeking out this information. Journalists and other developers could benefit from an API that makes the information more accessible. Concerned citizens would use it to track their elected officials or candidates. This is a gubernatorial election year in the state of Washington so a lot of people will want to watch the campaign donations to the two major candidates's campaigns. This is why I want to make it easy for users to save their preferences of candidates. Campiagn finance often gets confusing because of the noise. There is a lot of money going to different candidates and you may only care about one or two. This way you can only track the ones that matter to you.
1. __Trello Board__:
  - A working trello can be found [here](trello) as well as a repo [here](repo).

1. __Optional__:
  - Technology selections: PostgresSql for the data, Ruby on Rails for the backend, Javascript and [d3](d3tut) for the frontend, Python for the web scrapper, possibly Twillio for emails 
  - Wireframes: None, yet.

[repo]: https://github.com/loganmeetsworld/lights_on_wa
[pdc]: pdc.wa.gov
[is]: https://www.illinoissunshine.org/about/
[trello]: https://trello.com/b/9jQs2sE7/capstone
[d3tut]: http://alignedleft.com/tutorials/d3/using-your-data