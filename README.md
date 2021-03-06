# Socializer [![License](https://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://opensource.org/licenses/mit-license.php) [![Gem Version](https://img.shields.io/gem/v/socializer.svg?style=flat-square)](https://rubygems.org/gems/socializer) [![Status](https://img.shields.io/badge/Alpha-Not_Production_Ready-d84a38.svg?style=flat-square)](#important-notice)

[![Build status](https://img.shields.io/travis/socializer/socializer/master.svg?style=flat-square)](https://travis-ci.org/socializer/socializer)
[![Coverage Status](https://img.shields.io/coveralls/socializer/socializer.svg?style=flat-square)](https://coveralls.io/r/socializer/socializer?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/socializer/socializer.png?style=flat-square)](https://codeclimate.com/github/socializer/socializer)
[![Gemnasium](https://img.shields.io/gemnasium/socializer/socializer.svg?style=flat-square)](https://gemnasium.com/socializer/socializer)
[![Inline docs](http://inch-ci.org/github/socializer/socializer.svg?branch=master&style=flat-square)](http://inch-ci.org/github/socializer/socializer)

Socializer is a rails engine fully dedicated to adding social network capabilities so you can focus
on what really matters.

It is designed based on the Wikipedia definition of [social networks](http://en.wikipedia.org/wiki/Social_network)
and the excellent spec from [activitystrea.ms](http://www.activitystrea.ms). Yes, it may look like a Google+ clone, but Google did a
great job implementing the social network definition. And yes, it does a lot less than Google+, we don't have
400 developers on the project.

## Important notice

Socializer is **not ready for production** yet. It's a work in progress. If you would like to get involved, fork and work! Or contact me at dominic.goulet@icloud.com.

## Core concepts

**People** are connected with each other in numerous ways. First of all, they can signify to another person
that they want to be connected with them by adding them to their **circles**. The association between a person
and a circle is called a **tie**. This link is not direct and does not force each person to have the same link.
For instance, one person can classify the other as a 'friend', while the other person will return the favor by adding
them to their 'colleague' circle. Second, **groups** are a link between people where all members share the same level
of connection with each other. They are all members of the 'Project X Research Group'. The association between a
person and a group is called **membership**.

Like any other social networking application, you can post **notes**. Notes are pieces of information (currently only
text is supported, but pictures, videos, files and more are coming) that you want to keep for posterity.

When you perform actions in Socializer, there is a log of your **activities**. Activities are shared with
an **audience**. Let's say you perform the action of creating a note. While creating a note,
you will have to specify the audience for that note. You can choose between 'Public', 'All your circles', any of your
circles, any of your groups, and any of the people you are connected with.

People can view the activity **stream** with different filters :
* **Profile** - you see all the activities of a single person
* **Circle** - you see the activities performed by the people in that circle
* **Group** - you see the activities performed by the people in that group
* **Home** - you see everything from the people you connect with (groups, circles, yourself)

When viewing a stream, people can **comment** on any of the objects in the stream.

For registration and login, Socializer is currently using omniauth with the following providers:
LinkedIn, Facebook, Twitter, Yahoo, Google and Identity. Once your account is created, you can bind multiple
authentications to your account. This will be used later on to share your activities with other networking sites.

## Installation

Add this line to your application's Gemfile:

    gem 'socializer', github: 'dominicgoulet/socializer'

And then execute:

    $ bundle

Then:

    rake socializer:install:migrations

Don't forget to migrate your database:

    rake db:migrate

## Getting Started


## Todo

The todo list is as follows :
* Finish core components (people, circles, groups, notes, comments)
* Complete the activity stream (activities, audience)
* Add notifications (notify a person when an activity affects them directly)
* Add interaction with other networking sites (authentications)
* Add a search feature (to find people, groups and notes)
* Create a comprehensive html structure that can easily be templated in host applications
* Package the engine cleanly (configurations, file names, etc.)

## If you want to contribute

The best way to contribute is to do one of the following :
* Creating tests
* Refactoring
* Coding features
* Correcting logged issues
* Correcting my English! (I'm a french Canadian, so don't hesitate to fix my sentences or whole paragraphs.)

## License ##

Copyright 2011-2014, Dominic Goulet, http://www.dominicgoulet.com

MIT License - http://www.opensource.org/licenses/mit-license.php
