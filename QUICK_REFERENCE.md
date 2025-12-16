# Dev Work Insights - Quick Reference

## 📁 File Structure
```
dev-work-insights/
├── README.md                    # Main documentation
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # MIT License
├── .gitignore                   # Git ignore rules
├── contributors/                # Developer profiles
│   └── jane-doe.md             # Sample profile
├── scripts/                     # Automation tools
│   ├── generate_template.py    # Create new profile
│   ├── validate_contributors.py # Validate profiles
│   ├── requirements.txt        # Python dependencies
│   └── TEMPLATE.md             # Profile template
└── .github/
    └── workflows/
        └── validate.yml        # CI/CD validation
```

## 🚀 Quick Commands

### Create New Profile
```bash
cd scripts
python generate_template.py
```

### Validate All Profiles
```bash
python scripts/validate_contributors.py
```

### Test Scripts Locally
```bash
# Test generation
cd scripts
python generate_template.py
# Enter: Test User

# Test validation
python validate_contributors.py
```

## ✅ Checklist for Contributors

- [ ] Run `python scripts/generate_template.py`
- [ ] Fill in all required fields
- [ ] Remove all placeholder text `[...]`
- [ ] Add at least 1-2 real projects
- [ ] Include at least one link (GitHub/Portfolio/LinkedIn)
- [ ] Run `python scripts/validate_contributors.py`
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
