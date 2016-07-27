# TwitterMonitor
A script which enables you to receive notifications via OS and e-mail when a specific user has tweeted something new.

Script requires use of several packages including: 

* cURL 
* mailutils
* libnotify-bin.

### Parameters
Parameter 1: 

- twitter username

Parameter 2:

- e-mail address to send notifications to.

### Usage
Set permissions:

```
chmod a+x pagechecker.sh
```

Example use:

```
./pagechecker.sh foxnews example@example.com
```

The following link is useful for configuring Postfix to use Gmail SMTP (Simple Mail Transfer Protocol):

[http://askubuntu.com/questions/522431/how-to-send-an-email-using-command-line#answer-522434](http://askubuntu.com/questions/522431/how-to-send-an-email-using-command-line#answer-522434)
