# ruby-twarc

ruby-twarc a port of Ed Summer's [Twarc](https://github.com/edsu/twarc) to Ruby. Twarc allows you to archive Twitter JSON data, and can be used either as command-line tool, or as a Ruby library. There are a few differences between twarc and ruby-twarc, but for the most part, it follows Ed Summers' design. ruby-twarc uses the following Twitter APIs: Search (to retroactively search Twitter timelines), Stream (to capture tweets in realtime), and Lookup (to "hydrate" tweets from a list of IDs. ruby-twarc, like twarc, will pause operation to abide by Twitter's rate-limits.

#install

Currently, the steps to use ruby-twarc are:

1. Clone this repo.
2. Make ruby-twarc.rb executable.
3. Run 
    ruby-twarc [options]

ruby-twarc can also be used as a library, but requiring "lib/twarc". I plan to make ruby-twarc a gem so it can be installed without cloning the repo, and required in the normal way. 

#usage

    ruby-twarc [options]

    options:
    --search: use the Twitter search API
    --stream: use the Twitter stream API
    --hydrate: rehydrate tweets from a list of IDs
    --max_id: maximum tweet ID to search for
    --since_id: smallets ID to search for
    --auth_file [file]: path authentication file. The authentication file holds a Ruby hash that contains your consumer key, 
    your consumer secret key, your access token, and your access token secret. Authentication information can also be        passed via the next four command line arguments.
    --consumer_key [key]: your consumer key
    --consumer_secret [secret]: your consumer secret key
    --access_token [token]: your access token
    --access_token_secret [token-secret]: your secret token
    --query [query]: your query string
    --log [logfile]: location of logfile
    
#twitter API keys

To use ruby-twarc, you'll need to register an application with Twitter (you can do this at [apps.twitter.com](http://apps.twitter.com). At the end of the process, you should have four keys: consumer_key, consumer_key_secret, access_token, and access_token_secret. You can either pass these keys in as command line parameters to ruby-twarc, or you can create an authentication file to use. The authentication file contains a Ruby hash holding all your keys. For example:

  {consumer_key: {YOUR CONSUMER KEY}, consumer_key_secret: {CONSUMER KEY SECRET}, access-token: {ACCESS TOKEN}, access_token_secret: {ACCESS TOKEN SECRET} }

You can then specify the authentication file using the --auth-file parameter.

#search

#stream

#hydrate

#ruby library

#utilities

Ed Summer's Twarc comes with a suite of Python utilities for working with the JSON output. I haven't looked into what the Ruby equivalents of these would be. 

#issues

There's still plenty of work to be done. Please see the [issues list][https://github,com/redlibrarian/ruby-twarc/issues)
