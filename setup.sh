#!/bin/bash
# This script will run all of the initial setup commands for the project
# That said, we encourage you to run the commands one by one in the terminal
# so that you can see what is happening and understand the process better

# Set up a Python virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Upgrade pip
python3 -m pip install --upgrade pip

# Install the Python dependencies
python3 -m pip install -r requirements.txt

# Install the pre-commit hooks
pre-commit install

# Install the Node dependencies
npm install --prefix ./reports

# Install the dbt packages
dbt deps
