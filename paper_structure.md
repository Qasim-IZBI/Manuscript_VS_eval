# Paper Structure: Evaluating Unsupervised I2I Models for H&E → Sirius Red Virtual Staining

## Status Legend
- ✅ Written
- 🔄 In progress
- ⬜ Not started
- ❓ Decision pending

---

## 1. Abstract ⬜
~250 words. Written last once all results are known.

**Must cover:**
- Problem: SR staining requires a separate tissue section; virtual staining removes this burden
- Gap: no systematic comparison of unpaired I2I models for H&E→SR liver staining
- What we do: novel dataset + 54-configuration scaling study + task-based + uncertainty evaluation
- Key findings: (TBD)

---

## 2. Introduction ✅
*File: `introduction.tex`*

**Covers:**
- Para 1: Clinical motivation — liver fibrosis, Sirius Red as collagen gold standard
- Para 2: Virtual staining progress and the H&E→SR gap
- Para 3: Model diversity and the need for a scaling benchmark
- Para 4: Uncertainty gap in unpaired virtual staining
- Contributions (numbered list):
  1. Novel open H&E/SR liver dataset
  2. 54-run scaling study (6 models × 3 sizes × 3 data fractions)
  3. Multi-metric evaluation including task-based SR segmentation
  4. First epistemic uncertainty analysis via deep ensembles for unpaired virtual staining

---

## 3. Related Work ✅
*File: `related_work.tex`*

**Subsections:**
- 3.1 Virtual Staining in Histopathology
- 3.2 Unsupervised Image-to-Image Translation (the 6 evaluated models)
- 3.3 Applications to Histopathology Stain Translation
- 3.4 Evaluation Frameworks for Virtual Staining (incl. task-based evaluation)
- 3.5 Epistemic Uncertainty in Virtual Staining and I2I Translation

---

## 4. Dataset ✅
*File: `dataset.tex`*
*Primary contribution — deserves a dedicated section.*

### 4.1 Data Collection
- Tissue source and organ (liver biopsies)
- Patient cohort size and demographics
- Ethical approval / IRB statement
- Inclusion/exclusion criteria

### 4.2 Staining Protocol
- H&E preparation procedure
- Sirius Red staining procedure (dye concentration, fixation time)
- Note on sequential sectioning from the same block

### 4.3 WSI Acquisition
- Scanner make/model
- Magnification and effective resolution (µm/pixel)
- File format

### 4.4 Tiling and Preprocessing
- Tile size: 256×256 px
- Overlap and stride
- Tissue mask filtering (minimum tissue percentage per tile)
- Normalisation (pixel values to [−1, 1])
- Total tile counts per domain (table: train / val / test)

### 4.5 Data Splits and Subsets
- Train / val / test split strategy (patient-level to avoid leakage)
- How 25% / 50% / 100% subsets were constructed (e.g., stratified by fibrosis stage or patient)
- Summary statistics table (slides, tiles, fibrosis stage distribution per split)

### 4.6 Public Release
- Repository / DOI where dataset is released
- Licence and usage terms

---

## 5. Models ✅
*File: `models_section.tex`*

### 5.1 CycleGAN
- Two ResNet generators + two PatchGAN discriminators
- Cycle-consistency loss + adversarial loss + optional identity loss

### 5.2 UNIT
- Shared VAE bottleneck; KL divergence + reconstruction + adversarial losses

### 5.3 MUNIT
- Separate content encoder and style encoder per domain
- AdaIN decoder; content reconstruction + style reconstruction + adversarial losses

### 5.4 DCLGAN
- CycleGAN backbone + dual patch-level InfoNCE contrastive loss

### 5.5 UVCGAN
- UNet encoder/decoder with ViT bottleneck
- Optional masked image pretraining stage before cycle-consistent finetuning

### 5.6 MIUDiff
- Score-based DDPM with MI-guided energy function
- Three-stage training: unconditional pretraining → conditional finetuning → PCL refinement
- DDIM sampling at inference

**Table 1 — Model overview:** architecture family, loss components, pretraining required (Y/N), inference type (single-pass vs. iterative).

---

## 6. Experimental Setup ✅
*File: `experimental_setup.tex`*

### 6.1 Training Protocol
- Optimiser (Adam), learning rate, β₁/β₂
- Step-based training (not epoch-based) — total steps per stage
- AMP (mixed precision) enabled
- Hardware (GPU type, memory)
- Checkpoint and resume strategy
- Random seeds for reproducibility

