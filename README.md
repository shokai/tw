tw
==
* one file twitter client.
* Ruby 1.8.7 / 1.9.2 / JRuby 1.6.0.
* for UNIX, Linux and Mac OSX.


Install
-------

    % git clone git://github.com/shokai/tw.git
    % cp tw/tw /path/to/somewhere/
    % which tw


Install Dependencies
--------------------

    % gem install oauth twitter


Use
---

tweet

    % tw hello hello
    % tw @shokai こにちわ
    % yes | tw もう寝よう！


mentions

    % tw


user timeline

    % tw @shokai
    % tw @shokai @ymrl @tomoyo_kousaka


list timeline

    % tw @shokai/homu
    % tw @shokai/homu @shokai/kzsk


search

    % tw ?jruby
    % tw ?ruby ?sinatra
