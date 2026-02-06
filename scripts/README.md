# Installation Scripts

## install.ps1 (Windows PowerShell)

```powershell
# With project name
.\install.ps1 my-project

# Current directory (if empty)
.\install.ps1

# Download and run
Invoke-WebRequest -Uri https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 -OutFile install.ps1
.\install.ps1
```

## install.sh (Linux/macOS)

```bash
# Make executable
chmod +x install.sh

# With project name
./install.sh my-project

# Current directory (if empty)
./install.sh

# Download and run
curl -O https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh
chmod +x install.sh
./install.sh
```

## What the Scripts Do

1. **Check Claude Code** - Required for this project
2. **Check/Install Prerequisites** - Node.js, Git
3. **Handle Project Folder** - Create or use existing
4. **Install BMAD Method** - Latest version via npx
5. **Install TeamBuilder** - Clone module from this repo
6. **Configure MCPs** - Memory + Playwright
7. **Create .gitignore** - Standard ignores

## Package Managers

| OS | Manager |
|----|---------|
| Windows | winget (built-in) |
| macOS | brew |
| Debian/Ubuntu | apt |
| Fedora/RHEL | dnf |
| Arch | pacman |
