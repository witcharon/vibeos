#!/bin/sh
# VibeOS senkron: fetch -> commit -> merge -> push -> beyin.py sync
# Kullanım: sh .vibeos/sync.sh <vault-yolu>
#
# Tasarım: senkron kendiliğinden kilitlenmez ve veri silmez.
# - Önce yerel her şey commit'lenir (yeni/untracked dosyalar dahil), sonra uzak merge edilir.
#   Böylece "untracked dosyanın üstüne yazılır" hatası oluşamaz.
# - Gerçek içerik çakışmasında uzak sürüm yerinde kalır, yerel sürüm yanına
#   "<ad>.cakisma-<makine>-<zaman>.<uzantı>" kopyası olarak yazılır; bildirim bir kez gelir.
#   Kopyayı asıl dosyayla birleştirip silmek yeterli.
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

MAKINE=$(uname -n | cut -d. -f1)
IGNORE="$VAULT/.git/vibeos-ignore"

commit_et() {
  git -c core.excludesFile="$IGNORE" add -A
  git diff --cached --quiet || git commit -q -m "senkron: $(uname -n) $(date '+%F %H:%M')"
}

# Yarıda kesilmiş bir turun bıraktığı ara durumları temizle.
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; then git rebase --abort 2>/dev/null; fi
if [ -f .git/MERGE_HEAD ]; then git merge --abort 2>/dev/null; fi

# Ağ yoksa çakışma sanma: önce fetch, başarısızsa sessizce sonraki tura bırak.
if ! git fetch -q 2>/dev/null; then
  echo "$(date '+%F %T') Uzak depoya ulaşılamadı, sonraki turda tekrar denenecek." >&2
  exit 0
fi

# Öbür makineden gelen .gitignore kuralları commit'ten önce geçerli olsun:
# global ignore + uzak .gitignore birleşimi bu turun excludesFile'ı olur.
{
  g=$(git config --path core.excludesFile 2>/dev/null || echo "$HOME/.config/git/ignore")
  [ -f "$g" ] && cat "$g"
  git show '@{u}:.gitignore' 2>/dev/null
} > "$IGNORE"

# 1) Yerel her şeyi commit'le (untracked dahil).
commit_et

# 2) Uzağı merge et; çakışırsa yerel sürümü kopya olarak bırakıp devam et.
if ! git merge -q --no-edit '@{u}' >/dev/null 2>&1; then
  ZAMAN=$(date '+%Y%m%d-%H%M')
  LISTE="$VAULT/.git/vibeos-cakisma"
  git -c core.quotePath=false diff --name-only --diff-filter=U > "$LISTE"
  while IFS= read -r f; do
    ad="${f##*/}"
    case "$ad" in
      ?*.*) kopya="${f%.*}.cakisma-$MAKINE-$ZAMAN.${f##*.}" ;;
      *) kopya="$f.cakisma-$MAKINE-$ZAMAN" ;;
    esac
    # :2 = yerel (ours), :3 = uzak (theirs)
    git show ":2:$f" > "$kopya" 2>/dev/null || rm -f -- "$kopya"
    if git cat-file -e ":3:$f" 2>/dev/null; then
      git checkout --theirs -- "$f" && git add -- "$f"
    else
      git rm -q --cached -- "$f" 2>/dev/null; rm -f -- "$f"
    fi
    [ -f "$kopya" ] && git add -f -- "$kopya"
  done < "$LISTE"
  if [ -n "$(git diff --name-only --diff-filter=U)" ] || ! git commit -q --no-edit; then
    git merge --abort 2>/dev/null
    uyar "Merge çözülemedi, senkron bu tur atlandı. Log'a bak."
    exit 1
  fi
  uyar "Çakışma kopyası oluştu ($(wc -l < "$LISTE" | tr -d ' ') dosya). Yerel sürüm .cakisma-$MAKINE dosyasında."
  sed "s/^/  çakışan: /" "$LISTE" >&2
fi

# Makineye özel ek adımlar (ör. bir klasörü vault'a aynalamak) bu dosyada değil, burada.
[ -f .vibeos/sync.local.sh ] && { sh .vibeos/sync.local.sh "$VAULT" || uyar "sync.local.sh başarısız."; }
commit_et

# Push yarışı kaybedilirse (öbür makine arada push'ladıysa) sonraki tur merge eder; bildirim gereksiz.
if ! git push -q 2>/dev/null; then
  echo "$(date '+%F %T') Push reddedildi, sonraki turda merge edilip tekrar denenecek." >&2
fi

PY=python3; command -v python3 >/dev/null 2>&1 || PY=python
[ -f beyin.py ] && "$PY" beyin.py sync >/dev/null 2>&1
exit 0
