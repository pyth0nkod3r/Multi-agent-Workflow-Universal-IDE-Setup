# Knowledge: Resume / CV Optimization, Tailoring & ATS Resilience (EaseApply)

Distilled from `docs/RESEARCH-cv-optimization.md` (9 Oct 2026).

## Key Principles & Architectural Invariants
1. **ATS Linear Text Order**: Single-column linear text flow in LaTeX templates prevents text interleaving during automated parsing (Gan & Mori, NLDB 2023, arXiv:2209.09450).
2. **Canonical Lexical Headings**: Standard section titles (`Summary`, `Skills`, `Experience`, `Education`, `Languages`) avoid parser classification penalties (Wilson & Caliskan, AAAI/ACM 2024, arXiv:2407.20371).
3. **No-Hallucination Grounding**: Metric quantification is strictly constrained to candidate profile inputs; ungrounded generative statistics are rejected by `grounding.critique_draft` (Nguyen et al., IEEE BigDataService 2026, arXiv:2604.25665; Wilson et al., ACM FAccT 2026, arXiv:2606.22213).
4. **TeX Sanitization & Multi-Engine Resilience**: Input strings must be pre-escaped via `services/latex.py::tex_escape` (`%`, `&`, `_`, `$`, `#`, `^`, `~`, `{`, `}`) and compiled through a fallback chain (XeLaTeX -> LuaLaTeX -> pdfLaTeX -> Tectonic).
5. **Market Adaptation**: DACH (`de`/`ch`) applications mandate `MM/JJJJ` date format and formal German section titles; Irish/UK applications require 1-2 pages without personal metadata; Nigerian tech applications highlight verified technical proofs.

## Future Adoption Priorities
1. Automated corrective repair turn in `generate_cv` when ungrounded claims are flagged by `grounding.py`.
2. Market-aware template date formatting and German section heading selection.
3. Google XYZ accomplishment formula prompting ("Accomplished [X] by doing [Z]").
4. Log parsing in `compile_tex` for automated error diagnostics.
5. Post-compilation plain-text parsing verification via `pdftotext`.
