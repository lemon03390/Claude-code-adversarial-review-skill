# Adversarial Review — Claude Code Skill

**[繁體中文版](#繁體中文) | English**

An adversarial code and architecture review skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), evolved through three iterations of self-review. Forces genuine critical analysis through structured debate, confidence-scored findings, and multi-perspective attack — designed to break through LLM sycophancy.

## Why This Exists

LLMs default to agreeable, surface-level code reviews. This skill forces Claude to:

- **Debate itself** — simulating Author vs Senior Reviewer with mandatory disagreement
- **Score confidence** — every finding rated 1-10, low-confidence noise suppressed
- **Dispatch specialists** — parallel security/performance/testing/error-handling subagents
- **Auto-fix** what's unambiguous, flag what needs human decision
- **Quantify quality** — PR Quality Score (0-100) with letter grade

## Feature Comparison

| Feature | Plain "review my code" | This Skill |
|---------|----------------------|------------|
| Structured analysis | No | 6-step pipeline |
| Anti-sycophancy | No | Forced disagreement + mandatory pushback |
| Confidence filtering | No | 1-10 score, <7 suppressed |
| Parallel specialists | No | 4 domain experts in parallel |
| Auto-fix | No | Mechanical fixes applied automatically |
| PR Quality Score | No | Quantified 0-100 with grade |
| Architecture review | No | 6-perspective attack + steelman/counter |
| Framework extensions | No | Plug-in detection patterns per stack |

## Installation

### Quick Install (recommended)

```bash
# Clone to Claude Code global skills directory
mkdir -p ~/.claude/skills/adversarial-review
curl -o ~/.claude/skills/adversarial-review/SKILL.md \
  https://raw.githubusercontent.com/lemon03390/Claude-code-adversarial-review-skill/main/SKILL.md

# Optional: Add slash command
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/adversarial-review.md \
  https://raw.githubusercontent.com/lemon03390/Claude-code-adversarial-review-skill/main/commands/adversarial-review.md
```

### Manual Install

```bash
git clone https://github.com/lemon03390/Claude-code-adversarial-review-skill.git
cp Claude-code-adversarial-review-skill/SKILL.md ~/.claude/skills/adversarial-review/SKILL.md
cp Claude-code-adversarial-review-skill/commands/adversarial-review.md ~/.claude/commands/adversarial-review.md
```

### Install Script

```bash
git clone https://github.com/lemon03390/Claude-code-adversarial-review-skill.git
cd Claude-code-adversarial-review-skill
./install.sh
```

## Usage

### Code Review (Phase A)

```
# Default: review current branch vs main, 5 rounds of debate
/adversarial-review

# Specify number of debate rounds
/adversarial-review 8

# Natural language also works
> adversarial review my changes
> red team this PR
> find holes in this code
```

### Architecture Review (Phase B)

```
/adversarial-review architecture

# Or natural language
> devil's advocate this design
> stress test this architecture
> attack this proposal
```

### What You Get

**Code Review output:**
```
## Summary
### PR Quality Score: 72/100 — Grade C
### Auto-Fixed (3 items)
### Blockers (confidence >= 7)
  - [CONFIDENCE: 9/10] Missing await on deleteUser() — fire-and-forget
  - [CONFIDENCE: 8/10] Empty catch {} in payment handler — silent failure
### Round Breakdown
  | Topic          | Rounds | Findings | Avg Confidence |
  | Correctness    | 2      | 3        | 8.3            |
  | Error Handling | 1      | 2        | 7.5            |
  | Security       | 1      | 1        | 8.0            |
  | Testing        | 1      | 2        | 6.5            |
### Verdict: Request Changes
```

**Architecture Review output:**
```
## Architecture Review
### Atomic Claims (15 claims decomposed)
### Attack Findings
  - Skeptical Engineer: [CONFIDENCE: 9] Single point of failure in...
  - Incident Responder: [CONFIDENCE: 8] No runbook for...
  - Security Researcher: [CONFIDENCE: 7] Token rotation missing...
### Steelman (5 points)
### Counter-Argument (5 points)
### Fatal Flaws: None found
### Verdict: Revise — 3 mitigations recommended
```

## Customization

### Framework-Specific Extensions

The skill ships with a universal detection pattern set. Add framework-specific patterns for your stack:

