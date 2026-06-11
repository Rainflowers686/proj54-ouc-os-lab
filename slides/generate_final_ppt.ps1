param(
  [string]$Source = "slides/final_ppt.md",
  [string]$Output = "slides/final_defense_ppt.pptx"
)

$ErrorActionPreference = "Stop"

function Rgb {
  param([string]$Hex)
  $h = $Hex.TrimStart("#")
  $r = [Convert]::ToInt32($h.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($h.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($h.Substring(4, 2), 16)
  return $r + ($g * 256) + ($b * 65536)
}

function Section {
  param([string]$Text, [string]$Start, [string]$Stop)
  $opt = [System.Text.RegularExpressions.RegexOptions]::Singleline
  $pattern = [regex]::Escape($Start) + "\s*(.*?)\s*" + [regex]::Escape($Stop)
  $m = [regex]::Match($Text, $pattern, $opt)
  if ($m.Success) { return $m.Groups[1].Value.Trim() }
  return ""
}

function TailSection {
  param([string]$Text, [string]$Start)
  $idx = $Text.IndexOf($Start)
  if ($idx -lt 0) { return "" }
  return $Text.Substring($idx + $Start.Length).Trim()
}

function LinesFromList {
  param([string]$Text)
  $items = @()
  foreach ($line in ($Text -split "`r?`n")) {
    $t = $line.Trim()
    if ($t.StartsWith("- ")) { $items += $t.Substring(2).Trim() }
  }
  return $items
}

function Read-Slides {
  param([string]$Path)
  $content = Get-Content -Path $Path -Raw -Encoding UTF8
  $blocks = [regex]::Split($content, "(?m)^## Slide ") | Select-Object -Skip 1
  $slides = @()
  foreach ($block in $blocks) {
    $parts = $block -split "`r?`n", 2
    $heading = $parts[0].Trim()
    $body = if ($parts.Count -gt 1) { $parts[1] } else { "" }
    $m = [regex]::Match($heading, "^(\d+)\.\s+(.+)$")
    if (-not $m.Success) { throw "Cannot parse slide heading: $heading" }
    $slides += [pscustomobject]@{
      Number = [int]$m.Groups[1].Value
      Title = $m.Groups[2].Value.Trim()
      Key = ((Section $body "**Key message**" "**Bullet content**") -replace "\s+", " ").Trim()
      Bullets = LinesFromList (Section $body "**Bullet content**" "**Visual labels**")
      Labels = LinesFromList (Section $body "**Visual labels**" "**Speaker notes**")
      Notes = TailSection $body "**Speaker notes**"
    }
  }
  if ($slides.Count -ne 16) { throw "Expected 16 slides, found $($slides.Count)" }
  return $slides | Sort-Object Number
}

$C = @{
  Deep = Rgb "061B33"
  Deep2 = Rgb "082846"
  Sea = Rgb "0E3D5D"
  Cyan = Rgb "19D3E6"
  Cyan2 = Rgb "7CE8F2"
  Blue = Rgb "1C6DD0"
  Teal = Rgb "009CA6"
  Green = Rgb "23B26D"
  Amber = Rgb "F5B84B"
  Coral = Rgb "FF6B6B"
  White = Rgb "FFFFFF"
  Ice = Rgb "EEF8FC"
  Fog = Rgb "D7E8F0"
  Ink = Rgb "09243D"
  Muted = Rgb "7F98A9"
}

$SlideW = 960
$SlideH = 540
$msoTrue = -1
$msoFalse = 0
$msoShapeRectangle = 1
$msoShapeRoundedRectangle = 5
$msoTextOrientationHorizontal = 1
$ppLayoutBlank = 12
$ppAlignLeft = 1
$ppAlignCenter = 2
$ppAlignRight = 3

function StyleText {
  param($Shape, [int]$Color, [double]$Size, [bool]$Bold, [int]$Align)
  $r = $Shape.TextFrame.TextRange
  $r.Font.Name = "Microsoft YaHei"
  $r.Font.Size = $Size
  $r.Font.Bold = $(if ($Bold) { $msoTrue } else { $msoFalse })
  $r.Font.Color.RGB = $Color
  $r.ParagraphFormat.Alignment = $Align
}

function Box {
  param(
    $Slide, [string]$Text, [double]$X, [double]$Y, [double]$W, [double]$H,
    [int]$Fill, [int]$Line, [int]$TextColor, [double]$Size = 12,
    [bool]$Bold = $true, [int]$Align = 2, [bool]$Round = $true
  )
  $type = if ($Round) { $msoShapeRoundedRectangle } else { $msoShapeRectangle }
  $s = $Slide.Shapes.AddShape($type, $X, $Y, $W, $H)
  $s.Fill.ForeColor.RGB = $Fill
  $s.Line.ForeColor.RGB = $Line
  $s.Line.Weight = 1.1
  $s.TextFrame.TextRange.Text = $Text
  $s.TextFrame.MarginLeft = 9
  $s.TextFrame.MarginRight = 9
  $s.TextFrame.MarginTop = 6
  $s.TextFrame.MarginBottom = 6
  $s.TextFrame.WordWrap = $msoTrue
  StyleText $s $TextColor $Size $Bold $Align
  return $s
}

function MatrixCell {
  param(
    $Slide, [string]$Value, [double]$X, [double]$Y, [double]$W, [double]$H,
    [int]$Fill, [int]$Line, [int]$TextColor, [double]$Size = 10,
    [bool]$Bold = $true
  )
  $shape = $Slide.Shapes.AddShape($msoShapeRoundedRectangle, $X, $Y, $W, $H)
  $shape.Fill.ForeColor.RGB = $Fill
  $shape.Line.ForeColor.RGB = $Line
  $shape.Line.Weight = 1.0
  $shape.TextFrame.TextRange.Text = ""
  $textY = $Y + [Math]::Max(4, ($H - 16) / 2)
  $textH = [Math]::Max(18, $H - 8)
  Text $Slide $Value ($X + 4) $textY ($W - 8) $textH $TextColor $Size $Bold $ppAlignCenter | Out-Null
  return $shape
}

function Text {
  param(
    $Slide, [string]$Text, [double]$X, [double]$Y, [double]$W, [double]$H,
    [int]$TextColor, [double]$Size = 14, [bool]$Bold = $false, [int]$Align = 1
  )
  $s = $Slide.Shapes.AddTextbox($msoTextOrientationHorizontal, $X, $Y, $W, $H)
  $s.TextFrame.TextRange.Text = $Text
  $s.TextFrame.MarginLeft = 0
  $s.TextFrame.MarginRight = 0
  $s.TextFrame.MarginTop = 0
  $s.TextFrame.MarginBottom = 0
  $s.TextFrame.WordWrap = $msoTrue
  StyleText $s $TextColor $Size $Bold $Align
  return $s
}

function Bar {
  param($Slide, [double]$X, [double]$Y, [double]$W, [double]$H, [int]$Color)
  $s = $Slide.Shapes.AddShape($msoShapeRectangle, $X, $Y, $W, $H)
  $s.Fill.ForeColor.RGB = $Color
  $s.Line.ForeColor.RGB = $Color
  return $s
}

function Line {
  param($Slide, [double]$X, [double]$Y, [double]$W, [double]$H, [int]$Color, [double]$Weight = 2)
  $s = $Slide.Shapes.AddShape($msoShapeRectangle, $X, $Y, $W, $H)
  $s.Fill.ForeColor.RGB = $Color
  $s.Line.ForeColor.RGB = $Color
  $s.Line.Weight = $Weight
  return $s
}

function Add-Notes {
  param($Slide, [string]$Text)
  try {
    $p = $Slide.NotesPage.Shapes.Placeholders(2)
    $p.TextFrame.TextRange.Text = $Text
    StyleText $p $C.Ink 11 $false $ppAlignLeft
  } catch {
    $n = $Slide.NotesPage.Shapes.AddTextbox($msoTextOrientationHorizontal, 50, 110, 620, 300)
    $n.TextFrame.TextRange.Text = $Text
    StyleText $n $C.Ink 11 $false $ppAlignLeft
  }
}

function DarkBackground {
  param($Slide)
  Bar $Slide 0 0 $SlideW $SlideH $C.Deep | Out-Null
  Bar $Slide 0 0 $SlideW 12 $C.Cyan | Out-Null
  Bar $Slide 790 0 170 $SlideH $C.Deep2 | Out-Null
}

function LightBackground {
  param($Slide)
  Bar $Slide 0 0 $SlideW $SlideH $C.Ice | Out-Null
  Bar $Slide 0 0 128 $SlideH $C.Deep | Out-Null
  Bar $Slide 128 0 6 $SlideH $C.Cyan | Out-Null
}

function Header {
  param($Slide, $Data, [bool]$Dark)
  if ($Dark) {
    Text $Slide $Data.Title 52 34 560 40 $C.White 26 $true $ppAlignLeft | Out-Null
    Text $Slide ("{0:D2}" -f $Data.Number) 864 34 46 30 $C.Cyan2 18 $true $ppAlignRight | Out-Null
  } else {
    Text $Slide $Data.Title 158 34 595 40 $C.Ink 25 $true $ppAlignLeft | Out-Null
    Text $Slide ("{0:D2}" -f $Data.Number) 70 36 38 26 $C.Cyan2 17 $true $ppAlignCenter | Out-Null
  }
}

function KeyText {
  param($Slide, $Data, [bool]$Dark, [double]$X, [double]$Y, [double]$W)
  $tc = if ($Dark) { $C.Ice } else { $C.Ink }
  Text $Slide $Data.Key $X $Y $W 58 $tc 15 $false $ppAlignLeft | Out-Null
}

function SmallBullets {
  param($Slide, [array]$Items, [double]$X, [double]$Y, [double]$W, [double]$H, [bool]$Dark, [int]$Max = 4)
  $lines = (($Items | Select-Object -First $Max) | ForEach-Object { "- $_" }) -join "`r"
  $fill = if ($Dark) { $C.Deep2 } else { $C.White }
  $line = if ($Dark) { $C.Sea } else { $C.Fog }
  $text = if ($Dark) { $C.Ice } else { $C.Ink }
  Box $Slide $lines $X $Y $W $H $fill $line $text 11 $false $ppAlignLeft $true | Out-Null
}

function Chips {
  param($Slide, [array]$Items, [double]$X, [double]$Y, [double]$W, [int]$Count, [bool]$Dark)
  $gap = 12
  $cw = ($W - ($Count - 1) * $gap) / $Count
  for ($i = 0; $i -lt $Count; $i++) {
    $fill = @($C.Cyan, $C.Blue, $C.Green, $C.Amber)[$i % 4]
    Box $Slide $Items[$i] ($X + $i * ($cw + $gap)) $Y $cw 58 $fill $fill $C.Ink 13 $true $ppAlignCenter $true | Out-Null
  }
}

function Slide1 {
  param($Slide, $D)
  DarkBackground $Slide
  Text $Slide $D.Labels[0] 70 80 690 58 $C.White 36 $true $ppAlignLeft | Out-Null
  Text $Slide $D.Key 72 150 650 70 $C.Ice 18 $false $ppAlignLeft | Out-Null
  Line $Slide 72 235 560 3 $C.Cyan 1 | Out-Null
  Chips $Slide @($D.Labels[1], $D.Labels[2], $D.Labels[3]) 72 270 590 3 $true
  Box $Slide $D.Labels[4] 720 110 150 58 $C.Deep2 $C.Cyan $C.Cyan2 16 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[5] 720 195 150 58 $C.Deep2 $C.Cyan $C.Cyan2 16 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[6] 720 280 150 58 $C.Green $C.Green $C.Ink 16 $true $ppAlignCenter $true | Out-Null
  Text $Slide $D.Bullets[0] 72 424 560 22 $C.Muted 11 $false $ppAlignLeft | Out-Null
  Text $Slide $D.Bullets[1] 72 452 560 22 $C.Muted 11 $false $ppAlignLeft | Out-Null
}

function Slide2 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 660
  $x = 164
  $cards = @(
    @($D.Labels[0], @($D.Labels[1], $D.Labels[2]), $C.Cyan),
    @($D.Labels[3], @($D.Labels[4], $D.Labels[5]), $C.Blue),
    @($D.Labels[6], @($D.Labels[7], $D.Labels[8], $D.Labels[9]), $C.Green)
  )
  for ($i = 0; $i -lt $cards.Count; $i++) {
    $cx = $x + $i * 246
    Box $Slide $cards[$i][0] $cx 185 205 38 $C.Deep $C.Deep $C.White 15 $true $ppAlignCenter $true | Out-Null
    $body = ($cards[$i][1] -join "`r")
    Box $Slide $body $cx 235 205 130 $C.White $cards[$i][2] $C.Ink 14 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide $D.Bullets[3] 228 415 555 48 $C.Deep $C.Cyan $C.White 14 $true $ppAlignCenter $true | Out-Null
}

function Slide3 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  for ($i = 0; $i -lt 4; $i++) {
    Box $Slide $D.Labels[$i] (72 + $i * 142) 178 112 48 $C.Sea $C.Cyan $C.White 15 $true $ppAlignCenter $true | Out-Null
    Box $Slide $D.Bullets[$i] (72 + $i * 142) 242 112 86 $C.Deep2 $C.Sea $C.Ice 9.5 $false $ppAlignCenter $true | Out-Null
  }
  $flow = $D.Labels[4..8]
  for ($i = 0; $i -lt $flow.Count; $i++) {
    Box $Slide $flow[$i] (92 + $i * 118) 396 92 42 $(if ($i -eq 4) { $C.Green } else { $C.Blue }) $C.Cyan $(if ($i -eq 4) { $C.Ink } else { $C.White }) 11 $true $ppAlignCenter $true | Out-Null
    if ($i -lt $flow.Count - 1) { Text $Slide ">" (188 + $i * 118) 403 22 20 $C.Cyan2 18 $true $ppAlignCenter | Out-Null }
  }
}

function Slide4 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  Box $Slide $D.Labels[4] 412 225 150 80 $C.Deep $C.Cyan $C.White 18 $true $ppAlignCenter $true | Out-Null
  $positions = @(@(190,160),@(632,160),@(190,352),@(632,352))
  for ($i = 0; $i -lt 4; $i++) {
    $p = $positions[$i]
    Box $Slide $D.Labels[$i] $p[0] $p[1] 130 36 $C.Cyan $C.Cyan $C.Ink 15 $true $ppAlignCenter $true | Out-Null
    Box $Slide $D.Bullets[$i] $p[0] ($p[1] + 46) 160 70 $C.White $C.Fog $C.Ink 10.5 $false $ppAlignCenter $true | Out-Null
  }
}

