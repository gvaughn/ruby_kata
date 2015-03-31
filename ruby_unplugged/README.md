# Ruby Unplugged

There's too many rockstars in the Ruby world that rely on pedals and
effects and can't really make music the old-fashioned way -- sitting on
the front porch with the neighbors for a nice Pat Boone sing-a-long.

## Eschew Gems

It's great that the Ruby ecosystem has a gem for just about every need
and finding and evaluating them for a particular project's needs is an
important skill to have, but it's also quite possible to spend too much
time managing dependencies that the time savings are lost. Plus there's
widely varying quality in gems.

## The Challenge: Should you choose to accept it

Create a service in Ruby that continuously consumes the
[Twitter sample stream](https://dev.twitter.com/streaming/reference/get/statuses/sample),
extracts any #hashtags from the text field and returns the top 10 hashtags
from the past 60 seconds via an api endpoint.

## Standard Library is your friend

It's a ghetto, but still your friend. Rely upon it rather than gems to achieve
your goal. You remember stdlib, right? It's the stuff you have to
`require` but is still there in the base ruby installation without a gem dependency.
This is what distinguishes the Ruby developer from the Rails developer. Choose
wisely, intrepid adventurer!

One compromise is that we'll use the 'oauth' gem, because ain't nobody
got time for that.

## This Message Will Self Destruct in 5 Seconds

4 ... 3 ... 2 ... 1
BOOM!!!

## Still Here?

OK. Seriously, here's how to use this code.

This was written against the latest Ruby release, 2.2.1. I'm using named
parameters, so you'll definitely need a 1.9+, but I haven't tested
against any others. I have a .ruby-version file, so modern Ruby managers
should pick up on that.

You'll need twitter credentials because I'm not sharing. You can learn
more about that [here](https://dev.twitter.com/faq#46) and
[here](https://dev.twitter.com/oauth/application-only). Then follow the
instruction in credentials_sample.yml to create your credentials.yml file.

I'm going without bundler or rake here, but the good news is since we
only allow a single gem, just a single
`gem install oauth`
and you'll have you dependencies managed.

Without rake means I wrote some scripts to help out:

* `./runtest` runs the tests (minitest framework)
* `./man_tag_stream` dumps the tags from the twitter stream and is
  helpful in making sure oauth credentials are set up properly
* `./run` starts the system, then hit http://localhost:8080/top10

## Teasers

Some things you'll find in this code that's less than common:

* Mutexes and Threads and Queues, oh my!
* explicit thread management, which is workable in Ruby for an IO bound
  situation
* signal handler traps
* embedded WEBrick
* minitest with a stub and mock
* testing of threaded code
* a very special integration test surprise

