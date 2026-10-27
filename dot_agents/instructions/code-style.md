## Code style

- **Code explains How**: express domain concepts and constraints through meaningful
  variable and function names and types; express the mechanics in code.
  Do not use comments to compensate for vague names or leave constraints only in
  comments when they can be expressed clearly in types.
- **Tests explain What**: specify expected observable behavior and requirements,
  rather than mirroring implementation steps. Do not copy implementation logic
  into expected results or depend on internal call order unrelated to the behavior.
- **Commit messages explain Why**: record the motivation, context, and purpose of
  a change that cannot be recovered from the diff. Do not merely list changed
  files or operations.
- **Comments explain Why not**: explain non-obvious constraints and tradeoffs that
  rule out otherwise reasonable alternatives. Do not narrate obvious steps or
  repeat what the code already expresses; remove such comments before review.