| Extension | Adds Detection For |
|-----------|-------------------|
| **React / React Native** | Re-render issues, useEffect dep lies, missing error boundaries |
| **Django / Python** | N+1 ORM, bare except, missing select_related |
| **Rails / Ruby** | N+1 ActiveRecord, mass assignment, missing includes |
| **Supabase / PostgreSQL** | RLS gaps, SECURITY DEFINER misuse, NULL traps |
| **Next.js / Vercel** | Client/server boundary leaks, missing revalidate |

See the **Prerequisites** section in [SKILL.md](./SKILL.md) for copy-paste extension blocks.

### Project-Level Override

```bash
# Create project-specific version
mkdir -p .claude/skills/adversarial-review
cp ~/.claude/skills/adversarial-review/SKILL.md .claude/skills/adversarial-review/SKILL.md
# Edit to add your stack extensions + custom patterns
```

Project-level overrides take precedence over the global skill.

## How It Works

### Phase A: Code Review Pipeline

```
A.1 Scope         → git diff main...HEAD
A.2 Critical Scan → Silent pattern scan, auto-blockers (confidence >= 7)
A.3 Specialists   → 4 specialist perspectives (Security/Perf/Test/Error) [>= 100 lines]
A.4 Debate        → Author vs Reviewer, N rounds, forced disagreement
A.5 Fix-First     → Auto-fix mechanical issues, flag decisions
A.6 Summary       → PR Quality Score + structured report
```

### Phase B: Architecture Attack Pipeline

```
B.1 Decompose     → Break into 10-20 atomic claims
B.2 Attack        → 6 perspectives attack each claim
B.3 Steelman      → 5 best arguments for + 5 against
B.4 Verdict       → Rethink / Revise / Proceed
```

### Anti-Sycophancy Mechanisms

