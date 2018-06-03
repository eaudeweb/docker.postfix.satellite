#!/usr/bin/env sh

#set -e

[ "${DEBUG}" == "yes" ] && set -x

if [ ! -z "${TZ}" ]; then
    echo "Setting system timezone to ${TZ}"
    echo "${TZ}" > /etc/timezone
fi

postconf -e "relayhost = [${MAIL_SMARTHOST_HOSTNAME}]:${MAIL_SMARTHOST_PORT}"
postconf -e "myhostname = ${MAIL_DOMAIN}"
postconf -e "mydomain = ${MAIL_DOMAIN}"
postconf -e "mydestination = \$myhostname"
postconf -e "myorigin = \$mydomain"
postconf -e "relayhost = [${MAIL_SMARTHOST_HOSTNAME}]:${MAIL_SMARTHOST_PORT}"
postconf -e "smtp_use_tls = yes"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_tls_security_level = may"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_sasl_security_options = noanonymous"

# Create sasl_passwd file with auth credentials
if [ ! -f /etc/postfix/sasl_passwd ]; then
  grep -q "${MAIL_SMARTHOST_HOSTNAME}" /etc/postfix/sasl_passwd  > /dev/null 2>&1
  if [ $? -gt 0 ]; then
    echo "Adding SASL authentication configuration"
    echo "[${MAIL_SMARTHOST_HOSTNAME}]:${MAIL_SMARTHOST_PORT} ${MAIL_SMARTHOST_USERNAME}:${MAIL_SMARTHOST_PASSWORD}" >> /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
  fi
fi

unset MAIL_SMARTHOST_PASSWORD

newaliases

mkdir -p /var/log/supervisor
if [ ! -f /var/log/supervisor/supervisord.log ]; then
	echo "Creating /var/log/supervisor/supervisord.log"
	touch /var/log/supervisor/supervisord.log
fi

#Start services
supervisord -c /etc/supervisord.conf
