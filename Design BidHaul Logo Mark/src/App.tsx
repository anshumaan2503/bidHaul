export default function App() {
  // Ring geometry
  // Center: (280, 280), outer r=195, inner r=157, ring stroke ~38px
  // Gap: 30° from 300° to 330° (upper-right), arrowhead at gap end (300°)
  //
  // Key points (angles in SVG coords: 0=right, CW):
  //   330° outer: (280+195·cos330°, 280+195·sin330°) = (448.9, 182.5)
  //   300° outer: (280+195·cos300°, 280+195·sin300°) = (377.5, 111.1)
  //   330° inner: (280+157·cos330°, 280+157·sin330°) = (415.9, 201.5)
  //   300° inner: (280+157·cos300°, 280+157·sin300°) = (358.5, 144.1)
  //   Arrowhead tip (r=176 at 300°): (368, 127.6)
  //   CW tangent at 300°: (-sin300°, cos300°) = (0.866, 0.5) → 30° below horizontal

  return (
    <div
      style={{
        width: "100vw",
        height: "100vh",
        background: "#070C18",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <svg
        viewBox="0 0 560 560"
        xmlns="http://www.w3.org/2000/svg"
        style={{ width: "min(92vw, 92vh)", height: "min(92vw, 92vh)" }}
      >
        <defs>
          {/* Shared gradient — fuses all elements visually */}
          <linearGradient
            id="g"
            x1="60"
            y1="60"
            x2="500"
            y2="500"
            gradientUnits="userSpaceOnUse"
          >
            <stop offset="0%" stopColor="#00F0FF" />
            <stop offset="100%" stopColor="#1D6FFF" />
          </linearGradient>

          {/* Ambient haze behind mark */}
          <radialGradient id="haze" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stopColor="#1D6FFF" stopOpacity="0.18" />
            <stop offset="70%" stopColor="#00F0FF" stopOpacity="0.04" />
            <stop offset="100%" stopColor="#00F0FF" stopOpacity="0" />
          </radialGradient>

          {/* Crisp glow — preserves edge clarity */}
          <filter id="glow" x="-28%" y="-28%" width="156%" height="156%">
            <feGaussianBlur in="SourceGraphic" stdDeviation="9" result="b" />
            <feColorMatrix
              in="b"
              type="matrix"
              values="0 0 0 0 0  0 0.46 0 0 0.72  0 0 1 0 1  0 0 0 0.45 0"
              result="cb"
            />
            <feMerge>
              <feMergeNode in="cb" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          {/* Hairline inner-edge highlight for the ring */}
          <filter id="rimLight" x="-5%" y="-5%" width="110%" height="110%">
            <feGaussianBlur in="SourceGraphic" stdDeviation="1.5" result="b" />
            <feMerge>
              <feMergeNode in="b" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>

        {/* ── Background ── */}
        <rect width="560" height="560" fill="#070C18" />
        <circle cx="280" cy="280" r="240" fill="url(#haze)" />

        {/* ════════════════════════════════════════
            UNIFIED MARK: ring + B share one gradient
            so overlapping regions are seamlessly fused
        ════════════════════════════════════════ */}
        <g fill="url(#g)" filter="url(#glow)">

          {/* ── LOOP RING ──
              Outer arc CW (330° → 300°, 330° of travel, large-arc=1)
              line across gap end to inner
              Inner arc CCW back (300° → 330°, large-arc=1)
              close with Z (gap start edge)
          ── */}
          <path
            d={`
              M 448.9,182.5
              A 195,195 0 1 1 377.5,111.1
              L 358.5,144.1
              A 157,157 0 1 0 415.9,201.5
              Z
            `}
          />

          {/* ── ARROWHEAD ──
              Sits at gap end (300°), pointing 30° CW along ring tangent.
              Tip at mid-ring radius 176 at 300°: (368, 127.6).
              Polygon is right-pointing; rotate(30) aligns to tangent.
          ── */}
          <polygon
            transform="translate(368,128) rotate(30)"
            points="22,0 -13,-15 -7,0 -13,15"
          />

          {/* ── BOLD GEOMETRIC B ──
              Outer contour CW + two inner bowl holes = even-odd.
              B spans x 152–400, y 172–388 (visual center ≈ ring center 280,280).

              Outer:
                top-left (152,172) → top bar → upper bowl arc (CW) →
                short middle step → lower bowl arc (CW) → bottom bar → close

              Inner holes (CW, even-odd makes them transparent):
                upper bowl void
                lower bowl void

              Arc anatomy (same-x endpoints → pure ellipse half):
                A rx,ry 0 0 1 x2,y2  sweep=1 (CW) = bulge right ✓
              Hole arcs also sweep=1; even-odd handles transparency.
          ── */}
          <path
            fillRule="evenodd"
            d={`
              M 152,172
              L 274,172
              A 100,53 0 0 1 274,278
              L 290,278
              A 114,56 0 0 1 290,390
              L 152,390
              Z

              M 200,198
              L 261,198
              A 63,31 0 0 1 261,260
              L 200,260
              Z

              M 200,298
              L 276,298
              A 77,32 0 0 1 276,362
              L 200,362
              Z
            `}
          />
        </g>

        {/* ── Hairline inner rim — adds glass-edge depth without noise ── */}
        <ellipse
          cx="280"
          cy="280"
          rx="157"
          ry="157"
          fill="none"
          stroke="white"
          strokeWidth="0.7"
          strokeOpacity="0.18"
          filter="url(#rimLight)"
        />
      </svg>
    </div>
  )
}
