Inspired by [this project](https://github.com/robcolbert/gablocked), this tool
allows viewing the users who have blocked you on [Gab](https://gab.com).

Usage
-----

0. Install Ruby (develped with ruby 3.0.3)
1. Checkout this repository
2. Run "ruby main.rb"
3. Copy the contents of https://gab.com/api/v1/blockedby and save to db/block\_list.json
4. Open browser to http://localhost:8081/
5. Wait for the data to load.

Dependencies
----

* Ruby 3.0.3
* WEBrick (included)

Future Work
-----

I am a terrible UX designer and this code reflects that. I also spent less than
2 hours (though I did pull code and design from another projects in) on it so
tread carefully.