function Slide5 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  $nodes = $D.Labels[0..5]
  for ($i = 0; $i -lt $nodes.Count; $i++) {
    $x = 70 + $i * 132
    $y = if ($i % 2 -eq 0) { 238 } else { 304 }
    $fill = if ($i -eq 5) { $C.Green } elseif ($i -eq 2) { $C.Cyan } else { $C.Blue }
    $tc = if (($fill -eq $C.Green) -or ($fill -eq $C.Cyan)) { $C.Ink } else { $C.White }
    Box $Slide $nodes[$i] $x $y 110 52 $fill $fill $tc 11 $true $ppAlignCenter $true | Out-Null
    if ($i -lt $nodes.Count - 1) { Text $Slide ">" ($x + 112) ($y + 14) 24 20 $C.Cyan2 18 $true $ppAlignCenter | Out-Null }
  }
  Box $Slide ($D.Labels[6] + "`r" + $D.Labels[7]) 662 395 190 58 $C.Deep2 $C.Cyan $C.Ice 12 $true $ppAlignCenter $true | Out-Null
}

function Slide6 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  $x0 = 165; $y0 = 160
  $widths = @(100, 220, 282)
  $headers = $D.Labels[0..2]
  $offset = 0
  for ($col = 0; $col -lt 3; $col++) {
    MatrixCell $Slide $headers[$col] ($x0 + $offset) $y0 $widths[$col] 40 $C.Deep $C.Deep $C.White 10 $true | Out-Null
    $offset += $widths[$col] + 10
  }
  for ($r = 0; $r -lt $D.Bullets.Count; $r++) {
    $parts = $D.Bullets[$r] -split "\|"
    $offset = 0
    for ($col = 0; $col -lt 3; $col++) {
      $fill = if ($r -eq 5) { $C.Cyan2 } elseif ($col -eq 0) { $C.Sea } else { $C.White }
      $tc = if (($fill -eq $C.Sea) -or ($fill -eq $C.Deep)) { $C.White } else { $C.Ink }
      MatrixCell $Slide $parts[$col].Trim() ($x0 + $offset) ($y0 + 52 + $r * 43) $widths[$col] 36 $fill $C.Fog $tc 8.5 $true | Out-Null
      $offset += $widths[$col] + 10
    }
  }
}

