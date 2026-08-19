---
name: writing
description: "Use whenever writing any non-code prose: documentation, README or wiki pages, code comments, docstrings, descriptions, commit messages, PR descriptions, error messages, or config text. Trigger on any task that produces words a human will read, even when the user never asks for writing help. Loads the communication skill for voice and grammar, and adds rules for code-adjacent writing."
---

# Writing

## First, load the communication skill

Before drafting, invoke `communication:communication` with the Skill tool and apply all of it: voice, grammar (British/SA spelling, Oxford comma, no em-dashes), and the AI-tell, jargon, and filler lists.

If it isn't installed, tell the user it's a dependency, then write in the same spirit: lead with the point, short sentences, active voice, plain words.

## Per artefact

Rules for what the communication skill doesn't cover:

**Documentation (README, wiki, docs/).** Use headings, lead each section with its point, and write for a reader with no context. State each fact once, where a reader would look for it, and link rather than duplicate.

**Code comments.** State only what the code can't show: a constraint, a non-obvious reason, a warning. Never narrate the next line or address the reviewer ("fixed the bug here"). Match the surrounding code's comment density and idiom.

**Docstrings and descriptions.** One active-voice sentence saying what the thing does: "Validates the voucher", not "This function is responsible for...". Add parameters, return value, and errors only where the signature doesn't make them obvious.

**Error messages and UI text.** Say what went wrong in the user's terms and what to do next: "Voucher expired on 12 March. Request a new one from the account page", not "An unexpected error has occurred".

## Final check

Run the communication skill's final check, plus one question: does every comment, docstring, and error message earn its place, or is it narrating the obvious?
