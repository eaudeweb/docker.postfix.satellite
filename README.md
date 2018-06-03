# Postfix satellite host

This image does not send emails (dumb host), it uses another smarthost such as Gmail to send the actual emails. Uses postfix queue features to retry sending temporary failed emails.

This has been tested with Gmail.

## Configuration

```
TZ=Europe/Bucharest
MAIL_SMARTHOST_HOSTNAME=smtp-relay.gmail.com
MAIL_SMARTHOST_PORT=587
MAIL_SMARTHOST_USERNAME=email.address@gmail.com
MAIL_SMARTHOST_PASSWORD=secret
MAIL_DOMAIN=example.com
```

### Gmail 2FA

Sending email through Gmail with 2FA active you need to:

1. enable "less secure apps", read here: https://support.google.com/accounts/answer/6010255
2. Generate an password to use instead of your Gmail password, read here: https://support.google.com/mail/answer/185833


## Volumes

Use exposed volumes from `/var/log` and `/var/spool/postfix` to persist postfix state

## Bibliography

- https://github.com/shamil/docker-postfix-relay
- https://github.com/Tecnativa/docker-postfix-relay
- https://github.com/LyleScott/docker-postfix-gmail-relay
- https://github.com/EnMobile/docker-postfix-gmail-relay
- https://github.com/eea/eea.docker.postfix
- https://www.linode.com/docs/email/postfix/configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/
