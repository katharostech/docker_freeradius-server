#!/bin/bash

chown root:freerad ${CLIENT_CONFIG}
chown root:freerad ${USERS_CONFIG}
chmod 640 ${CLIENT_CONFIG}
chmod 640 ${USERS_CONFIG}
