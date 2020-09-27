#!/bin/bash

# ansible/ansible/lib/ansible/plugins/connection/ssh.py
# exec_command(self, cmd, in_data=None, sudoable=True) calls _build_command(self, binary, *other_args) as:
#   args = (ssh_executable, self.host, cmd)
#   cmd = self._build_command(*args)
# So "host" is next to the last, cmd is the last argument of ssh command.

host="${@: -2: 1}"
cmd="${@: -1: 1}"

socket="/tmp/ansible-ssh-${target_host}-22-iap"

gcloud_args="--tunnel-through-iap \
--project=corp-devbox-id \
--zone=us-central1-a \
--quiet
--no-user-output-enabled
--
-C
-o ControlMaster=auto
-o ControlPersist=20
-o PreferredAuthentications=publickey
-o KbdInteractiveAuthentication=no
-o PasswordAuthentication=no
-o ConnectTimeout=20"

if [ -e "$socket" ]; then
  exec gcloud compute ssh "$host" \
       $gcloud_args \
       -o ControlPath="$socket" \
       "$cmd"
else
  exec gcloud compute ssh "$host" \
       $gcloud_args \
       -o ControlPath="$socket" \
       "$cmd"
fi
