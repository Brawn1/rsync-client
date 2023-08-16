#!/bin/bash
set -e

SSHKEYDIR="ssh"
CONFIGDIR="/config"
SSHKEYDESTDIR="/root/.ssh"

# SSH KEY GEN Settings
KEYBIT=4096
RSAKEYNAME="id_rsa"

if [ ! -d "${CONFIGDIR}/${SSHKEYDIR}" ]; then
	echo "create ${CONFIGDIR}/${SSHKEYDIR}"
	mkdir -p ${CONFIGDIR}/${SSHKEYDIR}
fi

if [ ! -d ${SSHKEYDESTDIR} ]; then
	echo "create {SSHKEYDESTDIR}"
	mkdir -p ${SSHKEYDESTDIR}
fi

if [ ! -f "${CONFIGDIR}/${SSHKEYDIR}/${RSAKEYNAME}" ] && [ ! -f "${SSHKEYDESTDIR}/${RSAKEYNAME}" ]; then
	echo "${RSAKEYNAME} not found"
	echo "create new ${RSAKEYNAME} key"
	ssh-keygen -b ${KEYBIT} -f ${CONFIGDIR}/${SSHKEYDIR}/${RSAKEYNAME} -N ""
fi

if [ ! -f "${CONFIGDIR}/${SSHKEYDIR}/${RSAKEYNAME}" ] && [ -f "${SSHKEYDESTDIR}/${RSAKEYNAME}" ]; then
	echo "backup ssh key from ${SSHKEYDESTDIR} -> ${CONFIGDIR}/${SSHKEYDIR}"
	cp -R ${SSHKEYDESTDIR}/* ${CONFIGDIR}/${SSHKEYDIR}/
fi

if [ ! -f "${SSHKEYDESTDIR}/${RSAKEYNAME}" ]; then
	echo "copy ssh key from ${CONFIGDIR}/${SSHKEYDIR} -> ${SSHKEYDESTDIR}"
	cp -R ${CONFIGDIR}/${SSHKEYDIR}/* ${SSHKEYDESTDIR}/ && chown -R root:root ${SSHKEYDESTDIR} && chmod -R 700 ${SSHKEYDESTDIR}
fi

exec "$@"
