# CSCI 585, Database Systems

USC, Fall 2026. Sohail Gidwani (sgidwani@usc.edu).

My coursework for CSCI 585. One folder per assignment, each one self contained
with its own README, the files I submitted, and a script that rebuilds the
submission zip.

## Assignments

| | what it is | final artefact |
|---|---|---|
| [HW1](HW1/) | ER diagram for a dental practice, built by prompting LLMs | [diagram/ER-diagram-final.png](HW1/diagram/ER-diagram-final.png) |

HW1 in one line: I ran the same ER diagram prompt through four models, llama3 and
gemma2:2b locally through ollama and then GPT-6 Astra Max and Gemini 3.6, compared
what came back, and submitted the GPT-6 one. The writeup with all four diagrams
rendered is in [HW1/README.md](HW1/README.md).

## How this repo is organised

Each assignment folder holds everything for that assignment. Nothing is shared
between them yet, and if something ends up being shared later it can move up to
the root then.

The submission zips are not committed. Everything that goes into one is tracked
here anyway, so the zip is just those files repackaged for Brightspace.

Assignment PDFs and anything mirrored from bytes.usc.edu are not committed either.
Those are the professor's material, so I keep local copies but do not republish
them. That is why you will see a `spec/` folder referenced in HW1 that is not in
this repo.
