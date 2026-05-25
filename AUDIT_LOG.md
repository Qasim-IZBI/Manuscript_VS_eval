# Audit Log — Manuscript Revision History

This file records the manuscript-wide audit and revision decisions made across collaborative sessions.
**For future sessions:** read this file first, then `CLAUDE.md`, then `writing_style.md` before making any prose edits.

---

## Quick orientation

The manuscript has been through a structured per-section audit, alternating between (a) addressing the user's inline `%`-comments and (b) a broader simplification + alignment pass on each section.

**Sections with completed full audit:** abstract (placeholders filled + framing aligned + flow polish), introduction, related_work, dataset, models_section, experimental_setup, evaluation_metrics, results, uncertainty_analysis (major restructure + content fill + full audit), discussion (full audit + new Inter-seed agreement block), conclusion (variance placeholder filled + full audit).
**Sections with open work:** supplementary (received notation-alignment + tile-filter additions this session, but no full simplification pass yet); `bmvc_final.tex` abstract is empty and needs porting from `bmvc_review.tex`.

**Section audit checklist** (use for any new section):
1. Cross-section redundancy with abstract/intro/related work (collapse unless adding new info)
2. Internal redundancies within the section
3. Wordy / academic phrasings → simpler. **Target: plain language that an experienced reader can read at speed, without sacrificing technical precision.** Keep field-specific terms (CPA MAE, DDIM, AdaIN, ECE, IQR…), numerics, equations, and formal register; cut filler, Latinate verbs where a plain one works (`distinguishes → separates`, `utilise → use`), rhetorical elevation (`the gold standard → used for`), jargon-for-its-sake (`uncertainty granularity → fine-grained uncertainty`), and dense semicolon-spanning sentences.
4. Style guide compliance (no em-dashes, `\textbf{Topic:}` style, no `\subsection` mid-section)
5. Cross-file consistency on canonical terms (see glossary below)
6. Em-dash sweep via `grep -n "---" file.tex | grep -v '^[0-9]*:%'`

---

## Manuscript-wide canonical decisions

Apply these globally; check before introducing variant terms.

### Terminology
| Use | Don't use | Notes |
|---|---|---|
| `task-specific` | `task-based` | Replaced globally across all 7 files |
| `hematoxylin` (American) | `haematoxylin` (British) | Replaced globally; abstract sets the convention |
| `bile-duct ligation experiment` | `bile-duct ligation model` | "Experiment" everywhere; some sections add `of cholestatic liver disease` |
| `SR` / `SR-positive` / `SR-labelled` | `PSR` / `PSR-positive` / `PSR-labelled` | PSR (Picrosirius Red) was a stray term; unified to SR |
| `CPA MAE` (consistently) | bare `MAE` for this metric | Abstract previously defined `(MAE)` then used `CPA MAE` everywhere — fixed |
| `structural, perceptual, and distributional` (in eval_metrics) | `pixel-level` (contradicts the "pixel-level comparison cannot serve as ground truth" claim earlier in that section) | In `related_work` the `pixel-level metrics such as SSIM` literature-taxonomy usage is preserved deliberately |
| `epistemic uncertainty` / `predictive variance` / `confidently wrong` | `reproducibility` / `across-seed reproducibility` / `reproducibly wrong` | Uncertainty-flavoured vocabulary chosen to match section title and literature (Gal, Lakshminarayanan). `mean ensemble variance` stays as the specific metric name; `epistemic uncertainty` is what it measures. `reproducible` is still OK for open-science contexts (e.g. `support reproducible benchmarking`) and for data-split determinism — only swap when referring to the ensemble metric |

### Canonical phrasings (use verbatim across sections)
- **Novelty claim** (abstract, intro, related work, conclusion all aligned):
  `the first systematic comparison of epistemic uncertainty across unsupervised stain-to-stain architectures`
- **Dataset release** (abstract, intro):
  `the first open resource for unsupervised H\&E~$\to$~SR translation in mouse liver tissue`
