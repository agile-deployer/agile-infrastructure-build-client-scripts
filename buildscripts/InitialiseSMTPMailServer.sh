#!/bin/sh
#########################################################################################
# Author : Peter Winter
# Date   : 13/07/2016
# Description : This script sets up the configuration needed for the mail server. This should
# only be run by the domain master.
#########################################################################################
# License Agreement:
# This file is part of The Agile Deployment Toolkit.
# The Agile Deployment Toolkit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# The Agile Deployment Toolkit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with The Agile Deployment Toolkit.  If not, see <http://www.gnu.org/licenses/>.
#########################################################################################
#########################################################################################
#set -x

if ( [ "${SYSTEM_EMAIL_USERNAME}" != "" ] && [ "${SYSTEM_EMAIL_PASSWORD}" != "" ] && [ "${SYSTEM_EMAIL_PROVIDER}" != "" ] && [ "${SYSTEM_TOEMAIL_ADDRESS}" != "" ] && [ "${SYSTEM_FROMEMAIL_ADDRESS}" != "" ] )
then
    status "#############################################################"
    status "Your system email username is set to ${SYSTEM_EMAIL_USERNAME}"
    status "Your system email password is set to ${SYSTEM_EMAIL_PASSWORD}"
    status "Your system email provider is set to ${SYSTEM_EMAIL_PROVIDER}"
    status "Your system email to address is set to ${SYSTEM_TOEMAIL_ADDRESS}"
    status "Your system email from address is set to ${SYSTEM_FROMEMAIL_ADDRESS}"
    status "#############################################################"
#else
#    status "#############################################################"
#    SYSTEM_EMAIL_USERNAME="`/bin/cat ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILUSERNAME.dat`"
#    status "Your system email username is set to ${SYSTEM_EMAIL_USERNAME}"
#    SYSTEM_EMAIL_PASSWORD="`/bin/cat ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILPASSWORD.dat`"
#    status "Your system email password is set to ${SYSTEM_EMAIL_PASSWORD}"
#    SYSTEM_EMAIL_PROVIDER="`/bin/cat ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILPROVIDER.dat`"
#    status "Your system email provider is set to ${SYSTEM_EMAIL_PROVIDER}"
#    SYSTEM_TOEMAIL_ADDRESS="`/bin/cat ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/TOEMAILADDRESS.dat`"
#    status "Your system email to address is set to ${SYSTEM_TOEMAIL_ADDRESS}"
#    SYSTEM_FROMEMAIL_ADDRESS="`/bin/cat ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/FROMEMAILADDRESS.dat`"
#    status "Your system email from address is set to ${SYSTEM_FROMEMAIL_ADDRESS}"
 #   status "#############################################################"
fi

update="1"

if ( [ "${SYSTEM_EMAIL_USERNAME}" != "" ] && [ "${SYSTEM_EMAIL_PASSWORD}" != "" ] && [ "${SYSTEM_EMAIL_PROVIDER}" != "" ] && [ "${SYSTEM_TOEMAIL_ADDRESS}" != "" ] && [ "${SYSTEM_FROMEMAIL_ADDRESS}" != "" ] )
then
    status "Do you want to keep these settings or enter new ones, obviously, these settings must be live and active for system emails to be sent"
    status "Please enter Y or y to keep these for your SMTP serttings"
    read response

    if ( [ "${response}" != "y" ] && [ "${response}" != "Y" ] )
    then
        update="1"
    else 
        update="0"
    fi
else
    status "You don't seem to have an SMTP settings configured. This is fine it just means that you system emails won't be sent"
    status "If you are happy not to set any SMTP settings, then, enter 'N' or 'n' below, anything else to to configure your SMTP settings next"
    read response
    if ( [ "${response}" = "N" ] || [ "${response}" = "n" ] )
    then
        update=0
    else
        update="1"
    fi
fi