function Slide7 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  $path = $D.Labels[0..4]
  for ($i = 0; $i -lt $path.Count; $i++) {
    Box $Slide $path[$i] (168 + $i * 112) 174 88 42 $(if ($i -eq 0) { $C.Cyan } else { $C.Deep }) $(if ($i -eq 0) { $C.Cyan } else { $C.Deep }) $(if ($i -eq 0) { $C.Ink } else { $C.White }) 11 $true $ppAlignCenter $true | Out-Null
    if ($i -lt $path.Count - 1) { Text $Slide ">" (258 + $i * 112) 183 24 22 $C.Blue 18 $true $ppAlignCenter | Out-Null }
  }
  Box $Slide $D.Labels[5] 230 300 160 38 $C.Sea $C.Sea $C.White 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Bullets[3] 210 350 200 58 $C.White $C.Fog $C.Ink 11 $false $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[6] 520 312 210 70 $C.Cyan2 $C.Cyan2 $C.Ink 14 $true $ppAlignCenter $true | Out-Null
}

function Slide8 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  Box $Slide $D.Labels[0] 90 170 165 34 $C.Cyan $C.Cyan $C.Ink 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[1] 96 222 150 70 $C.Green $C.Green $C.Ink 15 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[2] 330 170 165 34 $C.Cyan $C.Cyan $C.Ink 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[3] 338 222 150 45 $C.Sea $C.Sea $C.White 12 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[4] 338 284 150 60 $C.Blue $C.Blue $C.White 12 $true $ppAlignCenter $true | Out-Null
  $copy = $D.Labels[5..7]
  for ($i = 0; $i -lt $copy.Count; $i++) {
    Box $Slide $copy[$i] (575 + $i * 96) 244 78 44 $(if ($i -eq 2) { $C.Green } else { $C.Deep2 }) $C.Cyan $(if ($i -eq 2) { $C.Ink } else { $C.Ice }) 10 $true $ppAlignCenter $true | Out-Null
    if ($i -lt $copy.Count - 1) { Text $Slide ">" (655 + $i * 96) 252 20 20 $C.Cyan2 16 $true $ppAlignCenter | Out-Null }
  }
  Box $Slide $D.Bullets[4] 168 410 520 46 $C.Deep2 $C.Sea $C.Ice 12 $true $ppAlignCenter $true | Out-Null
}