- **CPA MAE range** — two canonical forms:
  - **Body sections** (results, discussion, conclusion): `0.008 (CycleGAN, medium generator, 100\% data) to 0.171` — 21-fold span (full attribution)
  - **Abstract**: `0.008 to 0.171, a 21-fold span` (attribution dropped for abstract brevity — full info lives in the body)
- **Spearman range** (abstract, results, conclusion):
  `r_s = 0.55--0.64` for CPA MAE vs perceptual metrics

### Mathematical notation (main paper + supplementary, harmonised)
| Object | Use | Don't use |
|---|---|---|
| Generator family | `$G_k$` | `$G^{(k)}_{A \to B}$` |
| Tissue-pixel set | `$\mathcal{T}$` | `$\Omega$` |
| Uncertainty map | `$\mathbf{U}(x) \in \mathbb{R}^{H \times W}$` | scalar `$U(x,y)$` (overloads `$x$`) |
| Per-pixel value | `$\mathbf{U}(x)_p$` | `$U(x,y)$` / `$U(i,j)$` |
| Tile-level scalar | `$\bar{\sigma}^2(x)$` | (consistent) |
| Pixel index | `$p$` | `$(x,y)$` |

Supplementary §9.1 was harmonised to main paper §6.2 in this session — keep both in sync going forward.

### Tile filter for uncertainty + calibration
- **$N=9{,}365$** tiles is the calibration set, defined as tiles with **≥ 0.1% tissue mask coverage** (supplementary §9.2 "Tile preparation and tissue masking" is the single source of truth).
- This is **distinct** from the scaling-study's 50% tissue-mask threshold for training tiles (supplementary §line ~101). Do not conflate. Main paper §6.3 caption surfaces the 0.1% filter; downstream mentions refer back rather than re-state.

### Abbreviation rules
- **Abstract:** self-contained — defines its own abbreviations on first use.
- **Body:** define each abbreviation **once** on first non-caption use (typically intro), then use the abbreviation in all later sections (related work, dataset, models, etc.). Do **not** re-define.
- **Figure captions:** allowed to re-define for self-containment.
- Body first-use locations:
  - `H\&E` → intro L24 (was missing for `WSI`, now added at intro figure caption L13)
  - `SR` → intro L36
  - `I2I` → intro L67 (was used at L67 before being defined at L75; reordered)
  - `BDL` → intro L91 (`mouse bile-duct ligation~(BDL) experiment`)
  - `CPA` → intro L17 (figure caption) + L38 (body — both allowed)
  - `CPA MAE` → intro L81 (`task-specific CPA mean absolute error~(CPA~MAE)`)
  - `WSI` → intro figure caption L13

---

## Style overrides on top of `writing_style.md`

These were user-confirmed overrides. Do **not** revert without explicit instruction.

1. **Topic-led headers: `\textbf{Topic:}`, NOT `\paragraph{Topic.}`** — applies to related_work, experimental_setup, evaluation_metrics, results, discussion, uncertainty_analysis. The `writing_style.md` recommendation of `\paragraph{}` was explicitly overridden when I converted them — user reverted.
2. **`patch-based SSIM` keeps the `patch-based` qualifier on every mention** (not just first) — the variant-vs-full-image distinction is load-bearing on each use.
3. **Em-dash hard rule still holds** (no `---` for parenthetical definitions / trailing remarks in main paper prose). Supplementary table cells use `---` as N/A; supplementary prose has a few residual em-dashes not yet swept (lines ~685, 700, 759).

---

## Per-section audit summary

### Abstract (`bmvc_review.tex` lines 37–68) — **FULL AUDIT + FRAMING ALIGNMENT + FLOW POLISH**

**Prior sessions:** ~240 words; flow `motivation → contributions → results`. Left open: xxx/yy placeholders, missing ghallab cite, "hallucination signal" overclaim, "deployment decisions" language.

