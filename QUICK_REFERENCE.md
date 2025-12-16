# Dev Work Insights - Quick Reference

## 📁 File Structure
```
dev-work-insights/
├── README.md                    # Main documentation
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # MIT License
├── generate.bat                 # Windows launcher
├── generate.sh                  # Linux/macOS launcher
├── contributors/                # Developer profiles
│   └── jane-doe.md             # Sample profile
├── scripts/                     # Cross-platform tools
│   ├── generate_profile.ps1    # Windows generator
│   ├── generate_profile.sh     # Linux/macOS generator
│   ├── validate_profiles.ps1   # Windows validator
│   ├── validate_profiles.sh    # Linux/macOS validator
│   └── TEMPLATE.md             # Profile template
└── .github/
    └── workflows/
        ├── validate.yml        # CI/CD validation
        └── scripts/            # Python (CI/CD only)
```

## 🚀 Quick Commands

### Create New Profile

**Windows:**
```cmd
.\generate.bat
```

**Linux/macOS:**
```bash
./generate.sh
```

### Validate All Profiles

**Windows:**
```powershell
.\scripts\validate_profiles.ps1
```

**Linux/macOS:**
```bash
./scripts/validate_profiles.sh
```

## ✅ Checklist for Contributors

- [ ] Run profile generator:
  - Windows: `.\generate.bat`
  - Linux/macOS: `./generate.sh`
- [ ] Fill in all required fields
- [ ] Remove all placeholder text `[...]`
- [ ] Add at least 1-2 real projects
- [ ] Include at least one link (GitHub/Portfolio/LinkedIn)
- [ ] Run validation:
  - Windows: `.\scripts\validate_profiles.ps1`
  - Linux/macOS: `./scripts/validate_profiles.sh`
- [ ] Fix any errors or warnings
- [ ] Submit pull request

## 🎯 Required Fields

1. Name
2. Role / Position
3. Primary Tech Stack
4. Work Style / Preferences
5. Learning / Growth
6. Recent / Notable Projects
7. Career Aspirations
8. Links

## 🚫 What NOT to Include

- Personal email addresses
- Phone numbers
- Home addresses
- Salary information
- API keys or credentials
- Confidential company info

## 📝 File Naming

Format: `firstname-lastname.md`
- All lowercase
- Hyphens for spaces
- No special characters

Examples:
- ✅ `jane-doe.md`
- ✅ `john-smith.md`
- ❌ `Jane_Doe.md`
- ❌ `john.smith.md`

## 💡 No Installation Required!

All scripts work natively on your operating system:
- **Windows**: PowerShell (built-in)
- **Linux/macOS**: Bash (built-in)
- **No Python, Node.js, or other runtimes needed**

## 🔧 Advanced Usage

### Direct Script Execution

**Windows:**
```powershell
# Generate profile
.\scripts\generate_profile.ps1

# Validate profiles
.\scripts\validate_profiles.ps1
```

**Linux/macOS:**
```bash
# Make executable (first time only)
chmod +x scripts/*.sh

# Generate profile
./scripts/generate_profile.sh

# Validate profiles
./scripts/validate_profiles.sh
```

## 📚 Additional Resources

- [CONTRIBUTING.md](CONTRIBUTING.md) - Full contribution guidelines
- [ENHANCEMENTS.md](ENHANCEMENTS.md) - Future feature ideas
- [README.md](README.md) - Complete documentation