| Mechanism | Source | How It Works |
|-----------|--------|-------------|
| Forced disagreement | [devils-advocate](https://github.com/richiethomas/claude-devils-advocate) | Reviewer MUST find issues; Author MUST push back |
| Confidence filtering | [gstack](https://github.com/garrytan/gstack) | Score < 7 suppressed, reduces noise |
| Multi-perspective attack | [RedTeam](https://github.com/danielmiessler/Personal_AI_Infrastructure) | 6 adversarial viewpoints simultaneously |
| Detection patterns | [critical-code-reviewer](https://github.com/posit-dev/positron) | Language-specific red flags, not vibes |

## Token Consumption (Rough Estimates)

These are rough estimates based on internal testing, not formal benchmarks. Actual consumption varies with diff complexity, model version, and number of findings.

| Scenario | Estimated Tokens |
|----------|-----------------|
| Small diff (< 100 lines), 5 rounds | ~15-25K |
| Medium diff (100-500 lines), 5 rounds + specialists | ~25-40K |
| Large diff (500+ lines), 8 rounds + specialists | ~40-55K |
| Architecture review (medium proposal) | ~20-35K |

vs. plain "review my code" prompt: ~3-8K (but lower quality, no structure, no anti-sycophancy)

## Version History

| Version | Lines | Changes |
|---------|-------|---------|
| v1.0 | 266 | Debate + Architecture Attack |
| v1.1 | 385 | + Confidence scoring, specialist dispatch, auto-fix, PR Score |
| v1.2 | ~200 (core) | /simplify: -47% core lines, zero functional loss |
| v1.2 + extensions | ~300 | + Framework prerequisite blocks (React, Django, Rails, Supabase, Next.js) |

See [CHANGELOG.md](./CHANGELOG.md) for details.

## Contributing

PRs welcome! Especially:
- New framework extension blocks (Vue, Angular, Go, Rust, etc.)
- Improved detection patterns
- Real-world usage reports and tuning suggestions

## License

[MIT](./LICENSE)

## Credits

Built by synthesizing the best ideas from:
- [richiethomas/claude-devils-advocate](https://github.com/richiethomas/claude-devils-advocate) — debate mechanic
- [posit-dev/positron (critical-code-reviewer skill)](https://github.com/posit-dev/positron) — detection patterns, severity tiers
- [danielmiessler/Personal_AI_Infrastructure](https://github.com/danielmiessler/Personal_AI_Infrastructure) — multi-perspective attack
- [garrytan/gstack](https://github.com/garrytan/gstack) — specialist dispatch, confidence scoring, fix-first

---

<a id="繁體中文"></a>

# Adversarial Review — Claude Code Skill（繁體中文）

**[English](#adversarial-review--claude-code-skill) | 繁體中文**

專為 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 設計的對抗性程式碼與架構審查 Skill，經過三輪自我審查迭代。透過結構化辯論、信心分評級和多角度攻擊，強制進行真正的批判性分析——專門突破 LLM 的諂媚傾向。

## 為什麼需要這個

LLM 預設傾向附和、表面的程式碼審查。這個 Skill 強制 Claude：

- **自我辯論** — 模擬作者 vs 資深審查者，強制反駁
- **信心分評級** — 每個發現評 1-10 分，低信心雜訊被壓制
- **專家派遣** — 平行安全/效能/測試/錯誤處理專家
- **自動修復** — 機械性修復自動套用，需人工決策的標記出來
- **品質量化** — PR 品質分數（0-100）附等級

## 功能對比

| 功能 | 直接說「review my code」 | 本 Skill |
|------|------------------------|----------|
| 結構化分析 | 無 | 6 步驟流水線 |
| 反諂媚機制 | 無 | 強制反駁 + 必須回擊 |
| 信心分過濾 | 無 | 1-10 分，<7 壓制 |
| 平行專家 | 無 | 4 個領域專家平行審查 |
| 自動修復 | 無 | 機械性修復自動套用 |
| PR 品質分數 | 無 | 量化 0-100 附等級 |
| 架構審查 | 無 | 6 角度攻擊 + 正反論證 |
| 框架擴展 | 無 | 按技術棧插入檢測模式 |

## 安裝

### 快速安裝（推薦）

```bash
# 安裝到 Claude Code 全域 skills 目錄
mkdir -p ~/.claude/skills/adversarial-review
curl -o ~/.claude/skills/adversarial-review/SKILL.md \
  https://raw.githubusercontent.com/lemon03390/Claude-code-adversarial-review-skill/main/SKILL.md

# 選用：新增斜槓命令
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/adversarial-review.md \
  https://raw.githubusercontent.com/lemon03390/Claude-code-adversarial-review-skill/main/commands/adversarial-review.md
```

### 手動安裝

```bash
git clone https://github.com/lemon03390/Claude-code-adversarial-review-skill.git
cp Claude-code-adversarial-review-skill/SKILL.md ~/.claude/skills/adversarial-review/SKILL.md
cp Claude-code-adversarial-review-skill/commands/adversarial-review.md ~/.claude/commands/adversarial-review.md
```

### 安裝腳本

```bash
git clone https://github.com/lemon03390/Claude-code-adversarial-review-skill.git
cd Claude-code-adversarial-review-skill
./install.sh
```

## 使用方式

### 程式碼審查（Phase A）

```
# 預設：審查當前分支 vs main，5 輪辯論
/adversarial-review

# 指定辯論輪數
/adversarial-review 8

# 自然語言也可以
> adversarial review my changes
> red team this PR
> find holes in this code
```

### 架構審查（Phase B）

```
/adversarial-review architecture

# 或自然語言
> devil's advocate this design
> stress test this architecture
> attack this proposal
```

### 輸出範例

**程式碼審查輸出：**
```
## Summary
### PR Quality Score: 72/100 — Grade C
### Auto-Fixed (3 items)
### Blockers (confidence >= 7)
  - [CONFIDENCE: 9/10] Missing await on deleteUser() — fire-and-forget
  - [CONFIDENCE: 8/10] Empty catch {} in payment handler — silent failure
### Round Breakdown
  | Topic          | Rounds | Findings | Avg Confidence |
  | Correctness    | 2      | 3        | 8.3            |
  | Error Handling | 1      | 2        | 7.5            |
  | Security       | 1      | 1        | 8.0            |
  | Testing        | 1      | 2        | 6.5            |
### Verdict: Request Changes
```

**架構審查輸出：**
```
## Architecture Review
### Atomic Claims（15 個原子性主張）
### Attack Findings
  - 懷疑派工程師: [CONFIDENCE: 9] 單點故障在...
  - 事故應變者: [CONFIDENCE: 8] 缺少 runbook...
  - 安全研究員: [CONFIDENCE: 7] Token 輪換缺失...
### Steelman（5 個最強論點）
### Counter-Argument（5 個最致命弱點）
### Fatal Flaws: 未發現
### Verdict: Revise — 建議 3 項緩解措施
```

## 自訂化

### 框架特定擴展

Skill 內建通用檢測模式。可為你的技術棧新增框架特定模式：

| 擴展 | 新增檢測 |
|------|---------|
| **React / React Native** | 重渲染問題、useEffect 依賴陣列錯誤、缺少 error boundaries |
| **Django / Python** | N+1 ORM、裸 except、缺少 select_related |
| **Rails / Ruby** | N+1 ActiveRecord、mass assignment、缺少 includes |
| **Supabase / PostgreSQL** | RLS 缺口、SECURITY DEFINER 誤用、NULL 陷阱 |
| **Next.js / Vercel** | Client/Server 邊界洩漏、缺少 revalidate |

詳見 [SKILL.md](./SKILL.md) 的 **Prerequisites** 區段，內有可直接複製貼上的擴展區塊。

### 專案層級覆寫

```bash
# 建立專案專用版本
mkdir -p .claude/skills/adversarial-review
cp ~/.claude/skills/adversarial-review/SKILL.md .claude/skills/adversarial-review/SKILL.md
# 編輯並加入你的技術棧擴展 + 自訂模式
```

專案層級覆寫優先於全域 Skill。

## 運作原理

### Phase A：程式碼審查流水線

```
A.1 範圍界定     → git diff main...HEAD
A.2 關鍵掃描     → 靜默模式掃描，自動標記 blocker（信心分 >= 7）
A.3 專家派遣     → 4 個專家角度（安全/效能/測試/錯誤處理）[>= 100 行]
A.4 辯論         → 作者 vs 審查者，N 輪，強制反駁
A.5 先修後報     → 自動修復機械性問題，標記需決策項目
A.6 總結         → PR 品質分數 + 結構化報告
```

### Phase B：架構攻擊流水線

```
B.1 拆解         → 拆分為 10-20 個原子性主張
B.2 攻擊         → 6 個角度攻擊每個主張
B.3 正反論證     → 5 個最強支持論點 + 5 個最致命弱點
B.4 裁決         → 重新思考 / 修訂 / 帶風險推進
```

### 反諂媚機制

| 機制 | 來源 | 運作方式 |
|------|------|---------|
| 強制反駁 | [devils-advocate](https://github.com/richiethomas/claude-devils-advocate) | 審查者必須找問題；作者必須回擊 |
| 信心分過濾 | [gstack](https://github.com/garrytan/gstack) | 分數 < 7 壓制，減少雜訊 |
| 多角度攻擊 | [RedTeam](https://github.com/danielmiessler/Personal_AI_Infrastructure) | 6 個對抗性視角同時攻擊 |
| 檢測模式 | [critical-code-reviewer](https://github.com/posit-dev/positron) | 語言特定紅旗，非靠感覺 |

## Token 消耗（粗略估算）

以下為內部測試的粗略估算，非正式基準。實際消耗因 diff 複雜度、模型版本和發現數量而異。

| 場景 | 估算 Token |
|------|-----------|
| 小型 diff（< 100 行），5 輪 | ~15-25K |
| 中型 diff（100-500 行），5 輪 + 專家 | ~25-40K |
| 大型 diff（500+ 行），8 輪 + 專家 | ~40-55K |
| 架構審查（中等規模提案） | ~20-35K |

vs. 直接說「review my code」：~3-8K（但品質更低、無結構、無反諂媚）

## 版本歷史

| 版本 | 行數 | 變更 |
|------|------|------|
| v1.0 | 266 | 辯論 + 架構攻擊 |
| v1.1 | 385 | + 信心分、專家派遣、自動修復、PR 分數 |
| v1.2 | ~200（核心） | /simplify：核心行數 -47%，功能零損失 |
| v1.2 + 擴展 | ~300 | + 框架前置條件區塊（React、Django、Rails、Supabase、Next.js） |

詳見 [CHANGELOG.md](./CHANGELOG.md)。

## 貢獻

歡迎 PR！特別是：
- 新框架擴展區塊（Vue、Angular、Go、Rust 等）
- 改進檢測模式
- 實際使用報告與調優建議

## 授權

[MIT](./LICENSE)

## 致謝

整合以下開源專案的最佳實踐：
- [richiethomas/claude-devils-advocate](https://github.com/richiethomas/claude-devils-advocate) — 辯論機制
- [posit-dev/positron（critical-code-reviewer skill）](https://github.com/posit-dev/positron) — 檢測模式、嚴重度分級
- [danielmiessler/Personal_AI_Infrastructure](https://github.com/danielmiessler/Personal_AI_Infrastructure) — 多角度攻擊
- [garrytan/gstack](https://github.com/garrytan/gstack) — 專家派遣、信心分、先修後報
