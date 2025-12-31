# ログ・オブザーバビリティスキル

このスキルは、ログ設計、メトリクス、トレーシング、アラート設計に関する参照用知識を提供します。

## ログレベル設計

### レベル定義

| レベル | 用途 | 例 |
|--------|------|-----|
| **FATAL** | システム停止が必要な致命的エラー | データベース接続不可、必須設定の欠落 |
| **ERROR** | 処理失敗、要対応 | API呼び出し失敗、トランザクションエラー |
| **WARN** | 潜在的問題、監視が必要 | 非推奨API使用、リトライ発生、閾値接近 |
| **INFO** | 正常な業務イベント | ユーザーログイン、注文完了、バッチ開始/終了 |
| **DEBUG** | 開発・調査用の詳細情報 | リクエスト/レスポンス詳細、内部状態 |
| **TRACE** | 最も詳細なデバッグ情報 | ループ内の値、メソッド引数 |

### レベル選択ガイドライン

```
質問: この状態で夜中に起こされたいか？
- はい、即座に → ERROR
- 翌営業日で良い → WARN
- 知る必要なし → INFO以下
```

### 環境別設定

| 環境 | 最小レベル | 出力先 |
|------|-----------|--------|
| 本番 | INFO | 集中ログシステム |
| ステージング | DEBUG | 集中ログシステム |
| 開発 | DEBUG | コンソール + ファイル |
| テスト | WARN | コンソール |

## 構造化ログ

### JSON形式（推奨）

```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "level": "INFO",
  "message": "Order completed",
  "service": "order-service",
  "version": "1.2.3",
  "traceId": "abc123",
  "spanId": "def456",
  "userId": "user-789",
  "orderId": "order-012",
  "amount": 9800,
  "currency": "JPY",
  "duration_ms": 245
}
```

### 必須フィールド

| フィールド | 説明 |
|-----------|------|
| timestamp | ISO 8601形式、UTC推奨 |
| level | ログレベル |
| message | 人間が読めるメッセージ |
| service | サービス名 |
| traceId | 分散トレースID |

### 推奨フィールド

| フィールド | 説明 |
|-----------|------|
| spanId | スパンID |
| userId | ユーザー識別子（匿名化） |
| requestId | リクエスト識別子 |
| duration_ms | 処理時間（ミリ秒） |
| host | ホスト名/Pod名 |
| version | アプリケーションバージョン |

### 禁止フィールド（機密情報）

```
絶対にログに含めないもの:
- パスワード、APIキー、トークン
- クレジットカード番号
- 個人識別情報（マスク必須）
- セッションID（フルは不可、末尾4文字程度）
```

## メトリクス設計

### 命名規則

```
<namespace>_<subsystem>_<name>_<unit>

例:
http_requests_total
http_request_duration_seconds
db_connections_active
cache_hits_total
queue_messages_pending
```

### メトリクスタイプ

| タイプ | 用途 | 例 |
|--------|------|-----|
| Counter | 累積値（増加のみ） | リクエスト数、エラー数 |
| Gauge | 現在値（増減可能） | 接続数、キューサイズ |
| Histogram | 分布（バケット） | レイテンシ、レスポンスサイズ |
| Summary | 分位数 | P50、P90、P99レイテンシ |

### 必須メトリクス（RED Method）

| メトリクス | 説明 |
|-----------|------|
| **R**ate | リクエスト数/秒 |
| **E**rrors | エラー率 |
| **D**uration | レイテンシ分布 |

### 必須メトリクス（USE Method）- リソース向け

| メトリクス | 説明 |
|-----------|------|
| **U**tilization | 使用率（%） |
| **S**aturation | 飽和度（キュー長） |
| **E**rrors | エラー数 |

### ラベル設計

```
良いラベル:
- method: GET, POST, PUT, DELETE
- status_code: 200, 400, 500
- endpoint: /api/users, /api/orders
- service: order-service

避けるべきラベル:
- userId（カーディナリティ高すぎ）
- requestId（カーディナリティ高すぎ）
- timestamp（メトリクスに含めない）
```

## 分散トレーシング

### コンテキスト伝播

```
HTTPヘッダー（W3C Trace Context）:
traceparent: 00-{trace-id}-{span-id}-{flags}
tracestate: vendor1=value1,vendor2=value2
```

### スパン設計

| スパン種別 | 用途 |
|-----------|------|
| SERVER | 受信リクエストの処理 |
| CLIENT | 外部サービス呼び出し |
| PRODUCER | メッセージ送信 |
| CONSUMER | メッセージ受信 |
| INTERNAL | 内部処理 |

### スパン属性

```
必須:
- service.name
- service.version
- http.method, http.url, http.status_code（HTTP）
- db.system, db.statement（DB）

推奨:
- error: true/false
- error.message
- user.id（匿名化）
```

## アラート設計

### アラートレベル

| レベル | 対応 | 例 |
|--------|------|-----|
| Critical | 即時対応（オンコール） | サービスダウン、データ損失リスク |
| Warning | 営業時間内対応 | エラー率上昇、リソース逼迫 |
| Info | 確認のみ | デプロイ完了、バッチ完了 |

### アラート設計原則

```
1. アクション可能なアラートのみ
   - 対応手順が明確
   - 誰かが対応する必要がある

2. 症状ベース（原因ベースではない）
   悪い: CPU使用率 > 80%
   良い: レイテンシP99 > 500ms

3. 閾値は実データから設定
   - ベースラインを測定
   - 標準偏差の2-3倍を閾値に

4. アラート疲れを防ぐ
   - フラッピング対策（継続時間条件）
   - 重複排除（グループ化）
```

### アラートルール例

```yaml
# レイテンシアラート
- alert: HighLatency
  expr: histogram_quantile(0.99, http_request_duration_seconds_bucket) > 0.5
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "High latency detected"
    description: "P99 latency is {{ $value }}s"

# エラー率アラート
- alert: HighErrorRate
  expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "High error rate detected"
    description: "Error rate is {{ $value | humanizePercentage }}"
```

## ダッシュボード設計

### レイアウト原則

```
1段目: サービス全体の健全性（ゴールデンシグナル）
2段目: 依存サービスの状態
3段目: リソース使用状況
4段目: ビジネスメトリクス
```

### 必須パネル

| パネル | 内容 |
|--------|------|
| リクエスト率 | RPS、トレンド |
| エラー率 | 5xx率、4xx率 |
| レイテンシ | P50、P90、P99 |
| 飽和度 | CPU、メモリ、接続数 |

## ツールスタック例

### ログ
- **収集**: Fluentd, Fluent Bit, Vector
- **保存**: Elasticsearch, Loki, CloudWatch Logs
- **可視化**: Kibana, Grafana

### メトリクス
- **収集**: Prometheus, OpenTelemetry Collector
- **保存**: Prometheus, InfluxDB, CloudWatch Metrics
- **可視化**: Grafana

### トレーシング
- **計装**: OpenTelemetry SDK
- **収集**: Jaeger, Zipkin, AWS X-Ray
- **可視化**: Jaeger UI, Grafana Tempo