function Slide9 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  Box $Slide ($D.Labels[0] + "`r" + $D.Labels[1]) 190 205 150 90 $C.Blue $C.Blue $C.White 13 $true $ppAlignCenter $true | Out-Null
  Text $Slide ">" 360 230 30 28 $C.Blue 24 $true $ppAlignCenter | Out-Null
  Box $Slide $D.Labels[2] 410 205 150 90 $C.Deep $C.Deep $C.White 15 $true $ppAlignCenter $true | Out-Null
  Text $Slide ">" 580 230 30 28 $C.Blue 24 $true $ppAlignCenter | Out-Null
  Box $Slide $D.Labels[3] 628 205 170 90 $C.Cyan $C.Cyan $C.Ink 15 $true $ppAlignCenter $true | Out-Null
  Chips $Slide $D.Labels[4..6] 228 350 520 3 $false
  Box $Slide $D.Bullets[4] 235 438 500 42 $C.White $C.Fog $C.Ink 11 $false $ppAlignCenter $true | Out-Null
}

function Slide10 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  $steps = $D.Labels[0..6]
  for ($i = 0; $i -lt $steps.Count; $i++) {
    $fill = if ($i -eq 6) { $C.Green } elseif ($i -eq 4) { $C.Cyan } else { $C.Blue }
    $tc = if (($fill -eq $C.Green) -or ($fill -eq $C.Cyan)) { $C.Ink } else { $C.White }
    Box $Slide $steps[$i] 120 (154 + $i * 43) 230 30 $fill $fill $tc 11 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide $D.Labels[7] 540 245 200 95 $C.Amber $C.Amber $C.Ink 18 $true $ppAlignCenter $true | Out-Null
  SmallBullets $Slide $D.Bullets 506 366 280 80 $true 3
}

