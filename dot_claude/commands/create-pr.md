---
description: プルリクエスト作成
---

# プルリクエスト作成

現在のブランチからプルリクエストを作成します。

## 手順

1. `git status` で現在のブランチとリモート追跡状態を確認
2. `git log main..HEAD --oneline` でコミット一覧を取得
3. コミットメッセージを元にPRタイトルとサマリーを作成
4. `gh pr create` でPRを作成

## 出力形式

```
gh pr create --title "<タイトル>" --body "$(cat <<'EOF'
<変更内容の要約（箇条書き）>
EOF
)"
```

## ルール

- タイトル: コミットが1つの場合はそのメッセージをそのまま使用、複数の場合は要約
- Summary: 各コミットメッセージを箇条書きで列挙
- ベースブランチ: 特に指定がなければ `main` を使用

## オプション

引数でオプションを指定可能:
- `--draft`: ドラフトPRとして作成
- `--base <branch>`: ベースブランチを指定

## 例

```bash
gh pr create --title "feat(auth): OAuth2ログイン機能を追加" --body "$(cat <<'EOF'
- GoogleとGitHubプロバイダーを使用したOAuth2認証フローを実装
- ユーザーは新規アカウントを作成せずにサインインが可能
EOF
)"
```

$ARGUMENTS
