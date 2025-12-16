# Contributing to Dev Work Insights

Thank you for your interest in contributing! This guide will help you create a high-quality profile that provides real value.

## 🎯 Who Can Contribute?

**Eligible Contributors:**
- Software Developers
- Software Engineers
- Data Scientists
- DevOps Engineers
- Machine Learning Engineers
- Technical Leads / Engineering Managers with hands-on coding experience

**Not Eligible:**
- Non-technical roles (recruiters, marketers, designers without coding experience)
- Students without professional or significant project experience
- Profiles without real projects or work history

## 📝 Contribution Process

### 1. Generate Your Profile

Use the automation script to create your profile:

```bash
cd scripts
python generate_template.py
```

This will:
- Prompt you for your name
- Create a properly named file (`firstname-lastname.md`)
- Generate a template with all required fields

### 2. Fill In Your Details

Edit your generated file in the `contributors/` directory. Follow the template structure and guidelines below.

### 3. Submit a Pull Request

1. Fork this repository
2. Create a new branch: `git checkout -b add-yourname`
3. Add your profile: `git add contributors/yourname.md`
4. Commit: `git commit -m "Add [Your Name] profile"`
5. Push: `git push origin add-yourname`
6. Open a Pull Request

### 4. Validation

Your PR will be automatically validated for:
- Required fields presence
- Proper Markdown formatting
- File naming conventions
- No sensitive information

## 📋 Profile Structure

### Required Fields

These fields **must** be included:

- **Name** - Your full name
- **Role / Position** - Current role or primary expertise
- **Primary Tech Stack** - Languages, frameworks, tools you use regularly
- **Work Style / Preferences** - How you prefer to work
- **Learning / Growth** - How you learn and grow
- **Recent / Notable Projects** - At least 1-2 real projects
- **Career Aspirations** - What you're looking for next
- **Links** - At least one link (GitHub, portfolio, LinkedIn, or blog)

### Optional Fields

- **Favorite Tools / Automation** - Scripts, tools, productivity hacks
- **Fun / Personality Insight** - Hobbies, interests, fun facts

## ✅ Quality Guidelines

### Be Specific, Not Generic

❌ **Bad**: "I'm a passionate full-stack developer"
✅ **Good**: "Full-stack developer specializing in React/Node.js, focusing on real-time collaboration tools"

❌ **Bad**: "I love learning new things"
✅ **Good**: "Currently learning Rust through 'The Rust Programming Language' and building a CLI tool for log analysis"

### Include Real Projects

❌ **Bad**: "Built various web applications"
✅ **Good**: 
```markdown
- **E-commerce Platform**: Built a headless e-commerce system using Next.js, Stripe, and PostgreSQL. 
  Reduced page load time by 60% through SSR and image optimization. Handles 10k+ daily users.
```

### Share Actionable Tools & Automation

❌ **Bad**: "I use productivity tools"
✅ **Good**:
```markdown
- Custom Python script to sync GitHub issues with Notion database
- Tmux + Neovim setup with LSP for Go and TypeScript
- Alfred workflows for quick documentation lookup
```

### Be Honest About Work Style

❌ **Bad**: "Flexible and adaptable"
✅ **Good**:
```markdown
- Remote-only, async-first communication
- Prefer 4-hour deep work blocks in the morning
- Small teams (5-10 people), direct communication with stakeholders
- VSCode with Vim keybindings, dual monitor setup
```

## 🔒 Privacy & Security

### DO NOT Include:

- Personal email addresses (use GitHub/LinkedIn for contact)
- Phone numbers
- Home addresses
- Salary information
- Confidential company information
- Private repository links
- API keys or credentials

### Safe to Include:

- Professional social media (GitHub, LinkedIn, Twitter)
- Public portfolio websites
- Public blog posts
- Open-source project links
- General location (city/country, not full address)

## 📐 Formatting Standards

### File Naming

- Format: `firstname-lastname.md`
- All lowercase
- Hyphens for spaces
- No special characters
- Examples: `jane-doe.md`, `john-smith.md`, `maria-garcia.md`

### Markdown Formatting

- Use `##` for main section headers
- Use `**Bold**` for field labels
- Use `-` for bullet points
- Use proper links: `[Text](URL)`
- Keep lines under 120 characters when possible

### Example Structure

```markdown
## Name: Jane Doe
**Role / Position:** Senior Full-Stack Developer  
**Primary Tech Stack:** React, Node.js, PostgreSQL, AWS, Docker  
**Work Style / Preferences:** Remote-only, async-first, Agile, VSCode  

**Learning / Growth:**  
- "Designing Data-Intensive Applications" by Martin Kleppmann
- Frontend Masters courses on performance optimization
- Following Kent C. Dodds blog and testing practices
- Using ChatGPT for code reviews and documentation

**Recent / Notable Projects:**  
- **Project Name**: Brief description, tech stack, impact/metrics
- **Another Project**: Brief description, tech stack, impact/metrics

**Career Aspirations:**  
Looking for senior or lead roles in early-stage startups (Series A-B) 
building developer tools or B2B SaaS. Interested in remote-first companies 
with strong engineering culture.

**Favorite Tools / Automation:**  
- Custom bash scripts for git workflow automation
- Raycast extensions for quick access to documentation
- Docker Compose templates for local development

**Fun / Personality Insight:**  
Coffee enthusiast, mechanical keyboard collector, weekend hiker

**Links:**  
- GitHub: https://github.com/janedoe
- Portfolio: https://janedoe.dev
- LinkedIn: https://linkedin.com/in/janedoe
- Blog: https://janedoe.dev/blog
```

## 🚫 What Will Be Rejected

Profiles will be rejected if they:

1. **Lack specificity** - Generic statements without real details
2. **Missing required fields** - Incomplete profiles
3. **No real projects** - Only tutorial projects or no projects at all
4. **Contain sensitive info** - Personal contact details, confidential data
5. **Poor formatting** - Not following Markdown standards
6. **Non-technical contributors** - Profiles from non-eligible roles
7. **Spam or promotional** - Profiles that are primarily advertisements

## 🔄 Updating Your Profile

You can update your profile anytime:

1. Edit your file in `contributors/`
2. Submit a new PR with your changes
3. Describe what you updated in the PR description

## ❓ Questions?

- Check the [README.md](README.md) for examples
- Look at existing profiles in `contributors/`
- Open an issue for clarification

## 🌟 Tips for a Great Profile

1. **Be authentic** - Share your real work style and preferences
2. **Be specific** - Include actual tools, scripts, and workflows
3. **Be current** - Update your profile as you grow
4. **Be helpful** - Share insights that others can learn from
5. **Be professional** - Keep it focused on technical work

---

Thank you for contributing to Dev Work Insights! Your profile helps build a valuable resource for the entire developer community.
