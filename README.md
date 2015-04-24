# ruby-twarc
A port of Ed Summers' Twarc (https://github.com/edsu/twarc) to Ruby

#usage

    ruby-twarc [options]

    options:
    --m [method]: search or streaming. Specified whether to use the Twitter search or streaming API
    --f [file]: path authentication file. The authentication file holds a Ruby hash that contains your consumer key, your     consumer secret key, your access token, and your access token secret. Authentication information can also be passed     via the next four command line arguments.
    --k [key]: your consumer key
    --s [secret]: your consumer secret key
    --t [token]: your access token
    --x [token-secret]: your secret token
    --q [query]: your query string

    --m, --q and either --f or [--k, --s, --t, --x] are required.
