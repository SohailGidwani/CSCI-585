# CSCI 585, Database Systems

USC, Fall 2026. Sohail Gidwani (sgidwani@usc.edu).

My coursework for CSCI 585. One folder per assignment, each one self contained
with its own README, the files I submitted, and a script that rebuilds the
submission zip.

## Assignments

| | what it is | final artefact |
|---|---|---|
| [HW1](HW1/) | ER diagram for a dental practice, built by prompting LLMs | [diagram/ER-diagram-final.png](HW1/diagram/ER-diagram-final.png) |
| [HW2](HW2/) | SQL for five questions about the same practice, written by Kimi K3 and run on TiDB Cloud | [HW2_SohailHareshGidwani/](HW2/HW2_SohailHareshGidwani/) |

HW1 in one line: I ran the same ER diagram prompt through four models, llama3 and
gemma2:2b locally through ollama and then GPT-6 Astra Max and Gemini 3.6, compared
what came back, and submitted the GPT-6 one. The writeup with all four diagrams
rendered is in [HW1/README.md](HW1/README.md).

HW2 in one line: I gave Kimi K3 the HW1 dental practice description, had it write
a MySQL schema and then SQL for five questions (the loan, expiring licenses,
procedures last year, insurance companies, upcoming visits), and ran all of it
unedited on TiDB Cloud against made-up data built so every answer could be
checked. All ten of Kimi's queries came out right. The writeup with every query,
screenshot and result is in [HW2/README.md](HW2/README.md).

## How this repo is organised

Each assignment folder holds everything for that assignment. Nothing is shared
between them yet, and if something ends up being shared later it can move up to
the root then.

The submission zips are not committed. Everything that goes into one is tracked
here anyway, so the zip is just those files repackaged for Brightspace. For HW2
the zip's contents are committed as one folder, `HW2/HW2_SohailHareshGidwani/`,
which is exactly what unzips.

Assignment PDFs and anything mirrored from bytes.usc.edu are not committed either.
Those are the professor's material, so I keep local copies but do not republish
them. That is why you will see a `spec/` folder referenced in HW1 that is not in
this repo, and why `HW2/prompts/` starts at `0b`: prompt 0 was the HW1
description pasted verbatim.