function Slide11 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  Box $Slide $D.Labels[0] 420 235 145 64 $C.Cyan $C.Cyan $C.Ink 20 $true $ppAlignCenter $true | Out-Null
  $items = @(
    [pscustomobject]@{ Label = $D.Labels[1]; X = 210; Y = 150 },
    [pscustomobject]@{ Label = $D.Labels[2]; X = 650; Y = 150 },
    [pscustomobject]@{ Label = $D.Labels[3]; X = 210; Y = 360 },
    [pscustomobject]@{ Label = $D.Labels[4]; X = 650; Y = 360 },
    [pscustomobject]@{ Label = ($D.Labels[5] + "`r" + $D.Labels[6]); X = 420; Y = 430 }
  )
  foreach ($it in $items) {
    Box $Slide $it.Label $it.X $it.Y 145 48 $C.Deep $C.Deep $C.White 11 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide $D.Labels[7] 420 150 145 38 $C.Green $C.Green $C.Ink 13 $true $ppAlignCenter $true | Out-Null
}

function Slide12 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  $users = $D.Labels[0..2]
  for ($i = 0; $i -lt 3; $i++) {
    $x = 110 + $i * 220
    Box $Slide $users[$i] $x 180 160 42 $C.Cyan $C.Cyan $C.Ink 18 $true $ppAlignCenter $true | Out-Null
    Box $Slide $D.Labels[3] $x 235 160 88 $C.Green $C.Green $C.Ink 15 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide ($D.Labels[4] + "`r" + $D.Labels[5] + " / " + $D.Labels[6]) 210 390 330 54 $C.Deep2 $C.Cyan $C.Ice 13 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[7] 565 390 155 54 $C.Blue $C.Blue $C.White 11.5 $true $ppAlignCenter $true | Out-Null
}

