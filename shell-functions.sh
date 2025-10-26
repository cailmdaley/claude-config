# Shell functions and aliases for research workflows
# Source this file in ~/.bashrc or ~/.zshrc

# Apptainer container management with bind mounts
function app() {
    local apptainer_opts=()

    if [ "${1:-}" = "--writable" ]; then
        apptainer_opts+=(--writable)
        shift
    fi

    if [ $# -eq 0 ]; then
        apptainer shell "${apptainer_opts[@]}" --bind /home,/scratch,/automnt,/n17data,/n23data1,/n09data, /n17data/cdaley/containers/containers/
        return
    fi

    apptainer exec "${apptainer_opts[@]}" --bind /home,/scratch,/automnt,/n17data,/n23data1,/n09data /n17data/cdaley/containers/containers/ "$@"
}

# Use Kimi k2 model with Claude CLI
function kimi() {
    ANTHROPIC_BASE_URL=https://api.moonshot.ai/anthropic \
    ANTHROPIC_AUTH_TOKEN="$KIMI_AUTH_TOKEN" \
    ANTHROPIC_MODEL=kimi-k2-0905-preview \
    ANTHROPIC_SMALL_FAST_MODEL=kimi-k2-0905-preview \
    claude "$@"
}

# Use xAI GLM 4.6 model with Claude CLI
function glm() {
    ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic \
    ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.5-air \
    ANTHROPIC_DEFAULT_SONNET_MODEL=glm-4.6 \
    ANTHROPIC_DEFAULT_OPUS_MODEL=glm-4.6 \
    claude "$@"
}

# Convenience alias for inspecting active Slurm jobs with CPU counts and comments
alias sq='squeue -u $USER -O jobid:12,partition:12,name:5,numcpus:5,state:10,timeused:12,comment:60'

