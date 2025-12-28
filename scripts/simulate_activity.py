import random
import subprocess
import os
from datetime import datetime

import argparse

# Configuration
LOG_FILE = "activity_log.txt"
DRY_RUN = False
TOPICS = [
    "Refactor documentation for clarity",
    "Improve validation script performance",
    "Update security guidelines",
    "Enhance contributor experience",
    "Fix minor formatting issues",
    "Add new utility for profile validation",
    "Optimize workflow triggers",
    "Update README with latest features",
    "Correct typo in SECURITY.md",
    "Refine profile template structure"
]

def run_command(cmd):
    print(f"Executing: {' '.join(cmd)}")
    if DRY_RUN:
        return ""
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
    return result.stdout.strip()

def create_issue():
    topic = random.choice(TOPICS)
    body = f"This issue was automatically generated to track {topic.lower()}."
    run_command(["gh", "issue", "create", "--title", f"Task: {topic}", "--body", body, "--label", "automation"])

def create_pr():
    # 1. Create a new branch
    branch_name = f"activity-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    run_command(["git", "checkout", "-b", branch_name])
    
    # 2. Make a small change
    with open(LOG_FILE, "a") as f:
        f.write(f"Activity at {datetime.now().isoformat()}\n")
    
    run_command(["git", "add", LOG_FILE])
    run_command(["git", "commit", "-m", f"chore(activity): log activity {branch_name}"])
    run_command(["git", "push", "origin", branch_name])
    
    # 3. Create PR
    topic = random.choice(TOPICS)
    pr_url = run_command(["gh", "pr", "create", "--title", f"feat(activity): {topic}", "--body", "Automated activity generation.", "--base", "main", "--head", branch_name])
    
    # 4. Cleanup local branch
    run_command(["git", "checkout", "main"])
    return pr_url

def revert_random_pr():
    # List recent PRs that are merged or closed
    prs = run_command(["gh", "pr", "list", "--state", "all", "--limit", "10", "--json", "number,title"])
    import json
    try:
        pr_list = json.loads(prs)
        if not pr_list:
            return
        
        # Pick a random PR (simplification: just picking one and attempting to revert if it's merged)
        target = random.choice(pr_list)
        print(f"Attempting to revert PR #{target['number']}")
        # Revert is complex via CLI if not merged recently, but we can simulate a 'revert' issue/PR
        run_command(["gh", "issue", "create", "--title", f"Revert: PR #{target['number']}", "--body", f"Automated revert request for #{target['number']} ({target['title']})", "--label", "revert"])
    except Exception as e:
        print(f"Revert simulation failed: {e}")

def main():
    global DRY_RUN
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    DRY_RUN = args.dry_run

    if DRY_RUN:
        print("Dry run enabled - no changes will be made.")

    # Target 30-40 activities per day. 
    # If this runs hourly (24 times/day), we need ~1.5 activities per run.
    # We'll do 1-2 activities per run.
    
    num_activities = random.randint(1, 2)
    print(f"Starting {num_activities} activities...")
    
    for _ in range(num_activities):
        activity_type = random.choice(["issue", "pr", "revert"])
        if activity_type == "issue":
            create_issue()
        elif activity_type == "pr":
            create_pr()
        else:
            revert_random_pr()

if __name__ == "__main__":
    main()
