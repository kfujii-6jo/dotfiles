# エラーハンドリングスキル

このスキルは、例外設計、エラーコード体系、リトライ戦略、耐障害性パターンに関する参照用知識を提供します。

## エラー分類

### エラーの種類

| 種類 | 説明 | 対処 |
|------|------|------|
| **ビジネスエラー** | 業務ルール違反 | ユーザーに明確なメッセージ |
| **バリデーションエラー** | 入力値不正 | 具体的な修正方法を提示 |
| **技術エラー** | システム障害 | リトライ、フォールバック |
| **認証エラー** | 認証失敗 | 再ログイン誘導 |
| **認可エラー** | 権限不足 | 必要な権限を説明 |
| **外部エラー** | 外部サービス障害 | リトライ、サーキットブレーカー |

### 回復可能性

```
回復可能（Recoverable）:
- ネットワーク一時障害 → リトライ
- 一時的な負荷 → バックオフ
- 外部サービス障害 → フォールバック

回復不可能（Non-recoverable）:
- プログラミングエラー → 修正が必要
- 設定エラー → 設定修正が必要
- データ整合性エラー → 手動介入が必要
```

## エラーコード体系

### 構造

```
<カテゴリ>-<サブカテゴリ>-<連番>

例:
AUTH-001: 認証トークン無効
AUTH-002: トークン期限切れ
VAL-001: 必須フィールド欠落
VAL-002: 形式不正
BIZ-001: 残高不足
BIZ-002: 在庫切れ
SYS-001: データベース接続エラー
SYS-002: 外部API呼び出しエラー
```

### カテゴリ例

| コード | カテゴリ | 説明 |
|--------|---------|------|
| AUTH | 認証・認可 | 認証、権限関連 |
| VAL | バリデーション | 入力検証エラー |
| BIZ | ビジネス | 業務ルールエラー |
| SYS | システム | 技術的エラー |
| EXT | 外部連携 | 外部サービスエラー |

## APIエラーレスポンス

### RFC 7807 Problem Details

```json
{
  "type": "https://example.com/errors/insufficient-funds",
  "title": "Insufficient Funds",
  "status": 400,
  "detail": "Your account balance is 1000 JPY, but the transaction requires 5000 JPY.",
  "instance": "/accounts/12345/transactions/67890",
  "errorCode": "BIZ-001",
  "traceId": "abc-123-def"
}
```

### バリデーションエラー

```json
{
  "type": "https://example.com/errors/validation-error",
  "title": "Validation Error",
  "status": 400,
  "errors": [
    {
      "field": "email",
      "code": "VAL-002",
      "message": "Invalid email format"
    },
    {
      "field": "age",
      "code": "VAL-003",
      "message": "Must be 18 or older"
    }
  ],
  "traceId": "abc-123-def"
}
```

### HTTPステータスコード選択

| 状況 | ステータス |
|------|-----------|
| リクエスト形式エラー | 400 Bad Request |
| 認証必要 | 401 Unauthorized |
| 権限不足 | 403 Forbidden |
| リソース不存在 | 404 Not Found |
| メソッド不許可 | 405 Method Not Allowed |
| 競合（楽観ロック失敗等） | 409 Conflict |
| バリデーションエラー | 422 Unprocessable Entity |
| レート制限 | 429 Too Many Requests |
| サーバーエラー | 500 Internal Server Error |
| 外部サービスエラー | 502 Bad Gateway |
| サービス利用不可 | 503 Service Unavailable |

## 例外設計パターン

### 例外階層

```
ApplicationException (基底)
├── BusinessException (業務エラー)
│   ├── InsufficientFundsException
│   ├── OutOfStockException
│   └── DuplicateOrderException
├── ValidationException (検証エラー)
│   ├── RequiredFieldException
│   └── InvalidFormatException
├── AuthenticationException (認証エラー)
│   ├── InvalidCredentialsException
│   └── TokenExpiredException
├── AuthorizationException (認可エラー)
│   └── AccessDeniedException
└── TechnicalException (技術エラー)
    ├── DatabaseException
    ├── ExternalServiceException
    └── ConfigurationException
```

### 例外設計原則

```
1. チェック例外 vs 非チェック例外
   - 回復可能 → チェック例外（Java）または明示的なResult型
   - 回復不可能 → 非チェック例外

2. 例外の粒度
   悪い: throw new Exception("Something went wrong")
   良い: throw new InsufficientFundsException(accountId, balance, required)

3. コンテキスト情報を含める
   - 何が起きたか
   - どのリソースで
   - どのような値で

4. 例外の変換
   - 下位レイヤーの例外を上位で適切に変換
   - 実装詳細を漏らさない
```

