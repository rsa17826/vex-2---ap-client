"""
Converts _progression.py's PROG list into JSON and a JS module.

Usage:
    python3 convert_progression.py

Outputs:
    progression.json  - plain JSON array
    progression.js    - `export const PROG = [...]`  (ES module)
                          also writable as `window.PROG = [...]` via --global

"""

import json
import sys
from _progression import PROG


def main():
  # JS output
  js_data = json.dumps(PROG, indent=2)
  with open("progression.js", "w") as f:
    f.write(f"// prettier-ignore\nconst PROG = {js_data};\n")

  print("Wrote progression.js")


if __name__ == "__main__":
  main()
