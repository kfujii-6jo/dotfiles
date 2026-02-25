---
name: code-review
description: >
  Perform comprehensive code reviews for web development projects (JavaScript, TypeScript, React, Node.js).
  **Use this skill proactively before the user commits code or creates PRs.** Also trigger when the user asks
  to review code, mentions "レビュー" or "review", asks for feedback on changes, wants to check for issues,
  or shows git diffs. Reviews focus on security vulnerabilities (XSS, SQL injection, secrets), code quality
  (readability, maintainability, complexity), and performance issues. Outputs structured findings with
  severity levels (critical/major/minor) and specific file/line references.
---

# Code Review for Web Development

This skill performs thorough code reviews focused on web development codebases, catching security vulnerabilities, code quality issues, and performance problems before they make it into the repository.

## When to Use This Skill

**Proactive usage (preferred):**
- Before the user runs `git commit` or creates a pull request
- When you notice the user has made significant code changes

**Reactive usage:**
- User explicitly asks for a code review
- User asks "any issues here?", "what do you think?", "can you review this?"
- User shows git diffs or staged changes
- User mentions reviewing code in Japanese (レビュー)

## Workflow

### 1. Analyze Changes

First, understand what code needs to be reviewed. Run these commands in parallel:

```bash
git status
git diff --staged
git diff
```

**What to look for:**
- Staged changes (will be committed)
- Unstaged changes (modified but not staged)
- Newly created files
- Modified vs deleted files

If there are no changes to review, inform the user: "No code changes detected. The working directory is clean."

### 2. Review Code for Issues

Analyze the code changes systematically across three dimensions:

#### A. Security Vulnerabilities (CRITICAL)

Look for common web security issues:

**Client-side (JavaScript/TypeScript/React):**
- **XSS (Cross-Site Scripting)**: Unsanitized user input rendered in JSX with `dangerouslySetInnerHTML`, direct DOM manipulation without escaping
- **Exposed secrets**: API keys, tokens, passwords in code or environment files committed
- **Insecure dependencies**: Known vulnerable npm packages (suggest running `npm audit`)
- **Client-side authentication**: Sensitive logic or secrets in frontend code
- **Unsafe eval**: Use of `eval()`, `Function()` constructor, or unsafe dynamic code execution

**Server-side (Node.js/Express):**
- **SQL Injection**: Unsanitized user input in SQL queries (not using parameterized queries)
- **Command Injection**: User input passed to `exec()`, `spawn()`, or system commands
- **Path Traversal**: Unvalidated file paths allowing directory traversal (`../`)
- **Insecure deserialization**: Unsafe use of `JSON.parse()` or `eval()` on user input
- **Missing authentication/authorization**: Protected routes without proper guards
- **CORS misconfiguration**: Overly permissive CORS settings (`Access-Control-Allow-Origin: *`)
- **Rate limiting**: Missing rate limiting on sensitive endpoints

**General:**
- **Hardcoded credentials**: Passwords, API keys, tokens, connection strings
- **Sensitive data logging**: PII, passwords, tokens logged to console or files
- **Insecure HTTP**: Using `http://` instead of `https://` for external APIs

#### B. Code Quality & Maintainability (MAJOR/MINOR)

Assess code readability and long-term maintainability:

**Complexity:**
- Functions longer than 50 lines or with deep nesting (>4 levels)
- Functions doing multiple unrelated things (violating Single Responsibility Principle)
- Complex conditional logic that could be simplified

**Readability:**
- Unclear variable/function names (e.g., `x`, `temp`, `data1`)
- Missing type annotations in TypeScript
- Insufficient comments for complex logic
- Magic numbers or strings without constants

**React-specific:**
- Missing key props in lists
- Unnecessary re-renders (missing `useMemo`, `useCallback` where needed)
- Prop drilling (passing props through multiple components)
- Side effects in render (should use `useEffect`)
- Missing error boundaries

**Code smells:**
- Duplicated code (copy-pasted logic)
- God classes/components (doing too much)
- Long parameter lists (>5 parameters)
- Commented-out code (should be removed)

**Best practices:**
- Missing error handling (try-catch, error states in React)
- Not following project conventions (check existing code style)
- Inconsistent naming conventions
- Missing input validation

#### C. Performance Issues (MAJOR/MINOR)

Identify code that could impact performance:

