---
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
argument-hint: [<commit-range>] [--check | --update | --auto]
description: コード変更を分析し、関連ドキュメントの更新漏れを検出・修正する
---

# ドキュメント同期チェック

コード変更に基づいてドキュメントの更新漏れを検出: $ARGUMENTS

## 対象範囲の指定

引数 `$ARGUMENTS` から対象範囲を判定する:

| 指定方法 | 説明 | 例 |
|----------|------|-----|
| (なし) または `--staged` | ステージされた変更 | `/docs-sync --check` |
| `<commit>` | 特定コミット1件の変更 | `/docs-sync abc1234` |
| `<base>..<head>` | コミット範囲 | `/docs-sync main..feature` |
| `HEAD~n..HEAD` | 直近n件のコミット | `/docs-sync HEAD~3..HEAD` |

### 引数の判定ロジック

1. `--staged` フラグがある、または対象指定がない → ステージされた変更
2. `..` を含む → コミット範囲として `git diff <range>` を使用
3. それ以外 → 単一コミットとして `git show <commit>` を使用

## 変更の分析

引数に基づいて適切なgitコマンドを実行:

### ステージされた変更の場合（デフォルト）
```bash
git diff --cached --name-only
git diff --cached --stat
git diff --cached
```

### コミット範囲が指定された場合
```bash
git diff <range> --name-only
git diff <range> --stat
git diff <range>
git log <range> --oneline  # コミットメッセージも確認
```

### 単一コミットが指定された場合
```bash
git show <commit> --name-only --format=""
git show <commit> --stat --format=""
git show <commit>
```

## タスク

指定された範囲のコード変更を分析し、対応するドキュメントが適切に更新されているか確認する。更新漏れがあれば検出して修正案を提示する。

**注意**: 古いコミットを対象とする場合、ドキュメントの更新は新規コミットとして追加される（既存コミットは変更しない）。

## 検出対象

### 1. API変更の検出
- 新規エンドポイント追加
- パラメータ変更
- レスポンス形式の変更
- 廃止・削除されたAPI

### 2. 関数・クラスの変更
- 公開関数のシグネチャ変更
- 新規公開クラス・関数の追加
- パラメータのデフォルト値変更
- 戻り値の型変更

### 3. 設定・環境変数の変更
- 新規環境変数の追加
- 設定ファイルの構造変更
- デフォルト値の変更

### 4. 依存関係の変更
- package.json / requirements.txt 等の変更
- 新規依存パッケージの追加
- バージョン更新

## ドキュメント対応マッピング

| 変更タイプ | 対応ドキュメント |
|---|---|
| API変更 | README.md, API.md, docs/api/ |
| 環境変数追加 | README.md, .env.example, docs/setup.md |
| 依存関係変更 | README.md, INSTALL.md |
| 新機能追加 | README.md, CHANGELOG.md, docs/ |
| 破壊的変更 | CHANGELOG.md, MIGRATION.md |

## 処理フロー

1. **対象判定**: 引数から対象範囲（ステージ/コミット/範囲）を判定
2. **変更分析**: 対象範囲のファイル差分を解析
3. **影響範囲特定**: コード変更が影響するドキュメントを特定
4. **同期チェック**: 対応ドキュメントが同じ範囲内で更新されているか確認
5. **漏れ検出**: 更新されていないドキュメントをリストアップ
6. **修正提案**: 具体的な更新内容を提案（--updateで自動修正）

## 出力形式

### チェックモード（--check）
```
📋 ドキュメント同期チェック結果

✅ 同期済み:
  - README.md（API変更を反映）

⚠️ 要更新:
  - docs/api.md - 新規エンドポイント /api/users の記載なし
  - .env.example - 新規環境変数 DATABASE_URL の記載なし

📝 推奨アクション:
  1. docs/api.md に POST /api/users の説明を追加
  2. .env.example に DATABASE_URL を追加
```

### 更新モード（--update）
検出した漏れを自動的に修正してステージに追加

## オプション

### 対象指定
- `--staged`: ステージされた変更を対象（デフォルト）
- `<commit>`: 特定コミット1件を対象（例: `HEAD`, `HEAD~1`, `abc1234`）
- `<range>`: コミット範囲を対象（例: `main..HEAD`, `HEAD~3..HEAD`）

### 動作モード
- `--check`: 変更漏れの検出のみ（デフォルト）
- `--update`: 検出した漏れを自動修正（ファイル編集のみ）
- `--auto`: `--update` + 修正したファイルを `git add` でステージに追加

## 使用例

```bash
# ステージされた変更をチェック
/docs-sync --check

# 最新コミット（HEAD）をチェック
/docs-sync HEAD

# 1つ前のコミットをチェック
/docs-sync HEAD~1

# 特定のコミットをチェックして自動修正
/docs-sync abc1234 --update

# mainブランチからの差分をチェック
/docs-sync main..HEAD --check

# 直近3コミットをチェックして修正・ステージ追加
/docs-sync HEAD~3..HEAD --auto
```
