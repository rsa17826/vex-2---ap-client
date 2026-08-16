const KIND_COLORS = {
  move: "#3b82f6",
  level: "#8b5cf6",
  flag: "#f59e0b",
  star: "#eab308",
  achievement: "#10b981",
}

function kindOf(token) {
  return token.split(":")[0]
}

function requiresSatisfied(requires, owned) {
  if (requires.length === 0) return true
  return requires.some((group) =>
    group.every((tok) => owned.has(tok)),
  )
}

// Every receive token is checked as its own AP location, named
// "<room> - <token>" (matches the convention used by newItem() elsewhere).
function locationIdFor(room, token) {
  try {
    return window.ap.slotData.AP_LOCATION_IDS[`${room} - ${token}`]
  } catch (e) {
    return undefined
  }
}

function isChecked(room, token) {
  const id = locationIdFor(room, token)
  if (id === undefined) return false
  try {
    return window.ap.checkedLocations.includes(id)
  } catch (e) {
    return false
  }
}

// Items you've actually received (moves/levels), which is what satisfies
// "requires". Built from the live item names via ap.itemIdToName.
function ownedItems() {
  const owned = new Set()
  try {
    const idToName = window.ap.itemIdToName[window.ap.game]
    const received =
      window.ap.receivedItems || window.ap.itemsReceived || []
    received.forEach((it) => {
      const id = typeof it === "object" ? it.item : it
      const name = idToName[id]
      if (name) owned.add(name)
    })
  } catch (e) {}
  // fall back to / merge with in-game truth if the AP item log isn't available
  try {
    ;(window.moves || []).forEach((m) =>
      owned.add("move:" + m.replace("move:", "").trim()),
    )
  } catch (e) {}
  try {
    ;(window.unlockedActs || new Set()).forEach((i) =>
      owned.add("level:stage" + i),
    )
  } catch (e) {}
  // flags aren't items; treat a flag as "owned" once any of its associated
  // checks are done, by scanning all receive lists for it.
  PROG.forEach((n) => {
    n.receive.forEach((t) => {
      if (kindOf(t) === "flag" && isChecked(n.room, t)) owned.add(t)
    })
  })
  return owned
}

function chip(token) {
  const kind = kindOf(token)
  const color = KIND_COLORS[kind] || "#6b7280"
  return newelem(
    "span",
    {
      style: {
        display: "inline-block",
        padding: "2px 8px",
        borderRadius: "999px",
        fontSize: "12px",
        fontWeight: "500",
        margin: "2px 4px 2px 0",
        background: color + "1a",
        color: color,
        border: "1px solid " + color + "40",
        whiteSpace: "nowrap",
      },
    },
    [token],
  )
}

const state = { visible: false }
let root = null

function buildOverlay() {
  root = newelem("div", {
    id: "progressionOverlay",
    style: {
      position: "fixed",
      top: "0",
      right: "0",
      width: "420px",
      maxWidth: "95vw",
      height: "100vh",
      overflowY: "auto",
      background: "#111827",
      borderLeft: "1px solid #1f2937",
      boxShadow: "-4px 0 24px rgba(0,0,0,0.5)",
      zIndex: "999999",
      fontFamily:
        "-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
      color: "#f3f4f6",
      padding: "16px",
      boxSizing: "border-box",
      display: "none",
    },
  })
  document.body.appendChild(root)
}

function render() {
  if (!root) return
  root.innerHTML = ""
  root.style.display = state.visible ? "block" : "none"
  if (!state.visible) return

  const owned = ownedItems()

  // Build the list of not-yet-checked, currently-satisfiable receive tokens.
  const rows = []
  PROG.forEach((node) => {
    if (!requiresSatisfied(node.requires, owned)) return
    node.receive.forEach((token) => {
      if (kindOf(token) == "flag") return
      if (!isChecked(node.room, token)) {
        if (node.room != "hub" && !owned.has(`level:${node.room}`)) return
        rows.push({ room: node.room, token })
      }
    })
  })

  root.appendChild(
    newelem(
      "div",
      {
        style: {
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          marginBottom: "4px",
        },
      },
      [
        newelem(
          "h1",
          {
            style: {
              fontSize: "18px",
              fontWeight: "700",
              margin: "0",
            },
          },
          ["Obtainable Now"],
        ),
        newelem(
          "span",
          { style: { fontSize: "11px", color: "#6b7280" } },
          ["[Tab] to close"],
        ),
      ],
    ),
  )
  root.appendChild(
    newelem(
      "p",
      {
        style: {
          color: "#9ca3af",
          fontSize: "13px",
          margin: "0 0 14px 0",
        },
      },
      [`${rows.length} things you can go get right now`],
    ),
  )

  if (rows.length === 0) {
    return
  }

  const list = newelem("div", {
    style: { display: "flex", flexDirection: "column", gap: "8px" },
  })
  rows.forEach(({ room, token }) => {
    const card = newelem("div", {
      style: {
        border: "1px solid #10b98155",
        background: "#064e3b33",
        borderRadius: "8px",
        padding: "8px 10px",
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        gap: "8px",
      },
    })
    card.appendChild(
      newelem(
        "span",
        {
          style: {
            fontSize: "11px",
            fontWeight: "700",
            background: "#374151",
            color: "#e5e7eb",
            padding: "2px 7px",
            borderRadius: "5px",
            flexShrink: "0",
          },
        },
        [room],
      ),
    )
    card.appendChild(chip(token))
    list.appendChild(card)
  })
  root.appendChild(list)
}

function toggleOverlay() {
  state.visible = !state.visible
  render()
}

function init() {
  buildOverlay()
  window.addEventListener("keydown", (e) => {
    if (e.key === "Tab") {
      const tag =
        document.activeElement && document.activeElement.tagName
      if (tag === "INPUT" || tag === "TEXTAREA") return
      e.preventDefault()
      toggleOverlay()
    }
  })
  window.progressionOverlay = { toggle: toggleOverlay, render }
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init)
} else {
  init()
}
