#EZA COlORING CONFIG
export EZA_COLORS="di=1;36:fi=0;37:ex=1;92:ln=1;35:pi=0;33:so=1;32:bd=1;33:cd=1;33"

######## ALIASES ##########

# Better lisitng aliases
alias l='ls -G -A -CF'              # Show files with colors, indicators, hidden
alias ll='ls -lh -G -A'             # Long listing with human-readable sizes
alias alias la='eza -a --color=always --icons --group-directories-first --color-scale=all'
alias t='tree -a -L 2'              # Show tree with hidden files, 2 levels deep

alias aliases="alias | cut -d'=' -f1 | sed 's/^alias //'"   # Show ALL alias names
alias functions='print -l ${(k)functions}'
alias linkf='ln -sf'                              # Symlink

########################### BATTERY INFORMATION ################################
batinfo() {
    ioreg -rn AppleSmartBattery | awk -F'= ' '
    /"CurrentCapacity"/ {curcap=$2}
    /"MaxCapacity"/ {maxcap=$2}
    /"AppleRawMaxCapacity"/ {rawmax=$2}
    /"DesignCapacity"/ {designcap=$2}
    /"CycleCount"/ {cycle=$2}
    /"Voltage"/ {volt=sprintf("%.2f", $2/1000)}
    /"ExternalConnected"/ {plug=$2}
    /"IsCharging"/ {charging=$2}
    /"FullyCharged"/ {full=$2}
    END {
        true_charge = (maxcap > 0) ? (curcap / maxcap) * 100 : 0
        health = (designcap > 0) ? (rawmax / designcap) * 100 : 0
        current_design_mah = (designcap > 0 && maxcap > 0) ? sprintf("%.0f", curcap * (designcap / maxcap)) : curcap

        print "🔋 Battery Report"
        print "------------------------------"
        printf "True Charge       : %.1f%% (raw)\n", true_charge
        printf "macOS Display %%   : %.1f%%\n", true_charge
        printf "Health (Max Cap)  : %.1f%%\n", health
        printf "Current Capacity  : %d mAh (of %d mAh, %.1f%%)\n", current_design_mah, designcap, true_charge
        printf "Full Capacity     : %d mAh\n", rawmax
        printf "Design (Native)   : %d mAh\n", designcap
        printf "Cycle Count       : %s\n", cycle
        printf "Voltage           : %s V\n", volt
        power = (plug == "Yes") ? "AC" : "Battery"
        printf "Power Source      : %s\n", power
        if (charging == "Yes") {
            charge_status = "Charging"
        } else if (plug == "Yes" && full == "Yes") {
            charge_status = "Bypass (100%)"
        } else {
            charge_status = "Not Charging"
        }
        printf "Charging          : %s\n", charge_status
    }'
}
 
######################################### END ######################################