### 6.2 Scaling Study Design
- **Model sizes:** three generator capacities per model family
  | Size   | Approx. params (single direction) |
  |--------|-----------------------------------|
  | Small  | ~10M                              |
  | Medium | ~50M                              |
  | Large  | ~100M                             |
  - Controlled by `--ngf` and `--n_blocks` (or equivalent per model)
  - Full per-model parameter table in Appendix A

- **Data fractions:** 25%, 50%, 100% of training tiles
  - Subsets fixed across all models for fair comparison (same tiles, same random seed)

- **Total configurations:** 6 models × 3 sizes × 3 data fractions = **54 runs**

### 6.3 SR Segmentation Model (for Task-Based Evaluation)
- Architecture: (e.g., U-Net)
- Training data: real SR tiles (held-out from translation training)
- Performance on real SR test set: Dice = ?, AUC = ?
- Kept frozen for all comparisons — trained once, applied identically to real and virtual SR

---

## 7. Evaluation Metrics ✅
*File: `evaluation_metrics.tex`*

### 7.1 Fréchet Inception Distance (FID)
- Measures distributional similarity between real and virtual SR tile sets
- Used because H&E/SR pairs are only loosely registered (adjacent sections)
- InceptionV3 feature extractor; computed on test set

### 7.2 Learned Perceptual Image Patch Similarity (LPIPS)
- VGG16 backbone; perceptual distance between paired tiles
- Paired by tile ID from adjacent sections (loose registration acknowledged)

### 7.3 Patch-based SSIM
- Rationale: full-image SSIM is unreliable under loose registration; patch-based variant
  samples local regions and averages, reducing sensitivity to global misalignment
- Patch size: ? px; patches per image: ?
- Paired by tile ID

### 7.4 Task-based Evaluation — SR Positive-Area Agreement
- Apply frozen SR segmentation model to real SR tiles and to each model's virtual SR output
- Compare resulting collagen proportionate area (CPA) distributions
- ✅ **Decision: Wasserstein-1 distance** (WSI-level, bootstrap 95% CI, 1000 iterations). Per-tile correlation ruled out (pseudoreplication). Supplementary: signed mean difference, std ratio, KS statistic.

### 7.5 Task-based Evaluation — Cross-Stain Spatial Consistency
- H&E collagen proxy mask (Macenko deconvolution + nuclear exclusion) vs. nnUNet v2 PSR+ mask on generated SR
- No real SR images required; H&E and generated SR are pixel-aligned by construction
- Metrics: Dice (DSC) and IoU, mean ± std across test WSIs
- Limitation: eosin channel is ECM proxy, not collagen-specific; bias is identical across models so relative comparisons remain valid

---

## 8. Results: Scaling Study ⬜

### 8.1 Overall Model Comparison
- Aggregated ranking across all 54 configurations (mean ± std per model family)
- Summary table: FID / LPIPS / patch-SSIM / CPA agreement per model
- Which model family performs best overall for H&E→SR

### 8.2 Effect of Model Size
- All three data fractions shown (25% / 50% / 100%) — not fixed
- FID / LPIPS / SSIM / CPA vs. parameter count, per model family
- Figures: small multiples — 2×3 grid of panels (one per model), 3 lines per panel (one per data fraction)
- Key questions: do all models benefit from larger capacity, or do some plateau/degrade? Is the size effect consistent across data regimes, or only visible at full data?

### 8.3 Effect of Training Data Size
- All three model sizes shown (Small / Medium / Large) — not fixed
- Metrics vs. data fraction (25% / 50% / 100%), per model family
- Figures: small multiples — 2×3 grid of panels (one per model), 3 lines per panel (one per model size)
- Key questions: which models are most data-efficient? Does data efficiency depend on model capacity?

### 8.4 Joint Scaling Behaviour (Synthesis)
- No new analysis — compact visual summary of the full 3×3 grid already covered in §8.2–8.3
- Figures: heatmaps (size × data fraction) per model, per metric — one heatmap per model family
- Purpose: side-by-side comparison of all 6 models on the full grid; lets readers see the interaction at a glance
- Key question: are capacity gains and data gains additive or redundant across model families?

### 8.5 Task-based vs. Perceptual Metric Agreement
- Rank correlation (Spearman) between FID/LPIPS/SSIM rankings and CPA-agreement ranking
- ❓ Key question: does perceptual quality predict clinical utility for SR staining?

---

## 9. Epistemic Uncertainty Analysis ⬜

### 9.1 Model Selection for Ensemble Analysis
- ✅ **Decision: Option B** — best configuration per model family (one winner per model, 6 total), selected by CPA agreement rank only (not a composite). Perceptual metrics excluded from selection to remain consistent with the paper's argument that FID/LPIPS/SSIM are unreliable proxies for clinical utility. FID/LPIPS/SSIM reported as supplementary columns in the selection table to illustrate divergence.
- Ensemble size: 10 independently initialised models per selected configuration
- Training cost note

