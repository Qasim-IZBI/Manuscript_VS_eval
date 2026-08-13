# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a manuscript workspace for a paper on **image-to-image (I2I) virtual histology stain translation**. The project evaluates six unsupervised I2I models for **H&E → Sirius Red** virtual staining in mouse liver tissue. The second major contribution is an epistemic uncertainty analysis via deep ensembles.

**Dataset:** Mouse liver tissue from a **bile-duct ligation (BDL)** model of cholestatic liver disease (C57BL/6N mice, 4 time points: day 3/7/14/28 post-BDL + sham controls). Two stains per specimen: H&E, Sirius Red (SR). Introduced in Ghallab et al. (JHEP Reports 2025; `RelatedWorks/ASBTi/mmc6.pdf`).

**Experiment:** 6 models × 3 sizes × 3 data fractions = **54 configurations** (scaling study). Followed by deep ensemble (K=10) uncertainty analysis on the best configuration per model family, selected by CPA agreement rank only.

**Metrics:** FID, LPIPS, patch-based SSIM, and task-based CPA MAE (mean absolute error of paired real vs. virtual CPA values, WSI-level; frozen nnU-Net v2 SR segmentation model applied to real vs. virtual SR tiles). MAE is used because H&E and real SR are from the same tissue block, enabling direct paired comparison.

## Repository Structure

```
Manuscript_VS_eval/
├── bmvc_review.tex           # ★ Main file — submit this for blind review
├── bmvc_final.tex            # Main file — camera-ready after acceptance
├── bmvc2k.cls                # BMVC 2026 document class
├── bmvc2k_natbib.sty         # natbib citation package (bundled with BMVC class)
├── bmvc2k.bst                # BMVC bibliography style (IEEE-derived)
│
├── introduction.tex          # Section 1 — Introduction (✅ written)
├── related_work.tex          # Section 2 — Related Work (✅ written)
├── dataset.tex               # Section 3 — Dataset (✅ written; TODOs for cohort details)
├── models_section.tex        # Section 4 — Models (✅ written)
├── experiments.tex           # Section 5 — Experiments (wrapper; \inputs the three files below)
│   ├── experimental_setup.tex    # §5.1 — Training and Inference (✅ written)
│   ├── evaluation_metrics.tex    # §5.2 — Evaluation Metrics (✅ written)
│   └── results.tex               # §5.3 — Results: Scaling Study (⬜ stub)
├── uncertainty_analysis.tex  # Section 6 — Epistemic Uncertainty (🔄 §6.1–6.2 written)
├── discussion.tex            # Section 7 — Discussion (⬜ stub)
├── conclusion.tex            # Section 8 — Conclusion (⬜ stub)
│
├── references.bib            # Consolidated bibliography (49 entries)
├── images/                   # Figures directory
├── related_work.md           # Markdown mirror of related_work.tex
├── paper_structure.md        # Full section outline, status legend, and open decisions
├── dataset_split.csv         # Data split assignments (patient-level)
├── dataset_split.numbers     # Numbers spreadsheet version of the above
└── RelatedWorks/             # Reference PDFs
    └── ASBTi/mmc6.pdf        # Ghallab et al., JHEP Reports 2025
```

## LaTeX Workflow

The submission driver file is `bmvc_review.tex` (review copy, has `\bmvcreviewcopy{??}`) and `bmvc_final.tex` (camera-ready, has that line commented out). Both `\input{}` the same section files.

Standard compile sequence:

```bash
pdflatex bmvc_review      # or bmvc_final
bibtex bmvc_review
pdflatex bmvc_review
pdflatex bmvc_review
```

Or with `latexmk`:

```bash
latexmk -pdf bmvc_review
```

The bibliography style is set automatically by `bmvc2k.cls` (uses `bmvc2k.bst`). Do **not** add a `\bibliographystyle{}` call — just `\bibliography{references}`.

**Papeeria:** set `bmvc_review.tex` as the main document in project settings.

## Writing Conventions

Conventions used consistently across the `.tex` files — maintain these when adding new content:

| Element | Convention |
|---------|-----------|
| Author list shorthand | `\etal` (defined as a macro, not `et al.`) |
| Stain translation arrow | `H\&E~$\to$~SR` (tilde non-breaking space, math arrow) |
| Unverified citations | `[TBC]` comment on the entry in `references.bib` |
| Section labels | `\label{sec:name}` |
| Figure labels | `\label{fig:name}` |
| Table labels | `\label{tab:name}` |
| Equation labels | `\label{eq:name}` |
| Tile dimensions | `$256{\times}256$\,pixel` |
| Parameter counts | `${\sim}10$~million parameters` (avoid `M` for million — collides with M for Medium generator size) |

## Section Status

See `paper_structure.md` for detailed per-section outlines. Quick status:

| Section | File | Status |
|---------|------|--------|
| Abstract | `bmvc_review.tex` | ⬜ (written last) |
| 1 — Introduction | `introduction.tex` | ✅ |
| 2 — Related Work | `related_work.tex` | ✅ |
| 3 — Dataset | `dataset.tex` | ✅ (some cohort placeholders remain) |
| 4 — Models | `models_section.tex` | ✅ |
| 5 — Experiments | `experiments.tex` (wrapper) | — |
| 5.1 — Training and Inference | `experimental_setup.tex` | ✅ |
| 5.2 — Evaluation Metrics | `evaluation_metrics.tex` | ✅ |
| 5.3 — Results: Scaling Study | `results.tex` | ⬜ stub |
| 6 — Epistemic Uncertainty | `uncertainty_analysis.tex` | 🔄 §6.1–6.2 written; §6.3–6.4 TODO |
| 7 — Discussion | `discussion.tex` | ⬜ stub |
| 8 — Conclusion | `conclusion.tex` | ⬜ stub |

## Open Decisions

Only one decision remains unresolved (see `paper_structure.md` §4.5):

| # | Decision | Status |
|---|----------|--------|
| 4 | Fibrosis stage stratification in data splits — stratified vs. random | ❓ open |

Resolved decisions: CPA metric (MAE, WSI-level paired; Wasserstein-1 superseded — H&E and SR are co-registered from same tissue block), model selection for uncertainty (Option B: best-per-family by CPA MAE rank), SR segmentation architecture (off-the-shelf nnU-Net v2).

## Models Evaluated

| Key | Model | arXiv |
|-----|-------|-------|
| CycleGAN | Cycle-consistent adversarial networks | 1703.10593 |
| UNIT | Shared VAE latent space | 1703.00848 |
| MUNIT | Content/style disentanglement + AdaIN | 1804.04732 |
| DCLGAN | CycleGAN + dual patch-level InfoNCE | 2104.07689 |
| UVCGAN | UNet + ViT bottleneck + cycle-consistency | 2203.02557 |
| CycleDiffusion | Cycle-consistent diffusion via shared noise space (DDPM/DDIM) | 2210.05559 |

Reference PDFs for all six models are in `RelatedWorks/`.

## Bibliography Known Issues

- **`[TBC]` entries** in `references.bib` need first-author verification before submission.
