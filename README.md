# llms-from-scratch-practice

This repository is derived from and follows the reference project:
[LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch).

## Agent Skills

Maintain each shared skill in one canonical location under `.claude/skills/`:

```text
.claude/skills/<skill-name>/SKILL.md
```

Expose the same skill to Codex by symlinking the whole skill directory from
`.agents/skills/`:

```bash
mkdir -p .agents/skills
ln -s ../../.claude/skills/<skill-name> .agents/skills/<skill-name>
```

The symlink should point at the skill directory itself, so Codex sees:

```text
.agents/skills/<skill-name>/SKILL.md
```

Do not create a placeholder `SKILL.md` that only contains a path. `SKILL.md`
must contain valid skill frontmatter and instructions.