**Frontend:**
- Large bundle sizes (importing entire libraries instead of tree-shaking)
- Unoptimized images (missing lazy loading, wrong formats)
- Blocking operations in render
- Missing virtualization for long lists (>100 items)
- Excessive API calls (missing caching, making same call multiple times)
- Memory leaks (missing cleanup in `useEffect`)

**Backend:**
- N+1 queries (looping with database calls inside)
- Missing database indexes on queried fields
- Loading entire datasets when pagination should be used
- Synchronous operations blocking event loop
- Missing caching for expensive operations
- Inefficient algorithms (O(n²) when O(n) is possible)

**General:**
- Inefficient data structures (using arrays for lookups instead of Maps/Sets)
- Unnecessary computations in loops
- Missing memoization for expensive calculations

### 3. Categorize Findings by Severity

Assign severity levels to prioritize fixes:

**CRITICAL** (must fix before commit):
- Security vulnerabilities that could lead to data breach, unauthorized access, or code execution
- Exposed secrets or credentials
- Code that will definitely crash in production

**MAJOR** (should fix soon):
- Significant code quality issues affecting maintainability
- Performance issues that noticeably impact user experience
- Missing critical error handling
- Breaking changes without proper migration

**MINOR** (nice to have):
- Style inconsistencies
- Minor optimizations
- Small readability improvements
- Missing comments on complex logic

### 4. Format the Review Output

Present findings in a structured format:

```markdown
# Code Review Summary

## Overview
[1-2 sentence summary of changes and overall assessment]

**Statistics:**
- Files changed: X
- Critical issues: X
- Major issues: X
- Minor issues: X

---

## Critical Issues

### 🔴 [Issue Title]
**File:** `path/to/file.js:42`
**Severity:** CRITICAL

**Problem:**
[Clear description of what's wrong]

**Code:**
```javascript
// The problematic code
```

**Why this matters:**
[Explain the security/stability risk]

**Recommended fix:**
```javascript
// Suggested improved code
```

---

## Major Issues

### 🟠 [Issue Title]
**File:** `path/to/file.js:89`
**Severity:** MAJOR

[Follow same structure as Critical Issues]

---

## Minor Issues

### 🟡 [Issue Title]
**File:** `path/to/file.js:123`
**Severity:** MINOR

[Follow same structure]

---

## Positive Observations

[Mention good practices, improvements, or well-written code you noticed]

---

## Recommendations

1. [Prioritized action items based on severity]
2. [Additional suggestions for improvement]
3. [Testing recommendations]
```

### 5. Provide Context and Next Steps

After presenting the review:

1. **Summarize the verdict**:
   - "✅ Looks good to commit!" (only if no critical/major issues)
   - "⚠️  Fix critical issues before committing"
   - "📝 Consider addressing major issues soon"

2. **Offer to help**:
   - "Would you like me to fix the critical issues?"
   - "Should I create a TODO list for tracking these improvements?"
   - "Do you want me to commit after you've addressed the critical issues?"

3. **Educational value**:
   - Briefly explain why certain patterns are problematic
   - Link to relevant documentation when appropriate (e.g., OWASP for security)

## Edge Cases

### No Code Changes
If `git status` shows no changes, say: "No code changes detected. What would you like me to review?"

