# Create a file named 'run-ollama.sh'
echo '#!/bin/bash
source ~/ollama-env/bin/activate
export SHARK_AMD_GPU=1
export SHARK_FORCE_VULKAN=1
OLLAMA_BACKEND=shark ollama "$@"' > ~/run-ollama.sh


