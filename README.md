# homebrew-fendix

Official Homebrew tap and compatibility installer host for [Fendix](https://fendix.dev), the application security decision platform.

- Engine source: <https://github.com/Fendix-app/Fendix>
- Homebrew tap: <https://github.com/Fendix-app/homebrew-fendix>
- Documentation: <https://www.fendix.dev/docs/getting-started>
- Container image: [`fendixapp/fendix`](https://hub.docker.com/r/fendixapp/fendix)

## Homebrew

```bash
brew tap Fendix-app/fendix
brew install fendix
fendix version
```

Homebrew maps the tap name `Fendix-app/fendix` to this repository because it omits the `homebrew-` repository prefix. The formula supports Apple Silicon and Intel macOS, plus ARM64 and AMD64 Linux.

Existing installations made from the pre-transfer tap keep the same formula and installed binary name. GitHub redirects the transferred repository, but users should retap the official namespace during their next maintenance window:

```bash
brew untap Abdel-RahmanSaied/fendix
brew tap Fendix-app/fendix
brew upgrade fendix
```

The old namespace above is shown only as the source tap to remove during migration.

## Installer

The stable installer URL remains:

```bash
curl -fsSL https://get.fendix.dev/install.sh | sh
```

Inspect it before execution if required:

```bash
curl -fsSL https://get.fendix.dev/install.sh | less
```

The installer downloads release assets directly from the official engine repository, detects supported OS and architecture combinations, and refuses installation unless the downloaded binary matches its published SHA-256 checksum. Set `FENDIX_DIR=$HOME/.local/bin` for a user-writable destination or `FENDIX_VERSION=v3.4.1` to pin a version.

Supported installer targets:

| Operating system | Architectures |
| --- | --- |
| macOS | Apple Silicon (`arm64`), Intel (`amd64`) |
| Linux | ARM64 (`arm64`/`aarch64`), AMD64 (`amd64`/`x86_64`) |

## Docker

Use an immutable version for reproducible environments:

```bash
docker pull fendixapp/fendix:3.4.1
docker run --rm fendixapp/fendix:3.4.1 version
```

## Manual installation

Download the binary and matching `.sha256` sidecar for your platform from the [official engine release](https://github.com/Fendix-app/Fendix/releases/tag/v3.4.1). For example:

```bash
VERSION=v3.4.1
ASSET=fendix-${VERSION}-darwin-arm64
BASE=https://github.com/Fendix-app/Fendix/releases/download/${VERSION}

curl -fsSLO "$BASE/$ASSET"
curl -fsSLO "$BASE/$ASSET.sha256"
shasum -a 256 "$ASSET"
cat "$ASSET.sha256"
chmod +x "$ASSET"
```

Release binaries also include cosign certificate and signature sidecars. The v3.4.1 certificates retain their immutable pre-transfer GitHub Actions identity; current and future releases use the `Fendix-app/Fendix` workflow identity. See the [release verification documentation](https://www.fendix.dev/releases#verify-image) for current commands.

## Repository role

GitHub Pages serves `https://get.fendix.dev/` from the root of `main` in this repository. The root page is a scoped client-side compatibility redirect to the canonical Getting Started guide, while `/install.sh` remains a directly served shell script. GitHub Pages returns HTTP 200 for the landing page; it does not provide a route-specific HTTP 301 or 308.

Release automation in [`Fendix-app/Fendix`](https://github.com/Fendix-app/Fendix) regenerates the formula and synchronizes the installer and Pages bootstrap after stable releases.

## License

MIT — see [LICENSE](LICENSE).
