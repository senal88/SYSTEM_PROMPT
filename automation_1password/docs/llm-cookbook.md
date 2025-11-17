
# 🤖 LLM Interaction Cookbook

This document provides recipes and best practices for interacting with the `automation_1password` project using a Large Language Model (LLM).

## 1. Asking Questions

When asking questions about the project, be as specific as possible. Provide context, such as the file or script you are working with.

**Good Example:**

> "In `scripts/bootstrap/setup-macos-complete.sh`, what is the purpose of the `load-cursor-macos.sh` script?"

**Bad Example:**

> "What does the setup script do?"

## 2. Generating Code

When asking the LLM to generate code, provide a clear and concise description of the desired functionality. Include the following information:

*   **The goal of the script or function:** What should it do?
*   **The inputs and outputs:** What data will it take as input, and what should it produce as output?
*   **The programming language:** (e.g., Bash, Python)
*   **Any constraints or requirements:** (e.g., "must use the `jq` command", "should be idempotent")

**Example Prompt:**

> "Write a Bash script that takes a vault name as input, lists all the items in the vault, and prints the title and ID of each item. The script should use the `op` CLI and `jq` to parse the JSON output."

## 3. Debugging

When you encounter an error, provide the LLM with the following information:

*   **The full error message:** Copy and paste the entire error message, including the stack trace.
*   **The code that caused the error:** Provide the relevant code snippet.
*   **The steps to reproduce the error:** Describe what you were doing when the error occurred.

**Example Prompt:**

> "I'm getting the following error when I run `make setup-macos`:
>
> ```
> ❌ 1Password CLI not found
> ```
>
> I've already installed the 1Password CLI using Homebrew. What could be the problem?"

## 4. Summarizing Content

You can ask the LLM to summarize the content of a file or a directory.

**Example Prompt:**

> "Summarize the `docs/operations/master-plan.md` file."

## 5. Using the Context Index

The project includes a context index in `context/indexes/context_index.jsonl`. This file contains a wealth of information about the project, including documentation, scripts, and more. You can use this file to provide context to the LLM.

**Example Prompt:**

> "Using the information in `context/indexes/context_index.jsonl`, tell me about the project's automation strategy."
