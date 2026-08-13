# Writing Style & Instructions for Claude

This file records the writing conventions, style preferences, and editorial rules established for this manuscript. Follow these in all future editing sessions.

---

## Style Reference

The target prose style is modelled on:
> Siddiqui et al., *Uncertainty Estimation in Instance Segmentation With Star-Convex Shapes*, WACV 2024.
> https://openaccess.thecvf.com/content/WACV2024/papers/Siddiqui_Uncertainty_Estimation_in_Instance_Segmentation_With_Star-Convex_Shapes_WACV_2024_paper.pdf

Key characteristics to replicate:
- Mixed sentence lengths (moderate ~15–20 words, occasionally longer for technical detail)
- Clean connective transitions: "However,", "To address this,", "While...", "In response,"
- Definitions introduced via appositives with commas, not em-dashes
- Author names called out directly for key contributions: "Gal et al. [6] proposed..."
- Citations woven naturally at clause or sentence ends, never disruptive
- Cautious hedging where appropriate: "often", "can potentially", "remains underexplored"
- Clear problem → solution structure in the introduction
- Historical progression in related work (foundational → extensions → gap → our work)

---

## Hard Rules

### No em-dashes for parenthetical definitions
**Never** write constructions like:
```
Virtual staining---the computational prediction of a target stain---offers a solution.
Epistemic uncertainty---the component reducible with more data---can be estimated.
```

**Instead**, use one of these natural alternatives depending on context:

| Situation | Replace with |
|-----------|-------------|
| Inline definition | `Virtual staining, which uses deep learning to predict a target stain, offers a solution.` |
| Appositive phrase | `Epistemic uncertainty, the component reducible with more data, can be estimated.` |
| Elaboration after a clause | Split into two sentences, or use a colon: `...through a shared noise space: a source image is first encoded...` |
| Trailing remark | Replace with a comma: `...translation quality, a practically important question given...` |

### No numbered or bulleted contribution lists
Do not use `\begin{enumerate}` for the contributions in the introduction. Write each contribution as a separate paragraph with a clear transition word:
- First paragraph: "First, we introduce..."
- Second paragraph: "Building on this dataset, we conduct..."
- Third paragraph: "To evaluate all N configurations rigorously, we..."
- Final paragraph: "Finally, from the top-performing... To our knowledge, this constitutes the first..."
- Close the last paragraph with the synthesis/impact statement rather than a separate sentence.

### No `\subsection{}` — use `\paragraph{}` instead
Replace subsection headings with `\paragraph{}` leads:
```latex
\paragraph{Topic Title.}
First sentence of the paragraph continues here...
```
This saves vertical space and keeps the section compact. Use `\paragraph{}` (not `\noindent\textbf{}`) throughout: related work topics, training protocol leads, evaluation sub-topics, etc.

### No self-referential epistemic hedges
Strip phrases that hedge about the authors' knowledge rather than the claim itself:

| Forbidden | Preferred |
|-----------|-----------|
| "to our knowledge, no prior work has X" | "no prior work has X" |
| "to the best of our knowledge, this is the first Y" | "this is the first Y" |
| "we believe this is the only Z" | "this is the only Z" |
| "as far as we know" | (delete entirely) |
| "we are not aware of" | (delete entirely) |

State the claim directly. These hedges signal uncertainty about the literature search rather than the underlying claim, which weakens the contribution.

---

## Blind Review Rules

This manuscript is under **double-blind review**. The following phrases must never appear in the submitted text:

| Forbidden phrase | Safe alternative |
|-----------------|-----------------|
| "a dataset collected in-house" | cite the source paper directly: `~\cite{ghallab2025asbt}` |
| "our dataset" (implying we created it) | "the dataset from~\cite{ghallab2025asbt}" |
| "we collected" / "we acquired" (referring to the BDL data) | "as described in~\cite{ghallab2025asbt}" |

The dataset originates from Ghallab et al. (JHEP Reports 2025; `\cite{ghallab2025asbt}`). Always attribute it via citation, not possessive language.

---

## LaTeX Conventions

These are already established in `CLAUDE.md` but repeated here for completeness:

| Element | Convention |
|---------|-----------|
| Author list shorthand | `\etal` macro |
| Stain translation arrow | `H\&E~$\to$~SR` |
| Tile dimensions | `$256{\times}256$\,pixel` |
| Parameter counts | `${\sim}10$~million parameters` (avoid `M` for million — collides with M for Medium generator size) |
| Section labels | `\label{sec:name}` |
| Unverified citations | `% [TBC]` comment on the `.bib` entry |

---

## Paragraph-level Flow Checklist

Before finalising any section, verify:

1. **No em-dashes** in the main text (grep for `---` outside comment lines).
2. **Transitions are explicit** — each paragraph opens with a sentence that connects to the previous one.
3. **No self-identifying language** — no "in-house", "our lab", "we collected" for the BDL dataset.
4. **Citations are placed at the end of the relevant clause**, not mid-sentence unless the author name is called out.
5. **Contributions are prose paragraphs**, not a list.
6. **Section topic leads use `\paragraph{}`**, not `\subsection{}` or `\noindent\textbf{}`.
