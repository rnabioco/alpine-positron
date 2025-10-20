#!/bin/bash 

#SBATCH --job-name=positron
#SBATCH --ntasks=1
#SBATCH --time=08:00:00
#SBATCH --mem=20gb
#SBATCH --output=logs/positron-%j.out
#SBATCH --partition=amilan
#SBATCH --qos=normal

mkdir -p logs

# Get the compute node hostname
NODE_HOSTNAME=$(hostname)

cat <<END
========================================
Positron Remote SSH Connection Info
========================================

Compute node: ${NODE_HOSTNAME}
Job ID: ${SLURM_JOB_ID}

CONNECT FROM POSITRON:

1. Add to your local ~/.ssh/config:

Host positron-alpine-${SLURM_JOB_ID}
    HostName ${NODE_HOSTNAME}
    User ${USER}
    ProxyJump ${USER}@login-ci.rc.colorado.edu

2. In Positron: Cmd/Ctrl+Shift+P → "Remote-SSH: Connect to Host"
   Select: positron-alpine-${SLURM_JOB_ID}

3. Positron will install itself on the remote node automatically

When done: scancel ${SLURM_JOB_ID}
========================================
END

# Keep the job alive
while true; do
    sleep 60
done
