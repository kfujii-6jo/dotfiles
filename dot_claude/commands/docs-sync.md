---
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
argument-hint: [--check | --update | --auto]
description: ステージされた変更を分析し、関連ドキュメントの更新漏れを検出・修正する
---

# ドキュメント同期チェック

ステージされた変更に基づいてドキュメントの更新漏れを検出: $ARGUMENTS

## ステージされた変更の分析

- ステージされたファイル: !git diff --cached --name-only
- 変更の詳細: !git diff --cached --stat
- 変更されたコード: !git diff --cached --name-only -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.go' '*.rs'

## タスク

ステージされたコード変更を分析し、対応するドキュメントが適切に更新されているか確認する。更新漏れがあれば検出して修正案を提示する。

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

1. **変更分析**: ステージされたファイルの差分を解析
2. **影響範囲特定**: コード変更が影響するドキュメントを特定
3. **同期チェック**: 対応ドキュメントがステージに含まれているか確認
4. **漏れ検出**: 更新されていないドキュメントをリストアップ
5. **修正提案**: 具体的な更新内容を提案（--updateで自動修正）

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

- `--check`: 変更漏れの検出のみ（デフォルト）
- `--update`: 検出した漏れを自動修正
- `--auto`: 修正後に自動でステージに追加
