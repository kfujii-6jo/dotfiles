import json
from pathlib import Path
import subprocess
import tempfile


repo = Path(__file__).resolve().parents[1]
defaults = json.loads((repo / ".chezmoitemplates/claude-settings.json").read_text())

with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    home = root / "home"
    settings = home / ".claude/settings.json"
    settings.parent.mkdir(parents=True)
    config = root / "config.json"
    config.write_text("{}")
    command = [
        "chezmoi", "--config", str(config), "--source", str(repo),
        "--destination", str(home), "--cache", str(root / "cache"),
        "--persistent-state", str(root / "state.boltdb"), "--no-tty",
    ]

    def render():
        result = subprocess.run(
            [*command, "cat", str(settings)], capture_output=True, text=True, check=True,
        )
        return json.loads(result.stdout)

    assert render() == defaults, "A new machine must receive the shared defaults"
    local_hook = {"hooks": [{"type": "command", "command": "company-hook"}]}
    local = {
        "env": {"COMPANY_TOKEN": "test-only", "MAX_THINKING_TOKENS": "1"},
        "model": "local-model",
        "includeCoAuthoredBy": True,
        "permissions": {
            "allow": [defaults["permissions"]["allow"][0], "Bash(company-tool:*)"],
            "deny": ["Bash(company-prohibited:*)"],
            "ask": ["Bash(company-sensitive:*)"],
            "additionalDirectories": ["~/company"],
        },
        "hooks": {
            "SessionStart": [*defaults["hooks"]["SessionStart"], local_hook],
            "PreToolUse": [local_hook],
        },
        "enabledPlugins": {"company@company": False, "ponytail@ponytail": False},
        "extraKnownMarketplaces": {"company": {"source": {"source": "directory", "path": "/company"}}},
        "companySetting": {"enabled": True},
    }
    settings.write_text(json.dumps(local))
    merged = render()
    assert merged["env"] == {**local["env"], **defaults["env"]}
    assert merged["model"] == defaults["model"]
    assert merged["includeCoAuthoredBy"] is False
    assert merged["permissions"]["allow"] == [*defaults["permissions"]["allow"], "Bash(company-tool:*)"]
    assert merged["permissions"]["deny"] == [*defaults["permissions"]["deny"], "Bash(company-prohibited:*)"]
    for key in ("ask", "additionalDirectories"):
        assert merged["permissions"][key] == local["permissions"][key]
    assert merged["hooks"]["SessionStart"] == [*defaults["hooks"]["SessionStart"], local_hook]
    assert merged["hooks"]["PreToolUse"] == [local_hook]
    assert merged["enabledPlugins"] == {**local["enabledPlugins"], **defaults["enabledPlugins"]}
    assert merged["extraKnownMarketplaces"]["company"] == local["extraKnownMarketplaces"]["company"]
    assert merged["companySetting"] == local["companySetting"]

    subprocess.run([*command, "apply", str(settings)], capture_output=True, text=True, check=True)
    assert json.loads(settings.read_text()) == merged
    assert render() == merged, "Repeated applies must not duplicate rules or hooks"

    settings.write_text("{invalid")
    result = subprocess.run([*command, "apply", str(settings)], capture_output=True, text=True)
    assert result.returncode != 0, "Invalid JSON must fail instead of replacing local settings"
    assert settings.read_text() == "{invalid"

print("Claude settings merge checks passed")
