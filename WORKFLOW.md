# Simple Contribution Workflow

## 🚀 Quick Start (4 Simple Steps)

### Step 1: Generate Your Profile
**Windows:**
```cmd
.\generate.bat
```

**Linux/macOS:**
```bash
./generate.sh
```

Enter your name when prompted. Done!

### Step 2: Edit Your Profile
Open `contributors/yourname.md` and fill in:
- Your role and tech stack
- Work preferences
- Projects you've built
- Career goals
- Links (GitHub, portfolio, etc.)

### Step 3: Validate
**Windows:**
```powershell
.\scripts\validate_profiles.ps1
```

**Linux/macOS:**
```bash
./scripts/validate_profiles.sh
```

Fix any errors shown.

### Step 4: Submit
```bash
git add contributors/yourname.md
git commit -m "Add [Your Name] profile"
git push origin your-branch
```

Then create a Pull Request on GitHub. That's it!

---

## 📋 What to Include

**Required:**
- Name & Role
- Tech Stack
- Work Style
- Learning Habits
- 1-2 Real Projects
- Career Goals
- At least 1 Link

**Don't Include:**
- Phone numbers
- Personal email
- Home address
- Salary info

---

## 🎯 File Naming

Format: `firstname-lastname.md`
- All lowercase
- Hyphens for spaces
- Example: `jane-doe.md`

---

## ✅ That's It!

No Python, no Node.js, no installation needed. Just run, edit, validate, and submit!
