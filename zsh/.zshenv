# Cleanup some conda environment variables to avoid messing up in tmux, etc.
# (these environment variables might be copied and inherited unwantedly)
unset CONDA_EXE
unset CONDA_PREFIX
unset CONDA_DEFAULT_ENV
unset CONDA_PYTHON_EXE
unset CONDA_SHLVL

# conda (miniforge3, miniconda3)
function _try_conda_base() {
  local conda_base="$1"
  [[ -z "$conda_base" ]] && return 1;
  if [[ -n "$CONDA_EXE" ]]; then
    return 0;  # do nothing, CONDA_EXE is already found
  fi

  if [ -d "$conda_base" ]; then
    path=( $path "$conda_base/bin" )
    export CONDA_EXE="$conda_base/bin/conda"
    if [ ! -f "$CONDA_EXE" ]; then
      echo "Warning: $CONDA_EXE does not exist"
    fi
  fi
}

_try_conda_base "$HOME/.miniforge3";
_try_conda_base "$HOME/miniforge3";
_try_conda_base "$HOME/.miniconda3";
_try_conda_base "$HOME/miniconda3";
_try_conda_base "/usr/local/miniconda3";
_try_conda_base "/opt/conda";
unfunction _try_conda_base

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
