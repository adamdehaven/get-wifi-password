#!/bin/sh

# -----------  SET COLORS  -----------
COLOR_RED=$'\e[31m'
COLOR_CYAN=$'\e[36m'
COLOR_YELLOW=$'\e[93m'
COLOR_GREEN=$'\e[32m'
COLOR_RESET=$'\e[0m'

#
# Helper Function to get stored WIFi network SSIDs
# --------------------------------------------------------------------------
getwifinetworks() {
    echo "#    "
    echo "#    Saved Network SSIDs"
    echo "#    -------------------"
    netsh wlan show profiles | findstr All | sed "s/    All User Profile     : /${COLOR_RESET}#    ${COLOR_CYAN}/"
    echo "${COLOR_RESET}#    -------------------"
    echo "#    "
}

#
# Get password of stored WiFi network by SSID.
# --------------------------------------------------------------------------
# Display list of stored SSIDs
getwifinetworks

# Prompt user for WiFi SSID
echo "#    Enter the network name (SSID)"
echo "#    from the list above: "
echo "#    "
read -e -p "#    SSID: ${COLOR_CYAN}" SSID
eval SSID=$SSID

# If SSID is empty, exit early
if [ -z "$SSID" ]; then
    echo "${COLOR_RESET}#    "
    echo "#    ${COLOR_RED}An SSID is required. Please try again.${COLOR_RESET}"
else
    pass=$(netsh wlan show profile name="$SSID" key=clear | findstr Key)

    # If password is empty, notify user they may need
    # elevated privileges
    if [ -z "$pass" ]; then
        echo "${COLOR_RESET}#    "
        echo "#    ${COLOR_RED}If the network SSID appeared in the list above,${COLOR_RESET}"
        echo "#    ${COLOR_RED}fetching the password may require elevated privileges.${COLOR_RESET}"
        echo "#    "
        echo "#    ${COLOR_YELLOW}Open a new prompt with administrator rights${COLOR_RESET}"
        echo "#    ${COLOR_YELLOW}and try running the 'getwifipassword' command again.${COLOR_RESET}"
        echo "#    ${COLOR_YELLOW}Otherwise, the password is not stored on this device.${COLOR_RESET}"
    else
        echo "${COLOR_RESET}#    "
        echo "#    Password for '${SSID}':"
        echo "#    -----------------------------"
        echo "#   " $pass | sed "s/Key Content : /${COLOR_GREEN}/"
        echo "${COLOR_RESET}#    -----------------------------"
    fi
fi