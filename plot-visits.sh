#!/bin/bash

# Examples:
# grep 'prenoc.cz' visitor_log.csv | ./plot-visits.sh visits png > chart.png
# grep 'soptik.tech' visitor_log.csv | ./plot-visits.sh source text --unique
#

# Dependencies:
# awk
# python3
# gnuplot

# Expected stdin: log file (grepped to only contain lines we're interested in
# $1: vpd OR visits	-> plot visits per day (line)
#     src OR source	-> plot pie chart of domain sources
# $2: text OR png	-> output format
# $3: --unique -> plot only unique visits
#	(only first IP address occurance is logged)
# Stdout: .png file (byte stream)
# TODO: Animated chart?
#
# Stdin should look like:
#
# (ip address is partially cut in some cases to only contain the last segment)
# date;url;tracing_enabled;referrer;ip_address
# 2019-11-30 11:28:18.924637;https://soptik.tech/articles/beware-of-shell-globs.html;False;Unknown;233
# (...)
# 2019-11-30 11:28:20.495925;https://soptik.tech/articles/tags.html?tag=shell;False;Unknown;233

clean() {
	rm -f "$tmpfile"
}

trap 'clean' EXIT

data=""
tmpfile=$(mktemp)

# This is used to generate chart title.
# If we only process unique IP addresses, this
# whill be set to "Unique", otherwise it will stay
# empty.
title__is_unique=""

# If only unique:
if [[ "$3" == "--unique" ]]; then
	title__is_unique="Unique"
	# Filter records to only contain first log of IP address
	data=$(awk ' BEGIN { FS=";" }
{ 
	if(IPS[$5] != 1) {
		IPS[$5] = 1
		print $0
	}
}	')
# Save all records into variable
else
	data=$(cat -)
fi

echo "Data points:$(wc -l <<<"$data")" >&2

#┌─────────────────────┐
#│ PLOT VISITS PER DAY │
#└─────────────────────┘

if [[ "$1" == "vpd" || "$1" == "visits" ]]; then
	# Count visits per day
	vpd=$(awk ' BEGIN { FS=";" }
{
	# Get date
	split($1, datesplit, " ")
	if(datesplit[1] == "") {
		datecount[datesplit[1]] = 1
	} else {
		datecount[datesplit[1]] += 1
	}
}
END {
	for(key in datecount) {
		print key " " datecount[key]
	}
}' <<< "$data" | sort)
	if [[ "$2" == "text" ]]; then
		echo "$vpd"
	elif [[ "$2" == "png" ]]; then
		title="Visits per day"
		if [[ "$title__is_unique" == "Unique" ]]; then
			title="First time visits per day"
		fi
		echo "$vpd" > "$tmpfile"
		echo "
		set timefmt \"%Y-%m-%d\"
		set xdata time
		set xtics format \"%Y-%m\"
		set terminal pngcairo
		set title \"$title\"
		plot [:][:] '$tmpfile' using 1:2 with lines title \"$title__is_unique IP address count\"" | gnuplot
	else
		echo "Unknown option \$2: '$2'. Expected: text OR png" >&2
		exit 1
	fi
#┌───────────────────────┐
#│ PLOT REFERRER SOURCES │
#└───────────────────────┘
elif [[ "$1" == "src" || "$1" == "source" ]]; then
	# Prepare referrer data
	# replace referrer "" with "(none)"
	src=$(awk ' BEGIN { FS=";" }
{
	# Prepare referrer data
	if( $4 == "" ) {
		ref="(none)"
	} else {
		ref=$4
	}

	print ref

}' <<< "$data" | cut -d'/' -f3)
	# Now remove subdomains
	# Examples:
	# soptik.tech -> soptik.tech
	# m.facebook.com -> facebook.com
	# com.google.android.googlequicksearchbox -> android.googlequicksearchbox
	src=$(python3 -c '
import sys
for line in sys.stdin:
	print(".".join(line.split(".")[-2:]), end="")
' <<< "$src" | sort | uniq -c | sort -nr)
	if [[ "$2" == "text" ]]; then
		echo "$src"
	elif [[ "$2" == "png" ]]; then
		echo "This is work in progress." >&2
		exit 2
		title="$title__is_unique referrers"
		# FIXME: Add pie chart generator
	else
		echo "Unknown option \$2: '$2'. Expected: text OR png" >&2
		exit 1
	fi
else
	echo "Unknown option \$1: '$1'. Expected:" >&2
	printf "vpd OR visits\t-> plot visits per day (line)\n" >&2
	exit 1
fi


