# BibTeX Journal Name Abbreviator

A fast C++ tool to automatically replace journal names with their standard ISO 4 abbreviations in BibTeX files.

## Installation

### One-line Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/xu-shi-jie/refabbr/master/install.sh | bash
```

Or with custom install directory:

```bash
curl -fsSL https://raw.githubusercontent.com/xu-shi-jie/refabbr/master/install.sh | INSTALL_DIR=~/.local/bin bash
```

### Manual Download

Download the latest release for your platform from the [Releases](https://github.com/xu-shi-jie/refabbr/releases) page:

| Platform | Download |
|----------|----------|
| Linux x64 | `refabbr-linux-x64.tar.gz` |
| macOS x64 | `refabbr-macos-x64.tar.gz` |
| Windows x64 | `refabbr-windows-x64.zip` |

### Build from Source

```bash
git clone https://github.com/xu-shi-jie/refabbr
cd refabbr
make all
sudo mv refabbr /usr/local/bin
```

## Usage

```bash
# Replace journal names in place
refabbr references.bib

# Write to a new file
refabbr input.bib output.bib

# Show help
refabbr --help
```

## Update (2025-12-10)
- Current version: 1.3.1
Update abbreviations

## Update (2025-10-1)
- Current version: 1.3
Remove deprecated Python implementation. Fix compilation error.

## Update (2025-7-31)
- Current version: 1.2
The code has been rewriten in C++ for more elegant usage and better performance (with the help of Claude Sonnet 4). The old Python version is still available and will be removed in the future.
