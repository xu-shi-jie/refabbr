#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO="xu-shi-jie/refabbr"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
BINARY_NAME="refabbr"

echo -e "${GREEN}Installing refabbr - BibTeX Journal Name Abbreviator${NC}"
echo ""

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
    linux*)
        PLATFORM="linux"
        EXT="tar.gz"
        ;;
    darwin*)
        PLATFORM="macos"
        EXT="tar.gz"
        ;;
    mingw*|msys*|cygwin*)
        PLATFORM="windows"
        EXT="zip"
        BINARY_NAME="refabbr.exe"
        ;;
    *)
        echo -e "${RED}Error: Unsupported operating system: $OS${NC}"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64|amd64)
        ARCH="x64"
        ;;
    arm64|aarch64)
        # Currently only x64 is supported, but keeping for future
        ARCH="x64"
        echo -e "${YELLOW}Warning: ARM architecture detected, falling back to x64 (may require Rosetta on macOS)${NC}"
        ;;
    *)
        echo -e "${RED}Error: Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

ASSET_NAME="refabbr-${PLATFORM}-${ARCH}.${EXT}"

echo -e "Detected platform: ${GREEN}${PLATFORM}-${ARCH}${NC}"
echo -e "Downloading: ${GREEN}${ASSET_NAME}${NC}"
echo ""

# Get latest release URL
LATEST_RELEASE=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" | grep "tag_name" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE" ]; then
    echo -e "${RED}Error: Could not fetch latest release information${NC}"
    exit 1
fi

echo -e "Latest version: ${GREEN}${LATEST_RELEASE}${NC}"

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/${ASSET_NAME}"

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

cd "$TMP_DIR"

# Download
echo -e "Downloading from ${DOWNLOAD_URL}..."
if ! curl -sL -o "$ASSET_NAME" "$DOWNLOAD_URL"; then
    echo -e "${RED}Error: Failed to download ${ASSET_NAME}${NC}"
    exit 1
fi

# Extract
echo "Extracting..."
if [ "$EXT" = "tar.gz" ]; then
    tar -xzf "$ASSET_NAME"
elif [ "$EXT" = "zip" ]; then
    unzip -q "$ASSET_NAME"
fi

# Install
echo -e "Installing to ${GREEN}${INSTALL_DIR}${NC}..."

if [ -w "$INSTALL_DIR" ]; then
    cp "$BINARY_NAME" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
else
    echo -e "${YELLOW}Need sudo permission to install to ${INSTALL_DIR}${NC}"
    sudo cp "$BINARY_NAME" "$INSTALL_DIR/"
    sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
fi

echo ""
echo -e "${GREEN}✓ Successfully installed refabbr ${LATEST_RELEASE}${NC}"
echo ""
echo "Usage:"
echo "  refabbr <input.bib>              # Replace journal names in place"
echo "  refabbr <input.bib> <output.bib> # Write to a new file"
echo ""
echo "Run 'refabbr --help' for more information."
