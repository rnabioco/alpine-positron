# Alpine Positron

Launch [Positron](https://github.com/posit-dev/positron) on Alpine, the University of Colorado Boulder's HPC cluster.

## Overview

This SLURM batch script allocates a compute node on Alpine and provides SSH connection instructions for remote development with Positron. The script uses a ProxyJump SSH configuration to connect through Alpine's login node to your allocated compute node.

## Prerequisites

- Access to Alpine HPC cluster
- Positron installed on your local machine
- SSH key configured for Alpine access

## Setup (One-time)

**Add your local machine's SSH key to Alpine:**

If you haven't already, you need to add your local machine's public SSH key to Alpine's authorized_keys file.

1. **On your local machine**, copy your public key:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   Or if you use a different key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. **Log into Alpine** and add the key to authorized_keys:
   ```bash
   ssh <your-username>@login.rc.colorado.edu
   ```

3. **On Alpine**, add your public key:
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   echo "your-public-key-content" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

   Replace `your-public-key-content` with the output from step 1.

This allows your local machine to authenticate with Alpine compute nodes via the ProxyJump connection.

## Quick Start

1. **Submit the job to Alpine:**
   ```bash
   sbatch alpine-positron.sh
   ```

2. **Check job status:**
   ```bash
   squeue -u $USER
   ```

3. **View connection instructions:**
   ```bash
   cat logs/positron-<JOB_ID>.out
   ```
   Replace `<JOB_ID>` with your actual job ID from `squeue`.

4. **Add SSH config to your local machine:**

   Copy the SSH config block from the log file and add it to your `~/.ssh/config` on your local machine. It will look like:
   ```
   Host positron-<JOB_ID>
       HostName <compute-node>
       User <your-username>
       ProxyJump <your-username>@login-ci.rc.colorado.edu
   ```

5. **Connect from Positron:**
   - Open Positron on your local machine
   - Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Select "Remote-SSH: Connect to Host"
   - Choose `positron-<JOB_ID>` from the list
   - Positron will install itself on the remote node automatically

6. **When finished:**
   ```bash
   scancel <JOB_ID>
   ```

## Configuration

The script allocates resources via SLURM directives in `alpine-positron.sh`:

- `--time=08:00:00` - Maximum job duration (8 hours)
- `--mem=20gb` - Memory allocation (20 GB)
- `--partition=amilan` - Alpine partition for general compute
- `--qos=normal` - Quality of service tier

Adjust these parameters based on your computational requirements. See [Alpine documentation](https://curc.readthedocs.io/en/latest/compute/alpine.html) for available options.

## Troubleshooting

**Job won't start:**
- Check queue status: `squeue -u $USER`
- Check available resources: `sinfo`
- Verify your account has hours: `curc-quota`

**Can't connect via SSH:**
- Ensure SSH config was added to your **local** `~/.ssh/config` (not on Alpine)
- Verify job is running: `squeue -u $USER`
- Check log file for correct hostname and job ID
- Verify your local SSH public key is in Alpine's `~/.ssh/authorized_keys` (see Setup section)

**Connection drops:**
- SSH connection may timeout if idle. The job itself will continue running.
- Reconnect using the same SSH host entry.

## Notes

- The compute node allocation will run for the full time requested or until you cancel it
- Always remember to `scancel` your job when done to free resources
- Log files are stored in the `logs/` directory with the pattern `positron-<JOB_ID>.out`

## Resources

- [Alpine Documentation](https://curc.readthedocs.io/en/latest/compute/alpine.html)
- [Positron Documentation](https://github.com/posit-dev/positron)
- [CU Research Computing Support](https://curc.readthedocs.io/)
