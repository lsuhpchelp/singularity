#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_DIR="${VASP_IMAGE_DIR:-/project/containers/images}"

usage() {
    echo "Usage:"
    echo "  $0 VERSION cpu|gpu lsuhpc|lonihpc [standard|tpc]"
    echo
    echo "Examples:"
    echo "  $0 6.5.1 cpu lonihpc"
    echo "  $0 6.5.1 gpu lsuhpc"
    echo "  $0 6.6.1 cpu lonihpc tpc"
    echo "  $0 6.6.1 gpu lsuhpc tpc"
}

if (( $# < 3 || $# > 4 )); then
    usage
    exit 2
fi

version="$1"
target="$2"
site="$3"
variant="${4:-standard}"

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: Invalid VASP version: $version" >&2
    exit 2
fi

case "$target" in
    cpu)
        toolchain="impi"
        ;;
    gpu)
        toolchain="nvhpc"
        ;;
    *)
        echo "ERROR: Target must be cpu or gpu." >&2
        exit 2
        ;;
esac

case "$site" in
    lonihpc|lsuhpc)
        ;;
    *)
        echo "ERROR: Site must be lonihpc or lsuhpc." >&2
        exit 2
        ;;
esac

case "$variant" in
    standard)
        variant_suffix=""
        ;;
    tpc)
        variant_suffix="-tpc"
        ;;
    *)
        echo "ERROR: Variant must be standard or tpc." >&2
        exit 2
        ;;
esac

stem="vasp-${version}_lic-${target}.${toolchain}${variant_suffix}"
recipe="${ROOT}/${stem}.def"
output="${IMAGE_DIR}/${stem}-${site}.sif"

if [[ ! -f "$recipe" ]]; then
    echo "ERROR: Recipe not found:" >&2
    echo "  $recipe" >&2
    exit 1
fi

if [[ ! -d "$IMAGE_DIR" ]]; then
    echo "ERROR: Image directory not found:" >&2
    echo "  $IMAGE_DIR" >&2
    exit 1
fi

cmd=(
    singularity build
    --build-arg "CLUSTER_SUFFIX=${site}"
    "$output"
    "$recipe"
)

# default is sudo, if rootless build is needed:
# VASP_USE_SUDO=0 ./build_vasp.sh ...
if [[ "${VASP_USE_SUDO:-1}" == "1" && "$EUID" -ne 0 ]]; then
    cmd=(sudo "${cmd[@]}")
fi

echo "Recipe : $recipe"
echo "Output : $output"
echo "Site   : $site"
printf "Command:"
printf " %q" "${cmd[@]}"
printf "\n"

# Dry run, does not create
# VASP_DRY_RUN=1 ./build_vasp.sh ...
if [[ "${VASP_DRY_RUN:-0}" == "1" ]]; then
    exit 0
fi

"${cmd[@]}"

