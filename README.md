Generate PDF invoice, CSV timesheet and dividend certificates from slim templates and ruby code.

## Install

Install `phantomjs` then:

    gem install contract_ltd


## New client

    invoice new

## Usage

    invoice [-f] -months_ago [-i d1,d2,d3,...] [-x d1,d2,d3,...]

    dividend <final|interim> <date paid> <tax year end> <net amount> <company year end>

## Examples

Generate timesheet/invoice for last month, worked every week day:

    invoice -1

Generate timesheet/invoice for current month, worked every day except last week:

    invoice -0 -x 26,27,28,29,30

Regenerate timesheet/invoice for 2 months ago, only worked a couple of days plus 1 half day

    invoice -f -2 -i 3,4,5am

Generate a final dividend for 8th August 2015 for £20,000

    dividend 20150810 2015 20000 2016

