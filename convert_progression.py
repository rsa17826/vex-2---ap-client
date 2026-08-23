import json

from _progression import PROG

if PROG:
  js_data = json.dumps(PROG)
  with open("progression.js", "w") as f:
    _ = f.write(f"// prettier-ignore\nconst PROG = {js_data}\n")

  print("Wrote progression.js")
