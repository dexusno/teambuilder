# Installation Scripts

## install.ps1 (Windows PowerShell)

```powershell
# Run from inside your project folder
mkdir my-project
cd my-project
.\install.ps1

# Or download and run
Invoke-WebRequest -Uri https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 -OutFile install.ps1
.\install.ps1
```

## install.sh (Linux/macOS)

```bash
# Run from inside your project folder
mkdir my-project
cd my-project
chmod +x install.sh
./install.sh

# Or download and run
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
6. **Register Agents** - TeamBuilder Guide + Memory Manager command stubs
7. **Sync User Config** - Copies your name, language, and output preferences from BMAD core config into TeamBuilder's config so agents know how to greet you
8. **Configure MCPs** - Memory + Playwright
9. **Create Docs Folder** - Team knowledge base directory
10. **Create .gitignore** - Standard ignores (includes team memory files)

## Package Managers

| OS | Manager |
|----|---------|
| Windows | winget (built-in) |
| macOS | brew |
| Debian/Ubuntu | apt |
| Fedora/RHEL | dnf |
| Arch | pacman |
