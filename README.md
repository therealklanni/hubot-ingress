# Ingress Hubot [![Build Status](https://travis-ci.org/hubot-scripts/hubot-ingress.svg)](https://travis-ci.org/hubot-scripts/hubot-ingress) [![npm version](https://badge.fury.io/js/hubot-ingress.svg)](http://badge.fury.io/js/hubot-ingress)

A collection of Ingress-related commands for Hubot. This script is designed
specifically for use with the Slack adapter.

## Features

* Report level requirements
* List requirements for all levels
* Store badge information for players
* Calculate recharge rate and max distance for AP level
* Calculate septicycle/checkpoint times
* *much more to come...*

## Installation

`npm install hubot-ingress`

Then add `"hubot-ingress"` to `external-scripts.json`

Go to the custom emojis page of your Slack team. Upload each of the images from
the `badges/` subfolder, naming them the same as their filename (without the
extension).
These emoji will be used by Hubot.

## Configuration

`HUBOT_GOOGLE_GEOCODE_KEY` - An optional Google Geocoding API key.
If configured, this will be used by the "intelmap" feature in order to
convert an address to a lat/long for the intelmap link. The intelmap link
generator should function without this, but it may be needed if the
intelmap generator begins returing no results at some point.

A Geocoding API key can be obtained easily from the [Google Developer Console](https://console.developers.google.com).
At the time of this writing, 2,500 requests/day are provided for free.
Create a new project for your hubot in the developer console, unless you
have one already. Enable "Geocoding API" under "_APIs_" and then
create a new key under "_Credentials_".

`HUBOT_CYCLE_TIME_FMT` - Optionally ovveride the display format for times (see
Moment-timezone.js). Default is "ddd hA" (e.g. "Sun 10pm")

`HUBOT_CYCLE_TZ_NAME` - Optionally set the timezone name (e.g. 'America/Chicago';
see [TZ name list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for names to use.).
This overrides `HUBOT_CYCLE_TZ_OFFSET` if both are set.

`HUBOT_CYCLE_TZ_OFFSET` - Optionally set the timezone offset (e.g. '-05:00',
see [Moment.js](http://momentjs.com/docs/#/manipulating/timezone-offset/)).
Defaults to the server instance's offset. This is used when
`HUBOT_CYCLE_TZ_NAME` is not provided.

### Slack

In order for the badge images to be seen on Slack, you must manually upload
each one as an emoji with the appropriate name. Each image is conveniently
named exactly how the emoji name should appear (leave off the .png of course).

Go to <yourslackdomain>.slack.com/admin/emoji to configure emoji.

## Commands

### AP requirement

Reports the AP/badge requirements for the specified level.

`hubot AP until L<level>`

### List levels

Show the AP/badge requirements for every level.

`hubot AP all`

### Add badges

Badges can be added one by one or multiples at a time, and can be added for
other players. Badges that have levels end with a number representing that
level (1=bronze, 2=silver, etc). When a badge is added that is the same as an
existing badge (hacker5 vs hacker1, for example), then the new badge will
replace the existing badge.

`hubot I have the hacker3, founder badges`

`hubot user1 has the recursion badge`

### Remove badges

Badges can be removed one by one.

`hubot I don't have the hacker1 badge`

### Get Intel map

Gives you a link to the Ingress Intel map based on Google Maps search.

`hubot intelmap soho ny`

### Calculate max recharge distance

Calculate maximum distance from which an agent can recharge, based on agent
level.

`hubot recharge distance [level]`

### Calculate recharge rate/percentage

Calculate recharge efficiency for an agent, based on agent level and distance.

`hubot recharge rate [level] [distance]`

Note: The distance parameter defaults to km, but it can also convert imperial
units, e.g. `hubot recharge rate 11 450 miles`

### Get Septicycle times

Calculate the next septicycle start. Optionally provide a number X to get the
next X start times.

`hubot septicycle|cycle [count]`

### Get Checkpoint times

Calculate the next checkpoint start. Optionally provide a number X to get the
next X start times.

`hubot checkpoint|cp [count]`

### Get Checkpoint times on a day

Calculate the checkpoint times for a given day. Day given can be in common date formats (e.g. 5/17/14, May 4, 1999, 5 May 2016) and in English day names (e.g. Saturday, monday, this Thursday). Note that "Thursday", "this Thursday", and "next Thursday" all return the same data.

`hubot checkpoints|cps on <day>`

### Get Timezone Offset

Returns the current configured timezone offset.

`hubot cycle offset`

### Set Timezone Offset

Temporarily sets the timezone offset. See [Moment.js](http://momentjs.com/docs/#/manipulating/timezone-offset/) for how to configure this.

`hubot cycle set offset [offset]`

### Set Timezone Offset By Name

Temporarily sets the timezone offset by name. See [TZ name list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for names to use.

`hubot cycle set offsetname [offset-name]`

### Calculate MU score

Using the provided scores (from your scanner), calculates the difference currently needed to win the cycle.

`hubot mind units needed [ours] [theirs]`
`hubot mu needed [ours] [theirs]`
`hubot mu [ours] [theirs]`

MU scores can be absolute numbers or shortened by 1000 (both 42000 and 42k work).

### Calculate MU average score

Using the provided scores (from your scanner), calculates the difference per cycle currently needed to win the cycle.

`hubot mind units average [ours] [theirs]`
`hubot mu average [ours] [theirs]`

MU scores can be absolute numbers or shortened by 1000 (both 42000 and 42k work).
