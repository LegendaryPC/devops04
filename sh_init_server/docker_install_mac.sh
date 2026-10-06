#!/bin/bash

set -e

COLOR_RESET="\033[0m"
COLOR_INFO="\033[1;34m"
COLOR_SUCCESS="\033[1;32m"
COLOR_ERROR="\033[1;31m"

DOCKER="[DOCKER]"

log_info() {
    echo -e "\n${COLOR_INFO}===> $1${COLOR_RESET}"
}

log_success() {
    echo -e "${COLOR_SUCCESS}[✔] $1${COLOR_RESET}"
}

log_error() {
    echo -e "${COLOR_ERROR}[✖] $1${COLOR_RESET}"
}

# =========================================================
# Check OS
# =========================================================

log_info "${DOCKER} Checking operating system"

if [[ "$(uname -s)" != "Darwin" ]]; then
    log_error "${DOCKER} This script is only for macOS."
    exit 1
fi

log_success "${DOCKER} macOS detected"


# =========================================================
# Check user
# =========================================================

log_info "${DOCKER} Checking current user"

CURRENT_USER="$(whoami)"

if [[ "$CURRENT_USER" != "hackme" ]]; then
    log_error "${DOCKER} This script is designed for user 'hackme'."
    log_error "${DOCKER} Current user: $CURRENT_USER"
    exit 1
fi

log_success "${DOCKER} User 'hackme' detected"


# =========================================================
# Check Homebrew
# =========================================================

log_info "${DOCKER} Checking Homebrew"

if command -v brew >/dev/null 2>&1; then
    log_success "${DOCKER} Homebrew is already installed"
else
    log_info "${DOCKER} Installing Homebrew"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    log_success "${DOCKER} Homebrew installed successfully"
fi


# =========================================================
# Update Homebrew
# =========================================================

log_info "${DOCKER} Updating Homebrew"

brew update

log_success "${DOCKER} Homebrew updated"


# =========================================================
# Install Docker Desktop
# =========================================================

log_info "${DOCKER} Checking Docker Desktop"

if brew list --cask docker >/dev/null 2>&1; then

    log_success "${DOCKER} Docker Desktop is already installed"

else

    log_info "${DOCKER} Installing Docker Desktop"

    brew install --cask docker

    log_success "${DOCKER} Docker Desktop installed successfully"

fi


# =========================================================
# Start Docker Desktop
# =========================================================

log_info "${DOCKER} Starting Docker Desktop"

if pgrep -f "Docker Desktop" >/dev/null 2>&1; then

    log_success "${DOCKER} Docker Desktop is already running"

else

    open -a "Docker"

    log_info "${DOCKER} Waiting for Docker daemon..."

    MAX_RETRIES=60
    COUNT=0

    while ! docker info >/dev/null 2>&1; do

        sleep 2

        COUNT=$((COUNT + 1))

        if [[ "$COUNT" -ge "$MAX_RETRIES" ]]; then
            log_error "${DOCKER} Docker daemon did not start within 120 seconds."
            exit 1
        fi

    done

    log_success "${DOCKER} Docker daemon started successfully"

fi


# =========================================================
# Verify Docker
# =========================================================

log_info "${DOCKER} Verifying Docker installation"

docker --version

echo ""

docker info >/dev/null

log_success "${DOCKER} Docker installation verified"


# =========================================================
# Test Docker
# =========================================================

log_info "${DOCKER} Running Docker test container"

docker run --rm hello-world

log_success "${DOCKER} Docker is ready to use!"

echo ""
echo "=============================================="
echo " Docker installation completed successfully"
echo " User      : $(whoami)"
echo " OS        : $(uname -s)"
echo " Docker    : $(docker --version)"
echo "=============================================="