**This session (placeholder fills + framing alignment + flow):**
- **Placeholders filled** — variance line rewritten to the joint DCLGAN+CycleDiffusion reading (matches conclusion verbatim, then split into three short sentences for readability).
- **"Hallucination signal" overclaim softened** — `Inter-member disagreement in GAN ensembles provides a useful tile-level hallucination signal…` → variance/CPA~MAE separation framing. Motivation `hallucinated tissue structures` → `visually plausible outputs in the unpaired setting may not faithfully reproduce the underlying tissue structure` (mirrors §6 opener).
- **Dataset release sentence rewritten** — `we release an open whole-slide image dataset of paired H\&E and SR sections from a mouse BDL experiment` → `we release a paired H\&E and SR whole-slide image dataset from a mouse bile-duct ligation experiment, the first open resource for unsupervised H\&E~$\to$~SR translation in mouse liver tissue`. Adds canonical novelty claim; **no `\cite{ghallab2025asbt}` per user preference** (abstract is intentionally cite-free in this manuscript).
- **Deployment language scrubbed** — `for deployment decisions` → `for model selection` → `confirming that perceptual metrics alone cannot guide model selection` (aligns with three-axes framing from conclusion).
- **`CPA~MAE` tilde harmonised** throughout (was 2 plain + 2 tilde; now uniform).
- **SR opening sentence rewritten** for sentence-1 → sentence-2 flow (user comment): `Sirius Red~(SR) is the gold standard for CPA measurement and a key quantitative readout for fibrosis staging, yet it has received little attention as a virtual staining target.` → `Sirius Red~(SR), one such stain used for collagen proportionate area~(CPA) measurement in liver fibrosis staging, has received little attention as a virtual staining target.` Dropped both `is the gold standard` and the contrastive `yet`; `one such stain` bridges back to `histochemical stains in liver tissue` from sentence 1.
- **Uncertainty motivation merged into one flowing clause**: `or quantified the predictive uncertainty of such models. Such uncertainty quantification is essential, since hallucinated tissue structures…` → `or quantified the predictive uncertainty of such models, which is essential since visually plausible outputs in the unpaired setting may not faithfully reproduce the underlying tissue structure.`
- **Best-configuration qualifier added**: `the best configuration per model family` → `the best full-data configuration per model family` (clarifies the §6.1 data-fraction filter).
- **CPA~MAE range parenthetical dropped** for abstract brevity: `(CycleGAN, medium generator, 100\% data)` removed (canonical full-attribution form lives in body sections — see canonical decisions table).
- **Variance line restructured for readability**: was one dense `: … while …` sentence; now three short sentences (axis statement, DCLGAN finding, CycleDiffusion finding).
- **`distinct from` → `separates families on a second axis beyond CPA~MAE`** (one-line natural-language polish).

**Pre-existing user `%` comment at L40 (`%come back to this coonection`) still present — user TODO to clear when ready.**

### Introduction (`introduction.tex`)
Full audit done. Five contributions paragraph replaced with **three prose paragraphs** (scaling+task-eval / uncertainty / dataset), `\begin{enumerate}` removed per writing_style rule.
- Citations added for all six models on first mention.
- UNet, ViT, DDIM references added (`ronneberger2015unet` was added to `references.bib`).
- WSI definition added to figure caption.
- **Hallucination framing softened (this session)**: was `ensemble variance directly flags hallucinations: where the prediction varies across independently trained members, the model has no consistent answer` (overclaim — no GT to verify the variance corresponds to hallucinations). Now `ensemble variance provides an indirect check: where independently trained members disagree, the unsupervised objective does not pin down a unique answer for that input, an indicator of epistemic uncertainty that complements task-specific evaluation`. Aligns with §6 opener framing.

### Related Work (`related_work.tex`)
Full audit done. P1 collapsed from 13 → 5 lines (was duplicating intro). Klöckner standalone paragraph dropped (already cited in P3). StainDiffuser standalone paragraph dropped (already in P3 benchmark list). P4+P5 merged into one paragraph using `therefore` connector. P6 (Epistemic Uncertainty) merged P1+P2 with `Yet` connector; P3 (the gap statement) kept separate.
- `\textbf{Topic:}` style preserved throughout (user override).
- SR segmentation U-Net sentence dropped (not relevant to our work).
- Final claim was `summarised as per-family predictive variance` (was originally `assessing their calibration against cycle-reconstruction error`).
- **This session**: `predictive variance` → `mean ensemble variance` at L85 — aligns to canonical metric name used in abstract + §6 + conclusion.