### Review Without Git
If the user asks to review a specific file without git context:
1. Read the file they mention
2. Review it standalone (can't compare with previous version)
3. Provide the same structured output

### Large Changesets
If the diff is very large (>1000 lines):
1. Warn the user: "This is a large changeset. Consider breaking it into smaller commits."
2. Focus on high-severity issues first
3. Suggest reviewing specific files: "Would you like me to focus on any particular files?"

### False Positives
If you're uncertain about an issue:
- Mark it clearly: "⚠️ Potential issue (verify):"
- Explain why it might be problematic and under what conditions
- Let the user decide if it needs fixing

### Non-Web Code
If the changes are not web-related (e.g., Python, Go, shell scripts):
- Still perform a basic review for common issues (security, quality)
- Acknowledge: "Note: This review is optimized for web development. Some language-specific issues may not be covered."

## Examples

### Example 1: Security Issue

**Input:** User stages a file with hardcoded API key

**Output:**
```markdown
# Code Review Summary

## Overview
Reviewed authentication changes. Found 1 critical security issue that must be fixed before committing.

**Statistics:**
- Files changed: 1
- Critical issues: 1
- Major issues: 0
- Minor issues: 0

---

## Critical Issues

### 🔴 Hardcoded API Key Exposed
**File:** `src/api/client.ts:12`
**Severity:** CRITICAL

**Problem:**
API key is hardcoded directly in the source code.

**Code:**
```typescript
const API_KEY = 'sk-1234567890abcdef';
```

**Why this matters:**
Hardcoded secrets in source code will be exposed in git history and can be discovered by anyone with repository access. This could lead to unauthorized API usage, data breaches, or service abuse.

**Recommended fix:**
```typescript
const API_KEY = process.env.VITE_API_KEY;

if (!API_KEY) {
  throw new Error('VITE_API_KEY environment variable is required');
}
```

Then add to `.env`:
```
VITE_API_KEY=sk-1234567890abcdef
```

And ensure `.env` is in `.gitignore`.
```

### Example 2: Performance Issue

**Input:** User stages React component with performance problem

**Output:**
```markdown
### 🟠 Unnecessary Re-renders in List
**File:** `src/components/UserList.tsx:34`
**Severity:** MAJOR

**Problem:**
Component re-renders all items on every state change due to inline function creation.

**Code:**
```tsx
{users.map(user => (
  <UserCard
    key={user.id}
    user={user}
    onClick={() => handleUserClick(user.id)}
  />
))}
```

**Why this matters:**
Creating a new function on every render causes all UserCard components to re-render, even if their props haven't changed. With large lists (>100 items), this creates noticeable lag.

**Recommended fix:**
```tsx
const handleUserClickMemo = useCallback((userId: string) => {
  handleUserClick(userId);
}, [handleUserClick]);

{users.map(user => (
  <UserCard
    key={user.id}
    user={user}
    onClick={handleUserClickMemo}
  />
))}
```

Or memoize the UserCard component:
```tsx
export const UserCard = React.memo(({ user, onClick }) => { ... });
```
```

### Example 3: Clean Code

**Input:** User stages well-written code

**Output:**
```markdown
# Code Review Summary

## Overview
Reviewed new authentication hook implementation. Code is well-structured and follows React best practices.

**Statistics:**
- Files changed: 1
- Critical issues: 0
- Major issues: 0
- Minor issues: 1

---

## Minor Issues

### 🟡 Consider Adding Error Type
**File:** `src/hooks/useAuth.ts:45`
**Severity:** MINOR

**Suggestion:**
Define a specific error type instead of generic Error for better type safety:

```typescript
type AuthError = {
  code: 'INVALID_CREDENTIALS' | 'NETWORK_ERROR' | 'EXPIRED_TOKEN';
  message: string;
}
```

---

## Positive Observations

✅ Excellent use of TypeScript for type safety
✅ Proper error handling with try-catch and error states
✅ Clean separation of concerns (auth logic in hook)
✅ Good use of useCallback to prevent unnecessary re-renders
✅ Clear variable naming and code structure

---

## Recommendations

✅ **Looks good to commit!**

The minor suggestion above is optional—the code is production-ready as is.
```

## Important Notes

- **Be thorough but not pedantic**: Focus on issues that matter. Don't flag every tiny style inconsistency.
- **Provide context**: Explain why something is a problem, not just that it is a problem.
- **Be constructive**: Frame feedback as learning opportunities, not criticisms.
- **Suggest concrete fixes**: Don't just point out problems—show how to fix them.
- **Prioritize**: Use severity levels honestly. Not everything is critical.
- **Consider the project context**: Check existing code patterns before suggesting changes.
- **Be language-aware**: If the codebase uses Japanese comments, feel free to include Japanese explanations.
- **False negatives are OK**: It's better to miss a minor issue than to flag false positives that waste time.
- **Read the actual code**: Don't make assumptions. Read the diff carefully before reviewing.

## Review Checklist

Before finalizing your review, ensure you've checked:

- [ ] Security: Secrets, XSS, injection, auth issues
- [ ] Performance: Obvious bottlenecks, inefficient algorithms
- [ ] Error handling: Missing try-catch, unhandled promises
- [ ] React patterns: Key props, unnecessary re-renders, hooks rules
- [ ] Code quality: Naming, complexity, duplication
- [ ] File references: All file paths and line numbers are accurate
- [ ] Severity levels: Applied consistently and appropriately
- [ ] Actionable feedback: Each issue has a clear suggested fix
