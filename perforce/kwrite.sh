#!/bin/bash
# File              : kwrite.sh
# Author            : John Gentile <johncgentile17@gmail.com>
# Date              : 14.02.2018
# Last Modified Date: 14.02.2018
# Last Modified By  : John Gentile <johncgentile17@gmail.com>
LD_LIBRARY_PATH=/home/jgentile/Perforce/lib/icu
export LD_LIBRARY_PATH
kwrite $1
