Description: Remove AI code slop
argument-hint:
────

Check the diff against main, and remove all AI generated slop introduced in this branch.

The diff against main is one of, in this order:
- git diff --cached
- git diff
- git diff main..HEAD or git diff master..HEAD

AI generated slop includes:
- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Variables or functions that are only used a single time right after declaration, prefer inlining the rhs/function.
- Redundant checks/casts inside a function that the caller also already takes care of.
- Any other style that is inconsistent with the file, including using types when the file doesn't.
- Consistency of the changes with AGENTS.md requirements.

Report at the end with only a 1-3 sentence summary of what you changed
