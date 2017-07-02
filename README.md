tw
==

* CUI Twitter Client.
* http://shokai.github.io/tw
* https://rubygems.org/gems/tw


Install
-------

    % gem install tw

for Ruby 2.0 ~ 2.3 users

    % gem install tw --version=1.0.12


Synopsis
--------

show help

    % tw --help

Tweet

    % tw hello hello
    % echo "hello" | tw --pipe
    % tw 'yummy!!' --file=food.jpg

read Timeline

    % tw @username
    % tw @username @user2 @user3
    % tw @username/listname
    % tw --timeline
    % tw --search=ruby
    % tw --stream
    % tw --stream:filter=ruby,java --silent

DM

    % tw --dm
    % tw --dm:to=shokai "hello!"

Reply/Fav/RT

    % tw @shokai --id
    % tw "@shokai wow!!"  --id=334749349588377601
    % tw --id=334749349588377601
    % tw --fav=334749349588377601
    % tw --rt=334749349588377601

Delete

    % tw --del=334749349588377601

Switch Accounts

    % tw --user:add
    open http://twitter.com/oauth/authorize?oauth_token=a1b2cDEF3456gh78
    input PIN Number: 19283746
    add "@user2"
    % tw --user:list
    * shokai
      user2
      user3
    (3 users)
    % tw hello --user=user2
    % tw --user:default=user2
    set default user "@user2"

Format

    % tw --format=json
    % tw --stream --format="@#{user} #{text} - #{url}"


Make Twitter Bot
----------------
stream reply bot

    % tw --silent --stream:filter=BOT_NAME --user=BOT_NAME --format="@#{user} OK" | tw --pipe --user=BOT_NAME


Test
----

    % gem install bundler
    % bundle install
    % bundle exec rake test


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request