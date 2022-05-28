# Slack for One Logger

[![App Exchange](https://img.shields.io/badge/AppExchange-Slack%20for%20One%20Logger%20-blue)](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000GV7OBUA1)
[![Security Review](https://img.shields.io/badge/Security%20Review-In%20Review-green)](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000GV75lUAD)

One Logger Plugin to send Slack messages.

## Installation

Install our free [Managed Package](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000GV7OBUA1)
from AppExchange.

## Setup

1. Get Slack webhook URL

Create an [incoming webhook](https://api.slack.com/messaging/webhooks).
A webhook URL should look something like this:
```text
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
```

2. Configure Named Credentials

Create a new named credentials.
Set endpoint URL to your Slack webhook URL.
Write down the credential's name.

3. Configure Log Filter

Log Filters are custom metadata from One Logger package.
In this app, we use a Log Filter records to filter Log Events to send.
This package already includes a one record called `Errors_All_Time` 
which is used to filter only Log Events with `ERROR` level.

4. Configure Slack for One Logger Settings

`Slack for One Logger Settings` are custom metadata used to configure Slack integration.

* Log Field Set - you can configure the fields to send in the message using a field set. 
Value should be the field set API name. Note that this field set is created on ok__Log__c object 
but the field values will be populated from ok__Log_Event__e record.

* Log Filter - reference to the Log Filter created in the previous step.

* Named Credentials - name of the named credentials defining the Slack webhook URL.

* Mention Here - add @here mention.

* Mention User Ids - semicolon separated list of Slack User Ids to mention in the message.


