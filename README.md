# ruby-twarc
A port of Ed Summers' Twarc (https://github.com/edsu/twarc) to Ruby

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