## リトライ戦略

### リトライ可否判断

| エラー | リトライ |
|--------|---------|
| 500 Internal Server Error | ○ |
| 502 Bad Gateway | ○ |
| 503 Service Unavailable | ○ |
| 504 Gateway Timeout | ○ |
| 429 Too Many Requests | ○（Retry-After参照） |
| 408 Request Timeout | ○ |
| 400 Bad Request | × |
| 401 Unauthorized | × |
| 403 Forbidden | × |
| 404 Not Found | × |
| 409 Conflict | △（状況依存） |

### 指数バックオフ

```
待機時間 = min(base * 2^attempt + jitter, max_delay)

例:
- base: 100ms
- max_delay: 30s
- jitter: 0-100msのランダム値

1回目: 100ms + jitter
2回目: 200ms + jitter
3回目: 400ms + jitter
4回目: 800ms + jitter
...
最大: 30s + jitter
```

### リトライ設定例

```yaml
retry:
  max_attempts: 5
  base_delay_ms: 100
  max_delay_ms: 30000
  multiplier: 2
  jitter: true
  retryable_status_codes:
    - 500
    - 502
    - 503
    - 504
    - 429
```

## サーキットブレーカー

### 状態遷移

```
         成功                失敗閾値到達
CLOSED ←──────── HALF_OPEN ←──────── OPEN
   │                 │                 │
   └─────────────────┴──── タイムアウト ─┘
         失敗
```

### 状態説明

| 状態 | 説明 | 動作 |
|------|------|------|
| CLOSED | 正常 | リクエストを通す |
| OPEN | 障害検知 | リクエストを即座に失敗 |
| HALF_OPEN | 回復確認中 | 一部リクエストを通す |

### 設定パラメータ

```yaml
circuit_breaker:
  failure_threshold: 5        # OPEN移行の失敗回数
  failure_rate_threshold: 50  # OPEN移行の失敗率(%)
  slow_call_threshold: 60     # スローコール率がこの閾値(%)を超えたらOPEN移行
  slow_call_duration_ms: 2000 # この時間(ms)を超えた呼び出しをスローコールとみなす
  wait_duration_ms: 30000     # OPEN維持時間
  permitted_calls_in_half_open: 3  # HALF_OPENで許可する数
```

## フォールバックパターン

### パターン一覧

| パターン | 説明 | 用途 |
|---------|------|------|
| デフォルト値 | 固定値を返す | 設定、機能フラグ |
| キャッシュ | 前回の結果を返す | 読み取り系API |
| 代替サービス | 別サービスを呼ぶ | 冗長構成 |
| 機能縮退 | 一部機能を無効化 | 非必須機能 |
| キュー待避 | 後で処理 | 非同期処理可能な操作 |

### 実装例

```
// 優先順位付きフォールバック
try {
  return primaryService.getData()
} catch (ServiceException e) {
  log.warn("Primary failed, trying cache", e)

  cached = cache.get(key)
  if (cached != null) {
    return cached
  }

  log.warn("Cache miss, using default")
  return defaultValue
}
```

## タイムアウト設計

### レイヤー別タイムアウト

| レイヤー | 典型値 | 考慮点 |
|---------|--------|--------|
| クライアント全体 | 30s | ユーザー体験 |
| HTTP接続 | 5s | ネットワーク問題検知 |
| HTTP読み取り | 10s | レスポンス待ち |
| データベースクエリ | 5s | スロークエリ検知 |
| 外部API | 10s | SLA依存 |

### タイムアウト原則

```
1. 常にタイムアウトを設定
   - デフォルト無限は危険
   - 明示的に設定

2. 適切な粒度
   - 接続タイムアウト < 読み取りタイムアウト < 全体タイムアウト

3. 伝播を考慮
   - 上流のタイムアウト > 下流のタイムアウトの合計
   - マージンを持たせる
```

## エラーログ設計

### ログに含めるべき情報

```json
{
  "level": "ERROR",
  "message": "Failed to process payment",
  "errorCode": "EXT-001",
  "errorType": "ExternalServiceException",
  "traceId": "abc-123",
  "userId": "user-***456",
  "orderId": "order-789",
  "externalService": "payment-gateway",
  "httpStatus": 503,
  "retryCount": 3,
  "duration_ms": 5234,
  "stackTrace": "..."
}
```

### ログレベル選択

| 状況 | レベル |
|------|--------|
| 回復不可能エラー | ERROR |
| リトライ中（最終失敗前） | WARN |
| リトライ成功 | INFO |
| ビジネスエラー（正常系） | INFO |
| 外部要因（ユーザー入力エラー等） | WARN |
