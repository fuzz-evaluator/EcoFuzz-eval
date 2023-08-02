#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# please change the EXP_ID variable if you divide the experiments into multiple e.g by  setting it to the target name:
# EXP_ID="nm"
# EXP_ID="libpng"
# EXP_ID="objdump"

# please note: Experiment name must match: "^[a-z0-9-]{0,30}$"
EXP_ID="full"
EXPERIMENT_NAME="ecofuzz"-"$EXP_ID"

cd "${SCRIPT_DIR}/fuzzbench"

# all benchmarks and all cometitors
# please note: running this config without further modifications need a lot of ressource
# (10 Trials * 3 Targets * 3 Fuzzers = 90 docker containers). To reporduce evaluation in a reliable way,
# we advise to just execute as many docker containers in paralell as you have physical cpu cores.
# therefore comment out some of the benchmarks.
BENCHMARKS="binutils_fuzz_nm libpng_libpng_read_fuzzer binutils_fuzz_objdump"
FUZZER="afl_2_52_b aflfast ecofuzz"

source .venv/bin/activate
PYTHONPATH=. python3 experiment/run_experiment.py \
  --experiment-config "${SCRIPT_DIR}/config.yaml" \
  --benchmarks $BENCHMARKS \
  --experiment-name "${EXPERIMENT_NAME}" \
  --concurrent-builds 2 \
  -a \
  --fuzzers $FUZZER
