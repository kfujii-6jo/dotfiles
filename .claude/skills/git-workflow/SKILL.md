# Gitワークフロースキル

このスキルは、Gitワークフロー、ブランチ戦略、プルリクエストのベストプラクティスに関する専門知識を提供します。

## ブランチ命名規則

```
<type>/<ticket-id>-<short-description>
```

### タイプ
- `feature/` - 新機能
- `fix/` - バグ修正
- `hotfix/` - 緊急の本番修正
- `refactor/` - コードリファクタリング
- `docs/` - ドキュメント更新
- `test/` - テストの追加・更新
- `chore/` - メンテナンスタスク

### 例
```
feature/PROJ-123-user-authentication
fix/PROJ-456-login-redirect-loop
hotfix/PROJ-789-payment-processing-error
```

## ブランチ戦略

### GitHub Flow（ほとんどのプロジェクトに推奨）
```
main
  └── feature/xxx
  └── fix/xxx
```
- シンプル、継続的デプロイに適合
- PRを通じてmainに直接マージ
- 未完成機能にはフィーチャーフラグを使用

### Git Flow（スケジュールリリース向け）
```
main
  └── develop
      └── feature/xxx
      └── release/x.x
  └── hotfix/xxx
```
- developとmainブランチを分離
- 安定化のためのリリースブランチ
- 本番問題用のhotfixブランチ

## コミットメッセージ規約

Conventional Commitsに従う:

```
<type>(<scope>): <subject>

[任意の本文]

[任意のフッター]
```

### タイプ
- `feat`: 新機能（MINORバージョンアップ）
- `fix`: バグ修正（PATCHバージョンアップ）
- `docs`: ドキュメントのみ
- `style`: コードスタイル（フォーマット、セミコロン）
- `refactor`: コードリファクタリング
- `perf`: パフォーマンス改善
- `test`: テストの追加
- `chore`: ビルド/ツール関連の変更
- `ci`: CI/CDの変更

### 破壊的変更
タイプの後に`!`を追加、またはフッターに`BREAKING CHANGE:`を記載:
```
feat!: 非推奨APIエンドポイントを削除

BREAKING CHANGE: /api/v1/usersエンドポイントを削除
```

## プルリクエストのベストプラクティス

### PRタイトル
```
[TYPE] 簡潔な説明 (#チケット番号)
```

### PR説明テンプレート
```markdown
## 概要
変更の簡潔な説明

## 変更内容
- 変更1
- 変更2

## 変更の種類
- [ ] バグ修正
- [ ] 新機能
- [ ] 破壊的変更
- [ ] ドキュメント更新

## テスト
- [ ] ユニットテストを追加/更新
- [ ] 統合テストがパス
- [ ] 手動テスト完了

## スクリーンショット（該当する場合）

## チェックリスト
- [ ] コードがスタイルガイドラインに従っている
- [ ] セルフレビュー済み
- [ ] 必要な箇所にコメントを追加
- [ ] ドキュメントを更新
- [ ] 新しい警告が発生していない
```

### PRサイズガイドライン
- **小**: < 200行（理想）
- **中**: 200-400行
- **大**: > 400行（分割を検討）

## マージ戦略

### Squash Merge（機能ブランチのデフォルト）
- すべてのコミットを1つに統合
- mainにクリーンな履歴
- 用途: featureブランチ、fixブランチ

### Merge Commit（リリース向け）
- ブランチ履歴を保持
- 用途: リリースブランチ、長期ブランチ

### Rebase（ブランチを最新に保つ）
- 線形履歴
- 用途: featureブランチをmainから更新

## よく使うGit操作

### featureブランチをmainから更新
```bash
git fetch origin
git rebase origin/main
# または
git merge origin/main
```

### インタラクティブrebaseでコミットを整理
```bash
git rebase -i HEAD~n  # n = コミット数
```

### 直前のコミットを取り消す（変更は保持）
```bash
git reset --soft HEAD~1
```

### コミットをcherry-pick
```bash
git cherry-pick <commit-hash>
```

### 変更をstash
```bash
git stash push -m "説明"
git stash pop
```

## コードレビューガイドライン

### 作成者として
- PRは焦点を絞り、小さく保つ
- 説明でコンテキストを提供
- フィードバックに迅速に対応
- フィードバックを個人的に受け取らない

### レビュアーとして
- 24時間以内にレビュー
- 建設的かつ具体的に
- 満足したら承認、細かいことを指摘しすぎない
- 小さな修正にはサジェスト機能を使用