### Dataset (`dataset.tex`)
Tightening + cross-section alignment.
- `recapitulate a progression` → `covering`
- `is the diagnostic gold standard for hepatic collagen quantification` removed (established in intro/related work).
- Long sentence split at semicolon.
- `the first publicly available resource ... in liver tissue` → `the first open resource ... in mouse liver tissue` (matches intro).

### Models (`models_section.tex`)
Body paragraph tightened (12 → 8 lines). **Numerical fix:** `yielding 54 configurations in total` was mathematically wrong here (6×3 = 18, not 54 — the data-fraction dimension lives in §5). Dropped from this section. Param spacing fixed `${\sim}10$\,M` → `${\sim}10$M` (CLAUDE.md convention).

### Experimental Setup (`experimental_setup.tex`)
User comments + simplification.
- CycleDiffusion training-step sentence collapsed (all 5 GAN+diff models now in one sentence; UVCGAN keeps its own two-stage line).
- `folder ranges` → `ranges`.
- `N=5` added to test-set sentence.
- Tile-saving plumbing sentence dropped.
- Step-based-training jargon simplified to `we count training in optimiser steps rather than epochs`.

### Evaluation Metrics (`evaluation_metrics.tex`)
User comments + simplification + reframing.
- Metric order reordered to **SSIM → LPIPS → FID** (matches related work).
- **Loose co-registration of test set made explicit** in the H&E/SR setup paragraph (reviewer concern about why SSIM/LPIPS can be used on a nominally unpaired dataset).
- nnU-Net training: `real SR tiles` → `real SR WSIs`; CPA computation: `For each tile` → `For each WSI`.
- `\textbf{Task-Based Evaluation:}` header → `\textbf{Task-Specific Evaluation:}` (case-sensitive global replace originally missed it).
- `pixel-level, perceptual, and distributional` → `structural, perceptual, and distributional` (was contradicting the `pixel-level comparison cannot serve as ground truth` claim above).
- Opener split at colon; redundant tissue-block restatement on L41 dropped.

### Results (`results.tex`)
- Figure caption `PSR-MAE` × 2 → `CPA MAE` (was the lone holdout).
- "Weaker" vs "moderate" terminology unified (both `0.49–0.60` and `0.55–0.64` ranges now called `moderate`).
- **Cross-model observation** paragraph dropped (fully restated L14 enumeration).
- **Joint scaling behaviour** paragraph dropped (per-family topology already in per-family blocks); one new fact (CycleDiffusion small/50% outlier) folded into CycleDiffusion block.
- Net: results.tex reduced from 146 → 122 lines.

### Uncertainty Analysis (`uncertainty_analysis.tex`) — **MAJOR RESTRUCTURE + CONTENT FILL + FULL AUDIT**
**Reframing:** the section is no longer about *calibration of uncertainty vs error*; it's about *epistemic uncertainty* (per-family ensemble variance) of the unsupervised models.

**Prior sessions (restructure):**
- Section opener motivates variance + "must be read alongside CPA MAE" caveat.
- §6.1 Model Selection, §6.2 Uncertainty Quantification (Eq.~\ref{eq:uncertainty}).
- §6.3 Uncertainty Calibration + §6.4 Results: entirely moved to supplementary §9.2/§9.3.
- File size: 254 → 125 lines.