if ( [ "${update}" = "1" ] && [ "${HARDCORE}" != "1" ] )
then
    status "##################################################################################################################################"
    status "We need to have a smtp service for emails generated by the deployed application as well as system emails from the infrastructure to you, the webmaster"
    status "It is therefore necessary to provide an email address which can be used both to send emails from the application and also to send system messages to"
    status "##################################################################################################################################"
    status "So, please enter the email address where you wish system messages to be sent"
    read SYSTEM_TOEMAIL_ADDRESS

    while ( [ "${SYSTEM_TOEMAIL_ADDRESS}" = "" ] || [ "`/bin/echo ${SYSTEM_TOEMAIL_ADDRESS} | /bin/grep -E "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"`" = "" ] )
    do
        status "That seems to be an invalid email address, please try again"
        read SYSTEM_TOEMAIL_ADDRESS
    done

    status "##################################################################################################################################"
    status "We also need to set up an SMTP provider to send the system status emails through"
    status "If you don't have an account with one of the supported smtp server providers, please set one up first"
    status "Which SMTP provider are you registered with?"
    status "There's a little trick of aesthetics here. Gmail is free, but mails will be sent with an email address like fred@gmail.com"
    status "SMTP pulse, for example is not free, but you can register your postmaster@yourdomain.com from your postfix deployment and mails will be personalised to your domain then"
    status "##################################################################################################################################"
    status "Currently, we support 1) SMTP Pulse (www.sendpulse.com) 2) Google (gmail) 3) Amazon (SES)"
    read SYSTEM_EMAIL_PROVIDER

    while ( [ "${SYSTEM_EMAIL_PROVIDER}" = "" ] || [ "`/bin/echo '1 2 3' | /bin/grep ${SYSTEM_EMAIL_PROVIDER}`" = "" ] )
    do
        status "Invalid choice, please try again"
        read SYSTEM_EMAIL_PROVIDER
    done

    status "Please enter 1) The Address you would like system emails to be sent from"
    read SYSTEM_FROMEMAIL_ADDRESS

    while ( [ "${SYSTEM_FROMEMAIL_ADDRESS}" = "" ] || [ "`/bin/echo ${SYSTEM_FROMEMAIL_ADDRESS} | /bin/grep -E "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"`" = "" ] )
    do
        status "That seems to be an invalid email address, please try again"
        read SYSTEM_FROMEMAIL_ADDRESS
    done

    status "Please enter your email address or username for your SMTP provider"
    read SYSTEM_EMAIL_USERNAME
    
    if ( [ "${SYSTEM_EMAIL_PROVIDER}" != "3" ] )
    then
        while ( [ "${SYSTEM_EMAIL_USERNAME}" = "" ] || [ "`/bin/echo ${SYSTEM_EMAIL_USERNAME} | /bin/grep -E "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"`" = "" ] )
        do
            status "That seems to be an invalid email address, please try again"
            read SYSTEM_EMAIL_USERNAME
        done
    fi

    status "Please enter your password for your SMTP provider"
    read SYSTEM_EMAIL_PASSWORD

    export SYSTEM_EMAIL_USERNAME="${SYSTEM_EMAIL_USERNAME}"
    export SYSTEM_EMAIL_PASSWORD="${SYSTEM_EMAIL_PASSWORD}"
    export SYSTEM_EMAIL_PROVIDER="${SYSTEM_EMAIL_PROVIDER}"
    export SYSTEM_TOEMAIL_ADDRESS="${SYSTEM_TOEMAIL_ADDRESS}"
    export SYSTEM_FROMEMAIL_ADDRESS="${SYSTEM_FROMEMAIL_ADDRESS}"

    /bin/echo ${SYSTEM_EMAIL_USERNAME} > ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILUSERNAME.dat
    /bin/echo ${SYSTEM_EMAIL_PROVIDER} > ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILPROVIDER.dat
    /bin/echo ${SYSTEM_TOEMAIL_ADDRESS} > ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/TOEMAILADDRESS.dat
    /bin/echo ${SYSTEM_FROMEMAIL_ADDRESS} > ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/FROMEMAILADDRESS.dat
    /bin/echo ${SYSTEM_EMAIL_PASSWORD} > ${BUILD_HOME}/buildconfiguration/${CLOUDHOST}/${BUILD_IDENTIFIER}-credentials/SYSTEMEMAILPASSWORD.dat
fi
