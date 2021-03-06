#!/bin/bash
 
# Copyright 2015, 2016, 2017 Ingo Steinwart
#
# This file is part of liquidSVM.
#
# liquidSVM is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as 
# published by the Free Software Foundation, either version 3 of the 
# License, or (at your option) any later version.
#
# liquidSVM is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with liquidSVM. If not, see <http://www.gnu.org/licenses/>.


 



# Determine where I am and where the data might be.

SML_SCRIPTS_DIR=`dirname $0`
source $SML_SCRIPTS_DIR/auxiliary/get-directories.sh


# Set default values

source $SML_SCRIPTS_DIR/set-default-values.sh
: ${CLIPPING:=-1.0}


# Here the number of considered tau-quantiles as well as the 
# considered tau-values are defined. You can freely change these
# values but notice that the list of tau-values is space-separated!

: ${WEIGHT_STEPS:=5}
: ${WEIGHTS:="0.05 0.1 0.5 0.9 0.95"}


# Display help message

if [[ -z "$1" ]]
then
	source $SML_SCRIPTS_DIR/print-default-values.sh "qt-svm.sh" "[<clipping>]"
	echo "clipping:              "$CLIPPING
	echo
	source $SML_SCRIPTS_DIR/print-meaning-of-parameters.sh
	source $SML_SCRIPTS_DIR/print-meaning-of-clipping.sh
	exit             
fi


# Copy command line arguments into variables 

source $SML_SCRIPTS_DIR/read-standard-arguments.sh "${@:1:7}"

if ! [[ -z $8 ]]
then
	CLIPPING=$8
fi


# Set some extra options

FOLDS=$RANDOM_FOLDS" "$NUM_FOLDS
SVM_TYPE=$SVM_QUANTILE
VOTE_TYPE=$VOTE_METHOD" 1"
LOSS_TYPE=4



# Get file names and grid specifications

source $SML_SCRIPTS_DIR/get-file-names.sh
source $SML_SCRIPTS_DIR/get-grid-and-partition.sh 



# Train and test the SVM

source $SML_SCRIPTS_DIR/svm-train.sh
for (( WEIGHT_NUMBER=1; WEIGHT_NUMBER<=$WEIGHT_STEPS; WEIGHT_NUMBER++ ))
do
	source $SML_SCRIPTS_DIR/svm-select.sh
done
source $SML_SCRIPTS_DIR/svm-test.sh


