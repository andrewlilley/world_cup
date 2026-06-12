# Task: Update World Cup tipping tournament code from 2022 to 2026 format

## Context

This folder contains a World Cup tipping competition. The 2022 edition's scoring and analysis code lives in `scores.Rmd` (R / tidyverse). It reads participants' tipping entries, computes points per the 2022 scoring rules, and produces the analysis and graphs.

A new competition has been set up for the 2026 World Cup. An example participant entry is in this folder as `world_cup_2026_andrew` (an Excel workbook). The new points system is documented in the sheet named `scoring_rules` within that workbook.

## Objective

Make the existing code run correctly for the 2026 tournament format and the new scoring system. **That is the entire scope.** This is a mechanical port, not an improvement exercise.

## Strict scope constraints

- **Zero new content in the output.** Do not add any text, commentary, headings, explanatory prose, or new graphs to the Rmd output. The knitted HTML should contain only what the 2022 version's structure produces, adapted to 2026 data.
- **Zero aesthetic changes.** Do not alter the HTML output format, themes, ggplot styling, colours, labels' style, table formatting, or any visual element. If a 2022 graph or table needs structural adaptation purely because the format changed (e.g. 12 groups instead of 8, an extra knockout round), make the minimum change required for it to render correctly, preserving the existing aesthetic exactly.
- **Do not refactor, restructure, rename, or "clean up"** code that already works. Touch only what the format change forces you to touch.
- **Do not delete any existing analysis section or graph.** If one cannot be made to work under the new format without a design decision, leave it intact, comment it out if necessary to knit, and bring the decision to me (see below).

## Decisions are mine, not yours

Do not make interpretive choices or assumptions. Whenever you hit anything ambiguous, **stop and ask me** before implementing. This includes, at minimum:

- Any ambiguity in the `scoring_rules` sheet (e.g. whether a knockout tip scores if the team reaches that round by a different path than tipped, exact-score vs correct-result distinctions, how third-place qualifier tips are scored).
- Any mismatch between the structure of the 2026 entry workbook and what the 2022 code expects, where more than one mapping is plausible.
- How the round of 32 and third-place qualification should flow through any existing stage-based logic, if it isn't unambiguous.
- Anything about results entry for 2026 if the 2022 mechanism doesn't carry over cleanly.

Present each such question to me with the options as you see them. Do not pick a default and flag it afterwards — ask first.

## Required first steps — before writing any code

1. Read `scores.Rmd` in full and understand how entries are ingested, how each scoring component is computed, and what each output section produces.
2. Open the `world_cup_2026_andrew` workbook with `readxl` and inspect **every** sheet, printing sheet names and full contents. Do not assume the 2026 entry layout matches the 2022 one.
3. Read the `scoring_rules` sheet carefully. Implement scoring from this sheet only — do **not** carry over hardcoded 2022 point values. Any ambiguity goes to me per the above.

## Known format changes (verify against the workbook, don't assume)

- 48 teams in 12 groups (A–L) of 4; 104 matches total.
- New knockout round: Round of 32. Qualification is top 2 per group plus the 8 best third-placed teams.
- Knockout rounds: R32, R16, QF, SF, third-place playoff, Final.
- Any logic assuming 8 groups / 32 teams / 64 matches must be generalised — minimally.

## Implementation requirements

- Keep it as an Rmd that knits end-to-end with the same output format as before.
- Ingestion should handle multiple participant files of the same format as `world_cup_2026_andrew` (e.g. all files matching `world_cup_2026_*`), since more entries will be added.
- Carry over the 2022 mechanism for entering actual results, updated to the 2026 match list; the Rmd should knit with partial results as the tournament progresses (if the 2022 version didn't support this, ask me whether to add it rather than assuming).

## Verification

- Knit the Rmd successfully with the andrew entry.
- Manually compute the points for a handful of tips from the andrew entry (a group match, a third-place qualifier, a knockout tip) and confirm the code agrees. Report this check to me in chat — do not put it in the Rmd output.

## Output

- The updated `scores.Rmd` (back up the original as `scores_2022.Rmd` first).
- In chat only: a list of what was changed and the list of decisions awaiting my answer, if any remain.

Do not ask permission to read files in this folder — read whatever you need. Do ask before deleting anything.
