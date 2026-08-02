# グローバル指示

## HTTP リクエスト

`curl` ではなく `httpie`（`http` / `https`）を使う。

- 例: `http GET example.com/api` / `https POST example.com/api key=value`
- 例外: ツール導入前に走るブートストラップスクリプトは `curl` のままでよい

## コーディング規約

既存の実装パターンへの一貫性を最優先する。

1. **既存コードの確認を先に行う**: 実装前に同種の機能・コンポーネントを
   grep/検索し、その書き方を踏襲する。
2. **推測で新パターンを導入しない**: 迷ったら既存の類似実装に合わせる。
3. **依存関係**: package.json に既にあるものを使う。新規追加は提案のみで、
   勝手に install しない。パッケージマネージャ（pnpm / npm / yarn / bun）は
   lockfile に合わせる。
4. **リンタ/フォーマッタ**: プロジェクトの設定（oxlint, eslint,
   prettier, biome 等）に従う。手動整形で設定に逆らわない。
   コミット前に該当プロジェクトの lint/format コマンドを通す。
5. **テスト**: 既存テストの構成・命名・アサーションスタイル
   （vitest / jest 等）に合わせる。
6. **型**: any を安易に使わず、既存の型定義・tsconfig の strictness に従う。
7. **コメント**: 基本的に不要。残す必要があるものは `WHY` / `HACK` /
   `SAFETY` / `INVARIANT` を冒頭につける。記述量・言語（日本語/英語）は
   既存のコードに揃える。ドキュメントも同様。

```ts
// WHY: API が 2 種類の形式を返すため正規化が必要
// HACK: 上流の型定義が壊れているので暫定でキャスト
// SAFETY: 呼び出し前に必ず lock を取得している
// INVARIANT: items は常に updatedAt 降順でソート済み
```