function Slide13 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  Box $Slide $D.Labels[0] 166 164 140 42 $C.Deep $C.Deep $C.White 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide ($D.Bullets[0] + "`r" + $D.Bullets[1] + "`r" + $D.Bullets[2]) 332 150 460 78 $C.White $C.Fog $C.Ink 10.5 $false $ppAlignLeft $true | Out-Null
  Box $Slide $D.Labels[2] 166 262 140 42 $C.Green $C.Green $C.Ink 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Bullets[3] 332 258 460 50 $C.Deep $C.Cyan $C.Cyan2 7.2 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[3] 166 350 140 42 $C.Blue $C.Blue $C.White 14 $true $ppAlignCenter $true | Out-Null
  Box $Slide ($D.Bullets[4] + "`r" + $D.Labels[4]) 332 342 300 66 $C.White $C.Fog $C.Ink 12 $true $ppAlignCenter $true | Out-Null
  Box $Slide $D.Labels[5] 655 342 136 66 $C.Cyan $C.Cyan $C.Ink 12 $true $ppAlignCenter $true | Out-Null
}

function Slide14 {
  param($Slide, $D)
  LightBackground $Slide; Header $Slide $D $false
  KeyText $Slide $D $false 158 88 620
  $left = @($D.Labels[0], $D.Labels[2], $D.Labels[4])
  $right = @($D.Labels[1], $D.Labels[3], $D.Labels[5])
  for ($i = 0; $i -lt 3; $i++) {
    $y = 165 + $i * 78
    $fill = if ($i -eq 2) { $C.Cyan } else { $C.White }
    $tc = if ($i -eq 2) { $C.Ink } else { $C.Ink }
    Box $Slide $left[$i] 190 $y 180 50 $fill $C.Fog $tc 13 $true $ppAlignCenter $true | Out-Null
    Box $Slide $right[$i] 395 $y 360 50 $fill $C.Fog $tc 13 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide $D.Bullets[4] 260 430 430 42 $C.Deep $C.Cyan $C.White 12 $true $ppAlignCenter $true | Out-Null
}

function Slide15 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 610
  $items = $D.Labels[0..4]
  for ($i = 0; $i -lt $items.Count; $i++) {
    $x = 94 + ($i % 3) * 230
    $y = if ($i -lt 3) { 210 } else { 330 }
    $fill = if ($i -eq 0) { $C.Cyan } elseif ($i -eq 4) { $C.Green } else { $C.Deep2 }
    $tc = if (($fill -eq $C.Cyan) -or ($fill -eq $C.Green)) { $C.Ink } else { $C.Ice }
    Box $Slide $items[$i] $x $y 175 72 $fill $C.Cyan $tc 14 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide $D.Labels[5] 360 430 250 42 $C.Amber $C.Amber $C.Ink 15 $true $ppAlignCenter $true | Out-Null
}

function Slide16 {
  param($Slide, $D)
  DarkBackground $Slide; Header $Slide $D $true
  KeyText $Slide $D $true 54 86 650
  $heads = $D.Labels[0..4]
  for ($i = 0; $i -lt $heads.Count; $i++) {
    $x = 82 + ($i % 3) * 230
    $y = if ($i -lt 3) { 185 } else { 315 }
    $fill = @($C.Green, $C.Cyan, $C.Blue, $C.Amber, $C.Deep2)[$i]
    $tc = if (($fill -eq $C.Green) -or ($fill -eq $C.Cyan) -or ($fill -eq $C.Amber)) { $C.Ink } else { $C.White }
    Box $Slide ($heads[$i] + "`r" + $D.Bullets[$i]) $x $y 190 82 $fill $fill $tc 10.5 $true $ppAlignCenter $true | Out-Null
  }
  Box $Slide ($D.Labels[5] + " / " + $D.Labels[6] + " / " + $D.Labels[7]) 274 452 410 38 $C.Cyan $C.Cyan $C.Ink 16 $true $ppAlignCenter $true | Out-Null
}

$sourcePath = (Resolve-Path $Source).Path
$outputPath = Join-Path (Resolve-Path ".").Path $Output
$slides = Read-Slides $sourcePath

$ppt = $null
$pres = $null
try {
  $ppt = New-Object -ComObject PowerPoint.Application
  $ppt.Visible = [Microsoft.Office.Core.MsoTriState]::msoTrue
  $pres = $ppt.Presentations.Add([Microsoft.Office.Core.MsoTriState]::msoTrue)
  $pres.PageSetup.SlideWidth = $SlideW
  $pres.PageSetup.SlideHeight = $SlideH
  while ($pres.Slides.Count -gt 0) { $pres.Slides.Item(1).Delete() }

  foreach ($d in $slides) {
    $s = $pres.Slides.Add($d.Number, $ppLayoutBlank)
    switch ($d.Number) {
      1 { Slide1 $s $d }
      2 { Slide2 $s $d }
      3 { Slide3 $s $d }
      4 { Slide4 $s $d }
      5 { Slide5 $s $d }
      6 { Slide6 $s $d }
      7 { Slide7 $s $d }
      8 { Slide8 $s $d }
      9 { Slide9 $s $d }
      10 { Slide10 $s $d }
      11 { Slide11 $s $d }
      12 { Slide12 $s $d }
      13 { Slide13 $s $d }
      14 { Slide14 $s $d }
      15 { Slide15 $s $d }
      16 { Slide16 $s $d }
    }
    Add-Notes $s $d.Notes
  }

  if (Test-Path $outputPath) { Remove-Item -LiteralPath $outputPath -Force }
  $pres.SaveAs($outputPath)
  $pres.Close()
  $ppt.Quit()
  Write-Output "[OK] generated $outputPath"
  Write-Output "[OK] slides: $($slides.Count)"
  Write-Output "[OK] notes: $($slides.Count)"
} finally {
  if ($pres -ne $null) { try { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($pres) | Out-Null } catch {} }
  if ($ppt -ne $null) { try { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($ppt) | Out-Null } catch {} }
}
