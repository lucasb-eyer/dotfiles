Description: Careful and thorough change review
argument-hint:
────

Check the diff against main, and review this change carefully.

The diff against main is one of, in this order:
- git diff --cached
- git diff
- git diff main..HEAD or git diff master..HEAD

Careful review means:
- First, try to understand what the change is about. What its underlying goal really is.
- Think about how the change achieves this goal, and what are the clear benefits and improvements of it.
- Then, think about the potential issues or pitfalls with this change. (Don't bother about backwards-compatibility though.)
- Is there something obvious that the change might be missing?
- What are potential improvements we could make to this change?
- Then, see whether we could make simplifications on the high-level design side of things.
- Finally, try to see if there's simplifications we can make on the implementation.