**This session (content fill + audit):**
- **§6.3 "Results: Ensemble Variance" filled.** New boxplot figure (`images/uncertainty_boxplot.png`, copied from `/uncertainty_boxplot/`). Three `\textbf{}` blocks: GAN families (DCLGAN narrowest IQR, MUNIT highest median) / CycleDiffusion (lowest median, widest IQR) / Joint reading with CPA MAE. Closes with 1–2 sentence calibration summary (DCLGAN $\rho=0.61$, ECE $0.081$ + MUNIT lead; CycleDiffusion uncorrelated $\rho=-0.03$).
- **Opener softened**: `no paired SR target supervises` (was `constrains`); `inter-seed disagreement signal` (was `hallucination signal motivated above`); dropped three-category sentence (`deployment-ready / stably hallucinating / chaotic`) that was framing scaffolding never referenced again.
- **Section structure flattened**: two `\subsection{}` headings (`Model Selection for Ensemble Analysis`, `Uncertainty Quantification`) dropped → converted to `\textbf{Model selection:}` and `\textbf{Uncertainty quantification:}` blocks. Only `\subsection{Results: Ensemble Variance}` kept because `sec:unc_variance_results` is externally cited from discussion.
- **Pipeline figure collapsed** to single panel: dropped `wsi.png` subfigure and the `\textbf{(b)}` caption text; pipeline image is `images/only_uncertainty.png`. Figure now cited inline at the `$\{G_k\}_{k=1}^{K}$` description (was orphaned).
- **9,365-tile qualifier added**: caption and prose now clarify these are tiles with $\geq 0.1\%$ tissue mask coverage (calibration set, distinct from scaling-study's 50% threshold).
- **Notation aligned** with supp §9.1 (see "Mathematical notation" canonical decisions).
- L33 figure ref: $\bigstar$ pointer to `fig:results_overview` (combined_metrics — that's where the stars are).
- $\bar{\sigma}^2$ statistic: "reported below" → "summarised in Figure~\ref{fig:uncertainty_boxplot}".
- `$C{=}3$` (RGB) clarification.
- Ensemble training + size justification tightened (1 line each).

### Discussion (`discussion.tex`) — **FULL AUDIT**

**Prior sessions:** `\textbf{Ensemble uncertainty and deployment readiness:}` block (~25 lines) moved to supplementary §9.3 as `\textbf{Interpretation.}` paragraph (deduplicated against the moved results content).

**This session (content add + full audit):**
- **New `\textbf{Inter-seed agreement across families:}` block** inserted between CycleDiffusion paradigm block and Limitations. Covers DCLGAN (IQR 0.043 + leading calibration), CycleGAN (primary candidate when raw task accuracy outweighs uncertainty information), MUNIT (high median uncertainty + AdaIN), CycleDiffusion (conditionally consistent + DDIM shared-noise mechanism + uncorrelated with cycle error).
- **Topic-line refocused** from `uncertainty calibration is contingent on architectural properties` → `inter-seed agreement across deep ensembles separates the six families along an axis distinct from CPA~MAE` (calibration is only briefly summarised in main paper; inter-seed agreement is the actual headline of §6.3).
- **Deployment language scrubbed** (was multiple instances): `\textbf{Training instability as a deployment risk:}` → `\textbf{Training instability:}`; `most defensible choice when ensemble-based triage is part of the deployment workflow` → `combines low task error with the most informative ensemble-variance signal`.
- **CycleGAN M-vs-L illustration**: split at em-dash into two sentences, made the selection-workflow connection explicit, fixed `---` em-dash violation.
- **Citation placement**: `\cite{trustworthy_i2i2025}` moved from dangling end-of-claim to `Consistent with prior calibration analyses of unpaired translation~\cite{trustworthy_i2i2025}, these findings confirm…` (citation supports broader claim).
- **FID-only training monitoring** (dropped Patch-SSIM — needs registration not available at training time).
- **Two long headers trimmed**: `Perceptual saturation and the case for task-specific evaluation:`, `Minimum viable configurations across scaling:`.
- **AdaIN second mention** converted to back-reference: `is the inter-seed counterpart of the AdaIN-based stability noted above`.
- **Dense DDIM-conditioning sentence** split at semicolon.
- **`uncertainty granularity` jargon** → `fine-grained uncertainty information`.
- **M/L abbreviation** spelled out at first inline use (`medium and large generators at 100\% data` instead of `CycleGAN\,M/100\%` / `CycleGAN\,L/100\%`).
- **Limitations trimmed**: dropped `multi-centre validation on human liver tissue` (overcommit beyond mouse domain); deleted ensemble-size ablation caveat (we don't make quality claims about the uncertainty signal that would require this defence).
- **"Non-smooth landscape"** rewritten in plain prose.
- `CPA~MAE` (not `CPA MAE`) used consistently.

### Conclusion (`conclusion.tex`) — **FULL AUDIT + PLACEHOLDER FILLED**

**Prior sessions:** calibration-numbers sentence replaced with variance line + supp pointer; three-axes framing updated to `perceptual / task / epistemic uncertainty`; `bile-duct ligation experiment` parity; novelty claim aligned to canonical.

**This session:**
- **Variance placeholder filled**: `DCLGAN pairs low task error with the narrowest inter-seed spread (IQR $0.043$) and the most informative variance signal among GAN families, while CycleDiffusion records the lowest mean ensemble variance ($3.16$) but the widest spread and is uncorrelated with cycle-reconstruction error.`
- **Calibration pointer upgraded** from bare supp reference to a meaningful tile-vs-pixel one-liner: `Uncertainty signals are informative only at tile resolution; pixel-level uncertainty does not reliably co-locate with high-error regions within a tile (Supplementary Sec.~9.3)`.
- **Deployment language scrubbed**: `deployment risk` → `degrades translation as severely as`; `must all be considered for clinical deployment` → `three independent evaluation axes for unsupervised stain translation`.
- **Blind-review fix on dataset attribution**: `We introduced an open dataset … from a mouse bile-duct ligation experiment~\cite{ghallab2025asbt}` → `We release as an open benchmark the … dataset from the mouse bile-duct ligation experiment of~\cite{ghallab2025asbt}`. **Same pattern is the recommended fix for the still-unresolved abstract L55–56 issue.**
- **Canonical "21-fold span"** phrasing now used at L23.
- **`CPA~MAE` tilde harmonisation** (4 plain → tilde; replace_all sweep).
- Drop `in this domain` trailing filler.
- Drop `independently` from `independently evaluated configurations`.
- Tighten `exploits the paired tissue-block structure to provide a biologically grounded benchmark` → `grounded in the paired tissue-block structure`.
- Present-tense switch on opening (`release ... conduct` to match the rest of the conclusion).

### Supplementary (`supplementary.tex`) — **PARTIAL** (received content from §6 + targeted alignment, but no full simplification pass)

**Prior sessions:** receiver of moved content (calibration + interpretation). `PSR-positive signal` → `SR-positive signal`.

**This session (targeted alignment, not a full audit):**
- **§9.1 notation harmonised** with main paper §6.2: $G^{(k)}_{A \to B} \to G_k$; $\Omega \to \mathcal{T}$; per-pixel scalar $U(x,y) \to \mathbf{U}(x)_p$ (resolves the $x$/input-tile-vs-pixel-coordinate overload). Pedagogical splitting (per-channel → summed) preserved.
- **§9.2 "Tile preparation and tissue masking" methodology block**: added explicit `≥ 0.1%` tissue-mask-coverage filter + `$N{=}9{,}365$` resulting tile count. This is the single source of truth for the calibration tile filter; main paper §6.3 caption surfaces it; downstream supp mentions refer back.
- **Spearman histogram caption (L886)**: dropped misleading `all` from `$N{=}9{,}365$ test tiles`.

**Still outstanding:** residual em-dashes in prose (L685–701, L759 — pre-existing, not yet swept); pre-existing user TODO at L789–791 (`per-family uncertainty maps figure`); no general simplification pass.

---

## Open TODOs / placeholders (machine-grepable)

Search the codebase for `\textcolor{red}` and `xxx` / `yy` to find these.

| Location | What | Status |
|---|---|---|
| `bmvc_final.tex` abstract | Empty (`% TODO`) | `bmvc_review.tex` abstract is now stable — ready to port edits across |
| `supplementary.tex` L685–701, L759 | Residual em-dashes in prose | Out of scope so far; sweep if asked |
| `supplementary.tex` L789–791 | `[TODO: per-family uncertainty maps figure]` | Pre-existing user TODO |
| `bmvc_review.tex` abstract L40 | `%come back to this coonection` | Pre-existing user TODO note |
| `bmvc_review.tex` abstract end | `%come back to the uncertainty analysis and meaningfull results report.` | Pre-existing user TODO note (was at L67 prior to recent edits) |

**Resolved this session:**
- ✓ `uncertainty_analysis.tex` §6.3 variance results placeholder (filled with boxplot + 3 blocks + calibration summary)
- ✓ `conclusion.tex` variance summary placeholder (DCLGAN + CycleDiffusion contrast)
- ✓ `uncertainty_analysis.tex` figure: dropped `wsi.png` subfigure per user request; pipeline panel retained. (User may still want to swap the pipeline image itself.)
- ✓ `bmvc_review.tex` abstract `xxx/yy` placeholders (joint DCLGAN+CycleDiffusion reading, matches conclusion)
- ✓ `bmvc_review.tex` abstract "hallucination signal" wording softened (aligned with §6/intro/discussion/conclusion)
- ✓ `bmvc_review.tex` abstract dataset release sentence (canonical "first open resource" claim added; no cite per user preference)
- ✓ `bmvc_review.tex` abstract deployment language scrubbed
- ✓ `bmvc_review.tex` abstract CPA~MAE harmonised + flow improvements (SR sentence, uncertainty motivation merge, variance line split)

---

## Files that have NOT yet received a full audit pass

- `supplementary.tex` — partial (received notation alignment + tile-filter additions this session; no full simplification pass). Residual em-dashes in prose still to sweep.
- `bmvc_final.tex` — camera-ready; abstract still empty (`% TODO`). `bmvc_review.tex` abstract is stable, ready to port across.
- `dataset_split.csv`, `paper_structure.md`, `related_work.md` — not LaTeX, out of audit scope.

## Cross-section framing alignment (status after this session)

**All main-paper sections (abstract, introduction, §6, discussion, conclusion) are now aligned on:**
- **Variance ≠ hallucination signal:** abstract, §6, intro, discussion, conclusion all frame ensemble variance as an "indirect check" / "inter-seed disagreement signal" rather than a direct hallucination detector (we have no GT to verify).
- **No deployment/clinical framing:** scrubbed from abstract ("model selection" / "perceptual metrics alone cannot guide"), §6 ("conditionally consistent" instead of "deployment-ready"), discussion (headers + DCLGAN reframe), conclusion ("evaluation axes" instead of "clinical deployment").
- **Canonical metric name:** `mean ensemble variance` (not `predictive variance`).
- **Joint DCLGAN+CycleDiffusion variance reading:** abstract, §6.3, discussion's Inter-seed block, and conclusion all use the same finding — DCLGAN combines low task error with the narrowest spread and most informative variance signal; CycleDiffusion records the lowest mean variance ($3.18$) but is uncorrelated with cycle-reconstruction error.
- **Canonical novelty + dataset claims:** abstract and intro both use the canonical "first systematic comparison of epistemic uncertainty…" + "first open resource for unsupervised H\&E~$\to$~SR translation in mouse liver tissue".
- **Tile filter for uncertainty/calibration:** $N=9{,}365$ tiles, $\geq 0.1\%$ tissue mask coverage (single source: supp §9.2).
- **Notation:** `$G_k$`, `$\mathcal{T}$`, `$\mathbf{U}(x)_p$`, `$\bar{\sigma}^2(x)$` consistent between main §6.2 and supp §9.1.

Main-paper framing alignment is **complete**. Remaining open items are housekeeping (supp em-dash sweep, supp simplification pass, `bmvc_final.tex` port).
