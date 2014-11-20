# Ingress Hubot

A collection of Ingress-related commands for Hubot. This script is designed
specifically for use with the Slack adapter.

[![Build Status](https://travis-ci.org/hubot-scripts/hubot-ingress.svg)](https://travis-ci.org/hubot-scripts/hubot-ingress)

## Features

* Report level requirements
* List requirements for all levels
* Store badge information for players
* *much more to come...*

## Installation

`npm install hubot-ingress`

Then add `"hubot-ingress"` to `external-scripts.json`

Go to the custom emojis page of your Slack team. Upload each of the images from
the `badges/` subfolder, naming them the same as their filename (without the extension).
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

## Commands

### AP requirement

Reports the AP/badge requirements for the specified level.

`hubot AP until L<level>`

### List levels

Show the AP/badge requirements for every level.

`hubot AP all`

### Add badges

Badges can be added one by one or multiples at a time, and can be added for other players.
Badges that have levels end with a number representing that level (1=bronze, 2=silver, etc).
When a badge is added that is the same as an existing badge (hacker5 vs hacker1, for example),
then the new badge will replace the existing badge.

`hubot I have the hacker3, founder badges`

`hubot user1 has the recursion badge`

### Remove badges

Badges can be removed one by one.

`hubot I don't have the hacker1 badge`

### Get Intel map

Gives you a link to the Ingress Intel map based on Google Maps search.

`hubot intelmap soho ny`