### 9.2 Uncertainty Map Construction
- Per-pixel epistemic uncertainty = sum of per-channel sample variances (ddof=1) across 10 ensemble members
- Channel sum (not average) preserves total disagreement signal
- Visualisation: magma colorscale, global p1–p99 normalisation across all tiles
- Qualitative comparison across model families

### 9.3 Uncertainty Calibration ✅
- Error proxy: judge-based cycle-reconstruction MAE — uniform across all 6 models including MIUDiff; removes joint-bias confound of self-cycle
- ❓ **Judge model still TBD** — one frozen GAN checkpoint reused for all architectures
- Test set re-tiled with --overlap 0 to avoid double-counting in across-tile metrics
- Four metrics: within-tile Spearman ρ (spatial), across-tile Spearman/Pearson ρ (tile-level), AUSE (Ilg et al. 2018), ECE (reliability diagram shape, Guo et al. 2017)
- New refs added to references.bib: ilg2018ause, poggi2020sparsification, guo2017ece, kendall2017uncertainties

### 9.4 Failure Mode Analysis
- Curated examples: high-uncertainty tiles that correspond to poor SR generation
- Curated examples: low-uncertainty tiles that still fail (overconfident errors)
- Discussion of artefact types specific to each model family

---

## 10. Discussion ⬜

**Suggested points to cover:**
- What the scaling results imply practically: minimum viable model/data configuration for clinical-grade SR generation
- Whether task-based (CPA) ranking agrees with perceptual rankings, and clinical implications if they diverge
- What ensemble uncertainty reveals about deployment readiness of each model family
- Why diffusion-based MIUDiff behaves differently from GAN-based models (iterative inference, different failure modes)
- **Limitations:**
  - Single tissue type (liver) and single lab dataset — generalisability unknown
  - Loose registration prevents paired pixel-level ground truth
  - Ensemble uncertainty is epistemic only — aleatoric uncertainty (staining variability) not modelled
  - 10-member ensembles may underestimate uncertainty for large models
- **Future work:**
  - Multi-centre validation; other fibrosis stains (e.g., Masson's trichrome, PAS)
  - Registration-assisted paired evaluation
  - Aleatoric + epistemic uncertainty decomposition
  - Foundation model backbones (e.g., UNI, CONCH) as generators

---

## 11. Conclusion ⬜
~200 words.

- Restate the problem and gap
- Summarise the four contributions concisely
- Headline findings (to be inserted after experiments)
- Closing statement on open dataset and benchmark value to the community

---

## Appendices ⬜

### Appendix A — Full Parameter Count Table
Per-model, per-size generator parameter counts (exact, not approximate).

### Appendix B — Training Convergence
Loss curves for representative configurations; evidence of stable training.

### Appendix C — Full 54-Run Results Table
All metric values for all 54 configurations (too large for main text).

### Appendix D — Additional Qualitative Examples
Full-slide reconstructions and tile-level comparisons across model families and sizes.

### Appendix E — Dataset Statistics
Tile count per split, patient demographics, fibrosis stage distribution (Ishak or METAVIR scores).

---

## Open Decisions ❓

| # | Decision | Options | Impact |
|---|----------|---------|--------|
| 1 | ~~CPA agreement metric (§7.4)~~ | ✅ Wasserstein-1 (WSI-level, bootstrap CI); per-tile correlation ruled out | Resolved |
| 2 | ~~Model selection for uncertainty (§9.1)~~ | ✅ Option B: best-per-family, CPA agreement only | Resolved |
| 3 | ~~SR segmentation model architecture (§6.3)~~ | ✅ Off-the-shelf nnU-Net v2 from external publication; cite source, do not report our own Dice/AUC | Resolved |
| 4 | Fibrosis stage stratification in data splits (§4.5) | Stratified / random | Affects generalisability claims |

---

## Files

| File | Description | Status |
|------|-------------|--------|
| `dataset.tex` | Dataset section (TODOs for cohort details) | ✅ |
| `introduction.tex` | Introduction section | ✅ |
| `related_work.tex` | Related Work section | ✅ |
| `related_work.md` | Related Work (Markdown mirror) | ✅ |
| `models_section.tex` | Models section | ✅ |
| `evaluation_metrics.tex` | Evaluation Metrics section | ✅ |
| `experimental_setup.tex` | Experimental Setup section | ✅ |
| `paper_structure.md` | This file | ✅ |
| `CLAUDE.md` | Project context and references index | ✅ |
| `RelatedWorks/` | Reference PDFs | ✅ |
