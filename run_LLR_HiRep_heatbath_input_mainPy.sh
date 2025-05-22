#!/usr/bin/bash




python3 \
  main.py \
  --input_params_csv MareNostrum.csv \
  --machine MareNostrum \
  --partition gp \
  --account ehpc191 \
  --modules "gcc/12.3.0 openmpi/4.1.5-gcc" \
  --run_index 1 \
  --path_llr_exec "\${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB" \
  --output_run_dir "${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB"

