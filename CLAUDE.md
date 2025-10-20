# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a SLURM batch script for launching Positron (an IDE) on Alpine, the University of Colorado Boulder's HPC cluster. The script allocates compute resources and provides SSH connection instructions for remote development.

## Architecture

The repository is intentionally minimal:

- `alpine-positron.sh`: SLURM batch script that allocates a compute node and provides connection details
- The script uses a ProxyJump SSH configuration pattern to connect through the login node to the allocated compute node

## SLURM Submission

Submit the job to Alpine:
```bash
sbatch alpine-positron.sh
```

Monitor job status:
```bash
squeue -u $USER
```

Cancel the job when done:
```bash
scancel <JOB_ID>
```

View output logs:
```bash
cat logs/positron.out
```

## Key Configuration Parameters

The SLURM directives in `alpine-positron.sh` control resource allocation:

- `--time`: Maximum job duration (currently 8 hours)
- `--mem`: Memory allocation (currently 20gb)
- `--partition`: Alpine partition (amilan for general compute)
- `--qos`: Quality of service tier

These parameters should be adjusted based on computational requirements. Alpine documentation: https://curc.readthedocs.io/en/latest/compute/alpine.html

## SSH Configuration Pattern

The script generates a temporary SSH config entry using:
1. **ProxyJump**: Routes connection through login.rc.colorado.edu
2. **Dynamic hostname**: Uses the allocated compute node's hostname
3. **Job-specific alias**: `positron-${SLURM_JOB_ID}` for easy identification

This pattern enables Positron's Remote-SSH extension to connect directly to the compute node while respecting Alpine's security model.
