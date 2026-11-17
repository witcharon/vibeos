#!/bin/sh
# VibeOS senkron: fetch -> pull --rebase -> commit -> push -> beyin.py sync
# Kullanım: sh .vibeos/sync.sh <vault-yolu>
set -u
VAULT="${1:?vault yolu gerekli}"
cd "$VAULT" || exit 1

LOCK="$VAULT/.git/vibeos-sync.lock"
find "$LOCK" -maxdepth 0 -mmin +30 -exec rmdir {} \; 2>/dev/null
mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK"' EXIT

uyar() {
  echo "$(date '+%F %T') $1" >&2
  command -v osascript >/dev/null 2>&1 && osascript -e "display notification \"$1\" with title \"VibeOS senkron\""
  return 0
}

# Yarım rebase veya çözülmemiş çakışma varken dokunma
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -n "$(git diff --name-only --diff-filter=U)" ]; then
  uyar "Çözülmemiş git çakışması var, senkron durdu."
  exit 1
fi

# Ağ yoksa çakışma sanma: sessizce sonraki tura bırak
git fetch -q 2>/dev/null || { echo "$(date '+%F %T') ağ yok, sonraki tur" >&2; exit 0; }

# Önce pull: öbür makinenin .gitignore kuralları commit'ten önce geçerli olsun
if ! git pull -q --rebase --autostash; then
  git rebase --abort 2>/dev/null
  uyar "Pull çakıştı, rebase geri alındı. Elle çözülmesi gerekiyor."
  exit 1
fi

git add -A
git diff --cached --quiet || git commit -q -m "senkron: $(uname -n) $(date '+%F %H:%M')"
git push -q || { uyar "Push başarısız."; exit 1; }

PY=python3; command -v python3 >/dev/null 2>&1 || PY=python
[ -f beyin.py ] && "$PY" beyin.py sync >/dev/null 2>&1
exit 0
