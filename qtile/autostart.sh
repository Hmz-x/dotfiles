#!/bin/bash -x

# ========================================================================
# 1. CORE NOTIFICATION ARCHITECTURE
# ========================================================================
# Initialize fnott notification daemon if not already running
pgrep -x fnott >/dev/null || fnott &

# ========================================================================
# 2. LOCALIZATION MATRIX (Coordinates & Solar Adjustments)
# ========================================================================
# Targets: "fethiye", "istanbul", "west-lafayette"
LOCATION="fethiye"

case "$LOCATION" in
"fethiye")
  lat="36.6225"
  long="29.1115"
  ;;
"istanbul")
  lat="41.0082"
  long="28.9784"
  ;;
"west-lafayette")
  lat="40.4259"
  long="-86.9081"
  ;;
*)
  # Hardened Fallback (NYC)
  lat="40.7128"
  long="-74.0060"
  ;;
esac

# ========================================================================
# 3. WAYLAND BLUE LIGHT DIFFERENTIAL DISPATCHER
# ========================================================================
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  # -t 4500 (Night temperature in Kelvin) / -T 6500 (Day temperature in Kelvin)
  pgrep -x wlsunset >/dev/null || wlsunset -l "$lat" -L "$long" -t 4500 -T 6500 &
fi

# ========================================================================
# 4. POLKIT GRAPHICAL AUTHENTICATION DEPLOYMENT
# ========================================================================
# Check both modern Qt6/Plasma6 libexec paths and legacy layouts fallback
POLKIT_AGENT=""
for path in \
  "/usr/lib/libexec/polkit-kde-authentication-agent-1" \
  "/usr/lib/polkit-kde-authentication-agent-1"; do
  if [ -f "$path" ]; then
    POLKIT_AGENT="$path"
    break
  fi
done

if [ -n "$POLKIT_AGENT" ]; then
  pgrep -f "$(basename "$POLKIT_AGENT")" >/dev/null || "$POLKIT_AGENT" &
else
  echo "Warning: No graphical polkit-kde agent found on local storage nodes." >&2
fi
