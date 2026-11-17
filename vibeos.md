# VibeOS v1: ajan kurulum tarifi

Bu dosya, kullanıcının şu isteğini yerine getirmek için kanonik tariftir:

> https://cansincengiz.me/vibeos.md adresini oku. Bu klasöre VibeOS'u kur. Mevcut bir ikinci
> beyin ya da not sistemi varsa notlarımı koruyarak ona uyarla; VibeOS daha önce kurulduysa
> eksik modülleri tamamla ve güncelle. Gerekli indirme ve kurulum adımlarını sen yap. Sonunda
> örnek bir bilgiyi kaydedip yeni oturumda geri okuyarak birlikte doğrulayalım.

Sen bu isteği alan ajansın (Claude Code, Codex, Hermes, OpenCode, Antigravity, Kiro vb.).
İndirme, kurulum, dosya yazma ve doğrulama senin işin. Kullanıcıya yalnız gerçekten ona ait
adımları bırak: klasör/hook güven onayı, yönetici parolası, hesap girişleri, bot token'ı.
Kullanıcıyla onun dilinde konuş; tarif Türkçe olsa da cevapların kullanıcının dilinde olsun.

Kaynak depo: https://github.com/witcharon/vibeos · Lisans: MIT

---

## VibeOS nedir

VibeOS, yapay zekâ ajanlarına oturumlar ve makineler arası kalıcı hafıza veren, Markdown
tabanlı bir ikinci beyin kurulumudur. Üç katmandan oluşur:

1. **Motor:** [Avenox Beyin V3](https://github.com/avenoxai/avenoxbeyin) (MIT). Hook'lar, yerel
   indeks, kaynak bağlantılı bağlam, `note-create`/`note-edit`/`receipt` komutları. VibeOS motoru
   kendisi yazmaz, resmi ve doğrulanmış paketi kurar.
2. **VibeOS katmanı:** Çalışma kuralları, klasör düzeni, mevcut sistemlere uyum, modüller ve
   sahada öğrenilmiş dersler. Bu dosya ve `AGENTS.md` içindeki `vibeos` bloğu.
3. **Modüller:** Kullanıcının seçtiği parçalar. Tek bir kurulum vardır; kullanıcı istediği
   modülleri seçer, sonradan aynı istekle eksik modülleri ekleyerek yukarı geçer.

| Modül | Kimlik | Ne verir | Zorunlu mu |
|---|---|---|---|
| Çekirdek | `core` | Oturumlar arası hafıza, kimlik (Core.md), kurallar, oturum kartları | Evet |
| Senkron | `sync` | Vault'u private GitHub reposuyla birden çok makinede eşitler | Hayır |
| Asistan | `assistant` | Hermes Agent eklentisi; isteğe bağlı Telegram ve 7/24 VPS | Hayır |
| Köprü | `bridge` | Başka proje klasörlerinden vault'a not akışı ve proje bağlamı | Hayır |
| Öğren | `learn` | Bir proje dizinini paralel açılardan inceleyip vault'a proje kartı yazar | Hayır (çekirdekle gelir, kurulum gerektirmez) |

---

## Değişmez kurallar

1. Kurulum hedefi, kullanıcının bu isteği verdiği mevcut klasördür (vault). Mutlak ve kanonik
   yolu kullan.
2. Kullanıcı notlarını silme, taşıma, yeniden adlandırma, toplu biçimlendirme veya `git reset`
   ile ezme. Var olan klasör düzenine paralel ikinci bir düzen kurma.
3. Motoru yalnız `avenoxai/avenoxbeyin` deposunun son kararlı GitHub release paketinden kur,
   SHA-256 doğrulamasıyla. Kaynak kod arşivi, üçüncü taraf paket veya kendi kopyalama zincirin yok.
4. Sır yazma: parola, API anahtarı, bot token'ı, SSH özel anahtarı vault'a, nota, commit'e,
   sohbete veya terminal çıktısına girmez. Vault Git'e senkronlanabilir; içindeki her şey
   repoya gidebilir gibi davran.
5. Başarı mesajına değil sonuca bak. Her adımda çıkış kodunu, dosyanın gerçekten oluştuğunu,
   `crontab -l` / `launchctl list` / `git status` gibi gerçek çıktıyı kontrol et. Doğrulanmadan
   "kuruldu" deme.
6. Kullanıcının global ayarlarını (`~/.claude/settings.json`, kabuk profili, crontab) değiştirmeden
   önce ne değişeceğini tek cümleyle söyle ve onay al.
7. Kararsız kaldığında tahmin etme, kısa ve seçenekli bir soru sor. Ama sorulabilecek her şeyi
   sorma; makul varsayılanı uygula ve özette belirt.

---

## 0. Keşif: ne var, ne yok

Hiçbir şey yazmadan önce durumu çıkar.

### 0.1 Ortam
- İşletim sistemi ve kabuk (macOS, Linux, Windows/PowerShell, WSL).
- Python 3.11+: macOS/Linux'ta `python3`, sonra `python`; Windows'ta `py -3`, sonra `python`.
  Sürümü gerçekten çalıştırarak kontrol et. Yoksa işletim sisteminin resmi paket yöneticisiyle
  kur (Homebrew, winget, apt); yönetici onayı gerekiyorsa yalnız o noktada iste.
- `git` var mı (yalnız `sync` için şart). `gh` var mı ve oturum açık mı (`gh auth status`).
- Hangi ajan istemcileri kurulu: `claude`, `codex`, `hermes`, `opencode`, Kiro, Antigravity.
- Vault yolu iCloud, Dropbox, OneDrive, macOS'ta `~/Desktop` / `~/Documents` veya harici disk
  altındaysa not et (bkz. Dersler: zamanlanmış görevler bu yollara erişemeyebilir).

### 0.2 Önceki VibeOS kurulumu
Vault kökünde `.vibeos/kurulum.json` var mı? Varsa oku: VibeOS sürümü, vault'a ait modüller
(ör. `sync` repo adı) ve makine bazında kurulu modüller. Dosyaya körü körüne güvenme; 0.4'teki
gerçek kontrollerle karşılaştır.

### 0.3 Mevcut benzer sistemler
VibeOS sürüm göçü yapmaz; var olan sisteme uyum sağlar. Şunları ara ve bulduklarını sınıfla:

| Bulgu | Nasıl anlaşılır | Ne yapılır |
|---|---|---|
| Avenox Beyin V3 | `.beyin-version` `3.` ile başlıyor | Motoru resmi updater ile güncelle (1.2b). Companion klasörünü ve notları olduğu gibi kullan. |
| Avenox Beyin V1/V2 | Eski runner'lar, `.beyin-version` yok ama beyin dosyaları var | Resmi installer kendi göç kurallarıyla geçirir (1.2a, önce `--plan`). |
| Obsidian vault | `.obsidian/` | Klasör düzenine dokunma. VibeOS klasörlerini (aşağıda) mevcut karşılıklarına eşle. |
| PARA / Zettelkasten / Johnny Decimal / kendi düzeni | `1-Projects/`, `Projects/`, `Areas/`, `Zettel/`, numaralı klasörler | Eşleme tablosu kur: VibeOS'un `projects/` kavramı onların proje klasörüne gider. |
| Ajan talimat dosyaları | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules` | İçeriği koru. VibeOS yalnız işaretli bir blok ekler. Talimatlardaki kimlik/tercih bilgisini Core.md'ye kaynak göstererek taşı, kopyalayıp çoğaltma. |
| Başka hafıza araçları | `memory/`, `MEMORY.md`, claude-mem, Basic Memory, Mem0 dosyaları, Logseq `pages/`, Notion dışa aktarımı | Silme, devre dışı bırakma. Notları kaynak olarak bırak; gerekirse `preferences --index-include-dir` ile indekse al. Çift hafıza enjeksiyonu riski varsa kullanıcıya hangisinin otomatik bağlam vereceğini sor. |
| Var olan senkron | Vault zaten bir git deposu, launchd/cron/Task Scheduler'da senkron işi, Syncthing/iCloud | İkinci bir senkron kurma. Mevcut düzeni benimse, `.vibeos/kurulum.json`'a `sync.mode` olarak yaz. Bulut senkron + Git birlikteyse uyar. |
| Var olan kimlik dosyası | Herhangi bir yerde `Core.md`, `Soul.md`, "hakkımda" notu | Yeni kimlik açma. Birden fazla aday varsa kullanıcıya sor. |

**Eşleme kuralı.** VibeOS'un kavramsal klasörleri şunlardır:

| Kavram | Varsayılan yol |
|---|---|
| Proje notları ve proje kuralları | `projects/<proje>/` (`projects/<proje>/Kurallar.md`) |
| Görüşme notları | `notes/gorusmeler/` (ham transkript `notes/gorusmeler/kaynak/`) |
| Ajanlar/makineler arası devir notları | `notes/devir/` |
| Kalıcı öğrenimler ve kararlar | `knowledge/` |
| Kimlik, kurallar, oturum kartları | Motorun companion klasörü (`🔮 850-Companion/`) |

Kullanıcının düzeninde karşılığı olan kavram için yeni klasör açma; eşlemeyi 1.3'teki
`vibeos` bloğuna yaz. Karşılığı yoksa varsayılan yolu ilk not yazıldığında aç, önceden boş
klasör yaratma.

### 0.4 Gerçek modül durumu (bu makine)
- `core`: `.beyin-version` var, `beyin.py doctor --human` çalışıyor, `AGENTS.md` içinde
  `<!-- vibeos:start -->` bloğu var.
- `sync`: vault bir git deposu, `origin` tanımlı, `.vibeos/sync.sh` var ve bu makinede zamanlayıcı
  kayıtlı (macOS `launchctl list | grep vibeos`, Linux `crontab -l`, Windows
  `schtasks /query /tn VibeOS-Sync`).
- `assistant`: `hermes plugins list` içinde `beyin-v3` enabled.
- `bridge`: istemcinin global ayarında Beyin köprü hook'u var (`beyin.py bridge --harness claude
  --print-config` ile karşılaştır).

### 0.5 Kullanıcıya özet ve seçim
Kısa bir tablo göster: bulunan sistemler, uyum planı (hangi klasör neye eşlenecek), her modülün
bu makinedeki durumu (kurulu / eksik / kısmen). Sonra **tek bir soruda** hangi modüllerin
kurulacağını sor:

- İlk kurulumda varsayılan öneri: `core`. Kullanıcı birden çok bilgisayar kullanıyorsa `sync`,
  Telegram'dan ulaşmak istiyorsa `assistant`, başka proje klasörlerinde çalışıyorsa `bridge`.
- Tekrar çalıştırmada: kurulu olanları ✓ ile göster, yalnız eksikleri öner. Kurulu modül için
  yalnız güncelleme ve sağlık kontrolü yap.
- Modül bağımlılıkları: her şey `core` ister. VPS üzerindeki asistan `sync` ister (vault oraya
  Git ile gider). Kullanıcı bağımlılığı olmayan modülü seçerse bağımlılığı da eklemeyi öner.

---

## 1. Modül: Çekirdek (`core`)

### 1.1 Motor paketini indir ve doğrula
1. Son kararlı sürüm: `https://api.github.com/repos/avenoxai/avenoxbeyin/releases/latest`
   (`draft` ve `prerelease` false olmalı). API 403/429 dönerse
   `https://github.com/avenoxai/avenoxbeyin/releases/latest` yönlendirmesinden etiketi al;
   sürüm tahmin etme.
2. **Uyumluluk:** VibeOS v1, motorun **3.x** serisiyle test edildi. Etiketin ana sürümü 3 değilse
   dur, kullanıcıya bildir ve bu depoda güncel tarif olup olmadığına bak.
3. `beyin-v3-X.Y.Z.zip` ve `beyin-v3-X.Y.Z.zip.sha256` dosyalarını geçici klasöre HTTPS ile indir.
   SHA-256'yı karşılaştır; eşleşmezse arşivi açma, dur.
4. Arşivi geçici klasöre açarken mutlak yol, `..` kaçışı ve sembolik bağ içeren üyeleri reddet.
   Paket kökünde `manifest.json` ve `scripts/install_v3.py` olmalı.

Motorun kendi ajan tarifi ayrıntılar için başvuru kaynağıdır: https://avenox.io/beyin.md

### 1.2 Kur veya güncelle
- **1.2a** `.beyin-version` yoksa (ilk kurulum veya Beyin V1/V2):
  önce `<python> <paket>/scripts/install_v3.py --vault <vault> --plan` ile ne yazılacağını gör ve
  kullanıcıya kısaca özetle; sonra `--plan` olmadan çalıştır. Elle değiştirilmiş eski runner
  bildirilirse ezme; içeriğini özetle, açık onayla yalnız o dosya için
  `--accept-customized-legacy <yol>` kullan.
- **1.2b** `.beyin-version` `3.` ile başlıyorsa: vault kökünde
  `<python> beyin.py update --check --package <zip>` sonra `<python> beyin.py update --package <zip>`.
  `updated` ve `noop` ikisi de başarıdır.
- `Reinstall conflict: managed file changed <yol>` görürsen kullanıcı dosyasını ezme; dosyayı ve
  nedenini bildir. Yarım kalan işlemde önce `beyin.py recover`.
- Installer çıktısındaki `companion` ve `skills.conflicts` alanlarını oku; `needs_attention`
  varsa o adımı kullanıcıya sormadan tamamlama.
- Bitince geçici ZIP ve açma klasörünü sil.

### 1.3 VibeOS bloğunu ekle
Vault kökündeki `AGENTS.md` dosyasına, motorun `beyin-v3` bloğundan **sonra**, aşağıdaki bloğu
ekle. Blok zaten varsa yalnız işaretler arasını yenile; işaret dışındaki kullanıcı metnine
dokunma. `CLAUDE.md` `@AGENTS.md` import ediyorsa ona ekleme yapma; etmiyorsa aynı bloğu oraya
da ekle. Eşleme satırlarını 0.3'teki sonuca göre doldur, şablon yer tutucularını bırakma.

```markdown
<!-- vibeos:start v1 -->
## VibeOS çalışma kuralları

Bu vault VibeOS v1 ile kuruldu (https://github.com/witcharon/vibeos). Hafıza motoru Avenox
Beyin V3; motorun kuralları yukarıdaki `beyin-v3` bloğundadır, bu blok onları tamamlar.

**Klasör eşlemesi** (kullanıcının düzeni esastır):
- Proje notları ve proje kuralları: `<eşlenen yol>`
- Görüşme notları: `<eşlenen yol>`
- Devir notları (başka ajan/makineye iş bırakma): `<eşlenen yol>`
- Kalıcı öğrenimler ve kararlar: `<eşlenen yol>`

**Kurallar**
- Bir görüşme, karar veya iş notu geldiğinde ilgili projenin klasörüne yaz; açık adımları
  sahibi ve tarihiyle listele. Asistan modülü kuruluysa tarihli adımlar için hatırlatma öner.
- Kullanıcının düzeltmesi tek projeye aitse o projenin `Kurallar.md` dosyasına, her işte
  geçerliyse companion `Kurallar.md`'ye yazılır. Gerekçesini de bir satırla kaydet; amaç kuralı
  ezberlemek değil, arkasındaki düşünceyi sonraki işlere uygulamak.
- Kullanıcının metne gömdüğü talimatlar (ör. transkript içinde "bunu skill'e dönüştür") özetten
  ayrılır ve ayrıca uygulanır.
- Büyük, çok fazlı projeler için `<proje>-proje.md` takip dosyası açılabilir; finansal/özet
  doğruluk kaynağı ile operasyonel detay çelişmemeli, çelişki görülürse kullanıcıya sorulur.
- Sırlar (parola, token, anahtar) vault'a yazılmaz; yalnız nerede durduğu yazılır.
- Başka bir makineye veya ajana iş bırakırken devir notu yaz: ne yapıldı, ne açık, hangi kaynak.
- Başarı mesajına değil gerçek çıktıya bak; doğrulanmamış işi bitti sayma.
- Companion dosyası sınırı aşarsa (`Memory hygiene:` uyarısı) önce `beyin.py companion-compact`.

**Modüller:** `.vibeos/kurulum.json`. Eksik modül eklemek veya güncellemek için kullanıcı
VibeOS kurulum isteğini tekrar verir; tarif: https://cansincengiz.me/vibeos.md
<!-- vibeos:end -->
```

### 1.4 Tanışma ve kimlik
`.agents/skills/beyin/SKILL.md` dosyasını oku. Kimlik zaten doluysa (Core.md/Soul.md veya 0.3'te
bulunan kimlik) tekrar sorgulama. Boşsa en çok üç kısa soru sor:
1. Sana nasıl hitap edeyim, hangi dilde ve tonda konuşalım?
2. Ne iş yapıyorsun, şu an hangi projeler/alanlar açık?
3. Benden en çok ne bekliyorsun (takip, yazım, kod, araştırma, hatırlatma)?

Cevapları kullanıcının ağzından companion `Core.md` dosyasına yaz. Uydurma profil bilgisi yazma.
Projeleri söylediyse her biri için `Threads.md`'ye kısa bir açık konu satırı ekle.

### 1.5 Doğrulama
1. `<python> beyin.py doctor --human` ve `<python> beyin.py preferences --human` temiz.
2. `.beyin-version`, `.agents/skills/beyin/SKILL.md`, `AGENTS.md` içinde iki blok mevcut.
3. Kullanıcıdan bir örnek bilgi iste (ya da tanışmadan bir bilgi seç). `beyin.py note-create
   --file <json>` ile `knowledge/` (veya eşlenen yol) altına yaz, `beyin.py sync`, sonra ayrı bir
   komutta `beyin.py context "<konu>"` ile geri oku ve dönen `source` yolunu kullanıcıya söyle.
   Dosyayı doğrudan açıp okumak geri okuma sayılmaz.
4. İstemcinin güven onayını (Claude Code klasör güveni, Codex `/hooks`, Kiro Agent Hooks)
   kullanıcıya göster; onayı atlatma.
5. Kullanıcıdan **yeni bir oturum** açıp örnek bilgiyi sormasını iste. Bu yapılmadan
   "oturumlar arası hafıza doğrulandı" deme.

---

## 2. Modül: Senkron (`sync`)

Amaç: aynı vault birden çok makinede (iş/ev bilgisayarı, VPS) çalışsın. Resmi düzen:
https://github.com/avenoxai/avenoxbeyin/blob/main/docs/v3/MULTI-MACHINE.md

### 2.1 Depo
- Vault zaten bir git deposuysa onu kullan. Değilse `git init`.
- Uzak depo **private** olmalı ve kullanıcının hesabında durmalı. `gh` oturumu varsa
  `gh repo create <ad> --private --source . --remote origin` ile oluştur; yoksa kullanıcıdan
  GitHub'da boş private repo açıp adresini vermesini iste. Public repoya vault gönderme.
- Kimlik doğrulama: masaüstünde mevcut Git kimliği (HTTPS + kimlik yöneticisi veya SSH anahtarı);
  sunucuda yalnız bu repoya yetkili **deploy key** (yazma izinli).

### 2.2 `.gitignore` ve `.gitattributes`
Var olan dosyaları koru, eksik satırları ekle.

`.gitignore`:
```gitignore
# Motor kurulumu: her makine kendisi kurar ve günceller
.beyin-runtime.json
.beyin-version
beyin.py
Beyni Guncelle.cmd
Beyni Güncelle.command
Beyni Güncelle.sh
Beyni Güncelle.desktop
.claude/settings.local.json
.claude/scripts/
.claude/hermes-plugin/
.claude/skills/beyin/
.claude/skills/beyin-doktor/
.claude/skills/beyin-guncelle/
.claude/skills/beyin-kontrol/
.agents/hooks.json
.agents/skills/beyin/
.agents/skills/beyin-doktor/
.agents/skills/beyin-guncelle/
.agents/skills/beyin-kontrol/
.codex/config.toml
.codex/hooks.json
.kiro/hooks/beyin-v3.json
.kiro/skills/beyin/
.kiro/skills/beyin-doktor/
.kiro/skills/beyin-guncelle/
.kiro/skills/beyin-kontrol/
.opencode/plugins/beyin-v3.js
.omp/hooks/pre/beyin-v3.ts
**/.beyin-compact.lock
.beyin-note-write/
daily/v3/
knowledge/v3/
# VibeOS
.vibeos/*.log
# Sırlar ve sistem dosyaları
.env
.env.*
*.pem
*.key
.DS_Store
node_modules/
__pycache__/
```

`.gitattributes`:
```gitattributes
receipts/** -text
**/Last-Session.md merge=union
**/Journal.md merge=union
**/Arşiv/*.md merge=union
```

Kurulumdan sonra `git status --short` içinde motor dosyası görünmemeli. İlk commit'ten önce
`git status --short` çıktısını gözden geçir; `.env`, anahtar, büyük ikili dosya varsa ekleme.

### 2.3 Senkron betiği
`.vibeos/sync.sh` dosyasını oluştur (Git'te izlenir, tüm makinelerde aynıdır):

```sh
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
```

Kullanıcının makineye özel ek adımları (ör. bir klasörü vault'a aynalamak) bu betiğe değil
`.vibeos/sync.local.sh` gibi ayrı bir dosyaya gider ve betik onu varsa çağırabilir.

### 2.4 Zamanlayıcı (5 dakika)
- **macOS (launchd):** `~/Library/LaunchAgents/io.vibeos.sync.plist`; `ProgramArguments`
  `/bin/sh <vault>/.vibeos/sync.sh <vault>`, `StartInterval` 300, `RunAtLoad` true, log
  `~/Library/Logs/vibeos-sync.log`. **`EnvironmentVariables` içinde `PATH`'i açıkça ver**
  (git ve python3'ün gerçek konumları, ör. `/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin`);
  launchd kabuk profilini okumaz. `launchctl load -w` ile yükle, `launchctl list | grep vibeos`
  ile doğrula, bir tur sonra log'a ve `git log -1`'e bak.
- **Linux (cron):** `*/5 * * * * sh <vault>/.vibeos/sync.sh <vault> >> ~/.vibeos-sync.log 2>&1`.
  Crontab boşsa `crontab -l | grep -v ...` zinciri 1 döner; bunu hata sanıp betiği kesme.
  Ekledikten sonra `crontab -l` ile satırın gerçekten orada olduğunu doğrula.
- **Windows (Task Scheduler):** Git for Windows'un `sh.exe`'siyle:
  `schtasks /create /sc minute /mo 5 /tn VibeOS-Sync /tr "\"C:\Program Files\Git\bin\sh.exe\" \"<vault>\.vibeos\sync.sh\" \"<vault>\""`
  Yolu kullanıcının kurulumuna göre düzelt; `schtasks /run /tn VibeOS-Sync` ile bir kez çalıştırıp
  `git log -1` ile sonucu doğrula.

### 2.5 İkinci makine
Kullanıcı aynı VibeOS isteğini ikinci makinede **boş bir klasörde** verir. 0.2'de
`.vibeos/kurulum.json` yoksa ve kullanıcı mevcut bir VibeOS reposu olduğunu söylerse:
repoyu bu klasöre klonla, sonra 1. (motor bu makinede ayrıca kurulur, kurulum dosyaları Git'ten
gelmez), 2.4 ve seçilen diğer modüller. Klonlanan vault'ta Core.md zaten dolu olduğu için tanışma
sorulmaz.

### 2.6 Doğrulama
Bu makinede bir not yaz, bir senkron turu bekle (ya da betiği elle çalıştır), öbür makinede
`git log -1` ve `beyin.py context "<konu>"` ile notun geldiğini gör. Tek makine varsa en azından
GitHub'da son commit'i göster. `git status --short` boş olmalı.

---

## 3. Modül: Asistan (`assistant`)

Hermes Agent ile vault'a bağlı kişisel asistan. Üç kademe; kullanıcı istediği kadarını seçer:

### 3.1 Lokal Hermes eklentisi
Hermes kurulu değilse resmi dokümandaki kurulumu uygula:
https://hermes-agent.nousresearch.com/docs . Sonra (macOS/Linux):
```sh
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HERMES_HOME/plugins"
ln -sfn "<vault>/.claude/hermes-plugin" "$HERMES_HOME/plugins/beyin-v3"
hermes plugins enable beyin-v3
hermes plugins list   # beyin-v3 "enabled" görünmeli
```
Windows'ta symlink yerine junction kullan (`New-Item -ItemType Junction`). Adlandırılmış Hermes
profili kullanılıyorsa enable adımı `hermes -p <profil>` ile yapılır. Ardından Hermes sürecini
yeniden başlat. Ayrıntı: https://github.com/avenoxai/avenoxbeyin/blob/main/docs/v3/HERMES.md

### 3.2 Telegram (isteğe bağlı)
Kullanıcı BotFather'dan bot açar; token'ı **kendisi** Hermes'in mesajlaşma kurulumuna girer
(`hermes gateway setup` ve Hermes dokümanındaki Telegram sayfası). Token'ı sohbetten isteme,
vault'a yazma. Telegram Hermes eklentisinde varsayılan olarak "gözetimsiz" platformdur; kullanıcı
asistanla esas olarak Telegram'dan konuşacaksa `beyin.py preferences --hermes-attended-platform
telegram` öner.

### 3.3 7/24 sunucu (isteğe bağlı, `sync` gerekir)
Bilgisayar kapalıyken de çalışan asistan için Hermes bir VPS'te (genellikle Docker) çalışır:
1. Sunucuda vault için yalnız bu repoya yetkili deploy key üret, public key'i kullanıcı GitHub'da
   repoya ekler (yazma izni).
2. Vault'u Hermes'in kalıcı veri alanına klonla (ör. `<HERMES_HOME>/vault`), motoru orada 1.
   adımdaki gibi kur, eklentiyi 3.1'deki gibi bağla.
3. 2.4'teki senkronu **host'un** zamanlayıcısına kur (Docker'da
   `docker exec -u <hermes-kullanıcısı> <container> sh <vault>/.vibeos/sync.sh <vault>`).
4. Container içinde komutları her zaman Hermes sürecinin kullanıcısıyla çalıştır
   (`docker exec -u ...`); root ile oluşan dosyaları Hermes okuyamaz. Gerekirse `chown`.
5. Doğrulama: masaüstünde yazılan notu Telegram'dan sor; cevap kaynağıyla gelmeli.

### 3.4 Asistan kuralları
- Hatırlatma ve rutinlerde saat dilimini açık ver (sunucular çoğu zaman UTC'dir).
- Model gerektirmeyen periyodik işleri model çağırmayan betik işi olarak kur; her turda model
  çağıran zamanlanmış iş gereksiz maliyettir.
- Başka bir kişiye (müşteri, öğrenci) bot açılacaksa vault'a bağlı ana asistanı paylaşma: ayrı
  Hermes profili, ayrı bot, minimum araç, yalnız gerekli skill.

---

## 4. Modül: Köprü (`bridge`)

Kullanıcı kod/proje çalışmalarını vault dışındaki klasörlerde yapıyorsa, oradaki oturumlar
vault'u tanısın ve "VibeOS'a not et" denince not kaynağıyla vault'a gitsin.

1. Kullanıcıya proje kök klasörlerini sor (ör. `~/Projeler`, `~/Code`).
2. Vault kökünde: `<python> beyin.py bridge --harness claude --project-root <kök1> --project-root
   <kök2> --install` (Codex/Antigravity için `--harness` değişir). Bu komut istemcinin **global**
   ayarını değiştirir; önce `--print-config` ile göster, onay al. İstemci kendi global ayarını
   değiştirmeyi güvenlik nedeniyle reddederse komutu kullanıcıya ver, kendisi çalıştırsın
   (Claude Code'da `!` önekiyle).
3. `<python> beyin.py preferences --project-context on`: oturum başında o projenin son kaydı ve
   tarihi gelen görevler gelir.
4. Yeni kök eklemek için komut **tüm köklerle** yeniden çalıştırılır.
5. Doğrulama: köklerden birinde yeni oturum aç, oturum başı bağlamında proje etiketi ve vault
   yolu görünmeli; "VibeOS'a not et: <test>" deyip notun vault'ta oluştuğunu gör.

---

## 5. Yetenek: Projeyi öğren (`learn`)

Kurulum gerektirmez; `core` kurulu her vault'ta çalışır. Kullanıcı "`<dizin>` projesini öğren"
veya "`<proje>`'yi tazele" dediğinde uygulanır. Çıktı: vault'ta kaynak gösterilmiş bir proje
kartı, proje kuralları ve kullanıcıya açık sorular. Proje dizininde **hiçbir şey değişmez**.

Hazır metinler: açı görevleri `templates/learn-lens.md`, kart iskeleti
`templates/project-card.md` (https://github.com/witcharon/vibeos/tree/main/templates).

### 5.1 Ön keşif (ana ajan, birkaç dakika)
1. **Doğru kodu öğren.** Git deposuysa dalı ve uzakla farkı kontrol et
   (`git branch --show-current`; yerel `HEAD`'i `git ls-remote origin -h refs/heads/<ana-dal>` ile
   karşılaştır). Yerel kopya yan dalda, geride ya da kirliyse kullanıcının klasörüne dokunma
   (checkout, pull, stash yok): ana dalı geçici klasöre ayrıca klonla, açıları oraya yönlendir.
   Git deposu değilse klasörü olduğu gibi oku; tarihçe açısını atla, kartta "git yok" yaz.
2. **Kapsam.** Aynı projeye ait başka klasör/repo var mı (uygulama, landing, worker, mobil)?
   Aynı remote'u paylaşan kopyalardan en tazesini bir kez öğren. Kapsamı tek cümleyle söyle.
3. **Ölçü.** İzlenen dosya, kod satırı, commit sayısı, üst klasör dağılımı, paket dosyaları,
   README. Açı sayısını seç:

| Ölçü | Örnek | Açı |
|---|---|---|
| Küçük | < 200 dosya, < 10k satır | 3-4 (ürün · mimari+veri · operasyon+entegrasyon · tarihçe+risk) |
| Orta | < 1.000 dosya | 5 (ürün · mimari · veri+entegrasyon · operasyon · tarihçe+risk) |
| Büyük | ≥ 1.000 dosya veya birden çok servis | 7 |

4. **İş açısı (ana ajan, açılar çalışırken).** Vault'ta projeyi ara (`beyin.py context
   "<proje>"`, metin araması, görüşme/gelir/müşteri notları, `Threads.md`). Bu bilgi sentezde
   alt ajan iddialarını sınamak için de kullanılır.

### 5.2 Açılar
Her açı ayrı bir alt ajandır, hepsi tek seferde paralel gönderilir. İstemcinin alt ajanı yoksa
açıları aynı ajan sırayla çalıştırır; her açıdan sonra kısa ara not yazıp bağlamı boşaltır.

| # | Açı | Ne çıkarır | Kapsam dışı |
|---|---|---|---|
| 1 | Ürün | Ne işe yarar, kimin için, özellik haritası, fiyat/plan, landing, içerik, SEO | Kod yapısı, deploy |
| 2 | Mimari | Dizin haritası, servisler ve nasıl konuştukları, istek akışı, auth, kuyruklar, ölü/çift kod, geçerli config | Şema ayrıntısı, deploy |
| 3 | Veri | DB/ORM, ana tablolar, ilişkiler, migration yolu, tenant izolasyonu, saklama/silme | Dış API'ler |
| 4 | Entegrasyonlar | Dış servisler ve ne için, webhook'lar, env **adları** ve kullanıldığı yer, belge-kod farkı | Deploy/CI |
| 5 | Operasyon | Çalıştırma/build/test komutları, deploy, CI, worker, cron, izleme, yedek | Kod kalitesi |
| 6 | Tarihçe ve durum | Dönemler, dalların ana dala göre durumu, son işler, yarım işler, plan belgeleri | Güvenlik denetimi |
| 7 | Riskler | Geçmişte sır (yalnız var/yok + commit), yetki, rate limit, webhook imzası, bağımlılık yaşı, testsiz kritik yollar, mevcut denetim raporları | Ürün yorumu |

Kapsam dışı listesi şart: verilmezse her açı aynı config ve API dosyalarını baştan okur.
Her açının görev metnine şunları koy (tam metin `templates/learn-lens.md`):
- Klonun mutlak yolu, öğrenilen commit, ölçü sayıları, vault'tan bilinen gerçekler (tekrar etmek
  için değil, doğrulamak için).
- Yalnız oku: dosya değiştirme, `git checkout/pull/reset/stash/fetch`, paket kurma, build, test,
  deploy, veritabanı bağlantısı yok.
- `.env*`, anahtar, token **değerlerini** okuma/yazdırma; adları değer yazdırmayan komutla çıkar.
- Her bulguya kaynak: `dosya:satır` veya commit hash. Emin değilse "doğrulanmadı".
- Platform sınırını bil (macOS'ta `timeout` yok; ağ gerektiren komutu atla ve söyle).
- Hafıza/receipt yazma. Çıktı: maddeler, en çok ~700 kelime, sonda "Riskler" ve "Açık sorular".

### 5.3 Sentez ve çapraz doğrulama (ana ajan)
1. **İki açı çelişiyorsa veya iddia kritik bölüme giriyorsa (sır, geçerli config, deploy yolu,
   yetki), tek salt-okuma komutuyla kendin doğrula.** Alt ajanlar kendinden emin yanlış iddia
   üretebilir. Doğrulanmayan iddia "doğrulanmadı" olarak kalır.
2. **"X yok" iddiaları da doğrulanır**, özellikle "geçmişte sır yok". Vault'taki bilinen
   olaylarla karşılaştır ve hedefli, değer yazdırmayan arama yap
   (`git log --all -G '<DEGISKEN>\s*[=:]\s*\S{12,}' --format='%h %ad %s'`). Eşleşmeyi göstermeden
   önce maskele; yer tutucu (`***`, `<...>`) olup olmadığına bak.
3. Kartta geçen altyapıyı (ör. veritabanı host:port) kullanıcının kendi sistemi olduğu için tek,
   zararsız bir erişilebilirlik kontrolüyle teyit edebilirsin (`nc -z host port`). Tarama yapma.
4. Vault'taki daha yeni bilgi repo belgesinden önce gelir; repo belgesini "eski" diye işaretle.
5. Vault'taki notlarla çelişen bilgiyi sessizce ezme; açık sorulara koy.

### 5.4 Yaz ve doğrula
1. Kart: `projects/<proje>/README.md` (veya 0.3'teki eşlenen yol), iskelet
   `templates/project-card.md`. Kartın ilk satırı öğrenilen commit'i taşır; tazeleme buradan okur.
2. Projeye özgü kalıcı kurallar `projects/<proje>/Kurallar.md` (ör. "geçerli config yalnız X").
3. Öncelikli riskler ve açık sorular `Threads.md`'ye **tek** kayıt olarak.
4. `beyin.py project-scope add --folder <kart-klasörü> --project <proje>`; `bridge` kuruluysa
   proje kökünü köprüye ekle.
5. `beyin.py sync`, sonra `beyin.py context "<proje> hakkında somut bir soru>"`: kart kaynak
   olarak dönmeli. Dönmüyorsa öğrenme bitmemiştir.
6. `.vibeos/kurulum.json` → `vault.learned.<proje>`: `{"commit": "<hash>", "date": "YYYY-MM-DD",
   "angles": N}` (kartın ilk satırının aynası).
7. Geçici klonu sil.
8. Kullanıcıya rapor sırası: nasıl çalıştı (açı sayısı, süre), doğrulamanın neyi yakaladığı,
   öncelikli riskler (tek cümle öneriyle), tutarsızlıklar, onun kararını bekleyen sorular.

### 5.5 Tazele
"`<proje>`'yi tazele" denince:
1. Kartın ilk satırındaki commit'ten bu yana ne değiştiğine bak:
   `git log --oneline <commit>..origin/<ana-dal>` ve `git diff --stat <commit>..origin/<ana-dal>`
   (yerel kopya geride ise 5.1'deki gibi taze klon).
2. Değişen yolları açılara eşle (ör. şema/migration → veri; route/servis → mimari; package,
   deploy, CI dosyaları → operasyon; fiyat/landing/içerik → ürün; her durumda → tarihçe).
3. Değişiklik küçükse (birkaç commit, < ~20 dosya) diff'i ana ajan kendisi okur; büyükse yalnız
   etkilenen açılar alt ajanla yeniden çalışır.
4. Kartta yalnız ilgili bölümleri güncelle, ilk satırdaki commit'i yenile ve hemen altına tarihli
   "Değişenler" satırı ekle. Çözülen tutarsızlık ve soruları kapat. 5.4'teki geri okumayı tekrarla.

---

## 6. Kayıt: `.vibeos/kurulum.json`

Her çalıştırmanın sonunda güncelle (Git'te izlenir):
```json
{
  "vibeos": "1.1.1",
  "engine": {"name": "avenox-beyin", "series": "3"},
  "vault": {
    "layout": {"projects": "projects/", "meetings": "notes/gorusmeler/", "handoff": "notes/devir/", "knowledge": "knowledge/"},
    "sync": {"mode": "git", "remote": "github.com/<kullanıcı>/<repo>"},
    "learned": {"<proje>": {"commit": "<hash>", "date": "YYYY-MM-DD", "angles": 5}}
  },
  "machines": {
    "<makine-adı>": {"os": "macos", "modules": ["core", "sync", "assistant", "bridge"], "updated": "YYYY-MM-DD"}
  }
}
```
Makine adı için `uname -n` (Windows'ta `hostname`) kısa hali yeterli. Sır, kişisel yol dışında
bilgi veya token yazma. `sync` yoksa `vault.sync` alanını `null` bırak.

## 7. Kapanış özeti
Kullanıcıya kısa yaz: hangi sistem bulundu ve nasıl uyarlandı, hangi modüller kuruldu/güncellendi,
`AGENTS.md`'ye ne eklendi, hangi adımlar ona kaldı (güven onayı, token, yeni oturum testi),
sonradan modül eklemek için aynı isteği tekrar vermesinin yeterli olduğu. Motorun oturum kartı ve
receipt protokolünü uygula.

---

## Dersler (sahada yaşandı, tarife işlendi)

| Tuzak | Ne oldu | Kural |
|---|---|---|
| Başarı yalanı | Boş crontab'da `grep -v` 1 döndü, `set -e` betiği kesti ama ekrana "eklendi" yazıldı. | Mesaja değil `crontab -l` çıktısına bak. |
| Container kullanıcısı | `docker exec` root çalıştı, Hermes `hermes` kullanıcısıyla; eklenti dosyaları okunamadı. | Her container komutu `-u <hermes-kullanıcısı>`, gerekirse `chown`. |
| SSH agent ezilmesi | Arka arkaya iki `export SSH_AUTH_SOCK`, ikincisi (yanlış yol) birinciyi ezdi; sunucu parola sordu. | Agent soket yolunu tek ve doğru ver; parola istemi = yanlış anahtar. |
| Senkron sırası | Commit pull'dan önce olunca öbür makinenin yeni `.gitignore` kuralı geç uygulandı, makine dosyaları repoya gitti. | Önce fetch + pull, sonra commit. |
| Ağ yok = çakışma sanıldı | DNS hatası pull hatası gibi görünüp uyarı üretti. | Önce `fetch`; başarısızsa sessizce sonraki tura bırak. |
| Linux kısayolları | Kurulum `Beyni Güncelle.sh/.desktop` üretti, `.gitignore`'da yoktu, cron repoya bastı. | `.gitignore` bloğunu kurulumdan önce yaz. |
| launchd ve korumalı klasörler | Zamanlanmış görev harici diske ve korumalı klasörlere erişemedi. | Vault'u `~/` altında korumasız bir klasöre koy veya zamanlayıcıya izin ver; log'u kontrol et. |
| launchd PATH | launchd kabuk profilini okumaz, `git`/`python3` bulunamadı. | Plist'te `PATH`'i açıkça ver. |
| Container'dan host | Hermes'ten host cron'u kurması istendi; container içinden host'a erişemez. Hermes'in kendi zamanlanmış işi ise her turda model çağırır. | Senkron gibi işleri host zamanlayıcısına kur. |
| Global ayar | Ajan kendi global ayar dosyasını değiştiremedi (güvenlik sınıflandırıcısı). | Komutu kullanıcıya ver, kendisi çalıştırsın. |
| Aynalanan klasörde düzenleme | Sunucuda düzenlenen skill, bir sonraki aynalamada masaüstündeki kaynakla ezildi. | Tek yönlü aynalanan içeriği yalnız kaynağında düzenle. |
| Şişen oturum kartları | Last-Session sınırı aştı, bağlam kırpıldı. | `companion-compact` ile arşivle; dosyayı sıfırdan yazma. |
| Receipt çakışması | İki makine aynı `event_id` ile receipt yazınca add/add çakışması. | `event_id` sonuna oturum kimliğinin ilk 8 karakterini ekle. |
| Saat dilimi | Sunucu UTC'de, hatırlatma 3 saat kaydı. | Zamanlanmış işlerde saat dilimini açık yaz. |
| Kendinden emin alt ajan | Proje öğrenirken bir açı "Umami kodda yok" dedi; vardı. | Sentezde çelişen ve kritik iddiaları ana ajan tek komutla doğrular. |
| Eksik sır taraması | Risk açısı "geçmişte sır yok" dedi; vault'taki iş sırası notu tersini söylüyordu, hedefli arama secret'ı buldu. | Olumsuz iddiaları da doğrula; vault'taki bilinen olaylarla karşılaştır. |
| Eski dalı öğrenmek | Yerel kopya yan dalda ve ana daldan yüzlerce commit gerideydi. | Öğrenmeden önce dalı ve uzakla farkı kontrol et; gerekirse ana dalı geçici klasöre klonla. |
| Paylaşılan bot | Başkasına açılacak bot, ana asistanın vault/mail/terminal erişimini devralacaktı. | Ayrı profil, ayrı bot, minimum araç. |

## Manuel kaçış yolu
Ajanın ağ veya dosya yetkisi gerçekten yetersizse kullanıcıyı https://github.com/witcharon/vibeos
README'sine ve motorun manuel kurulumuna (https://avenox.io/ikincibeyin) yönlendir. Manuel
kurulumdan sonra aynı VibeOS isteği tekrar verilerek VibeOS katmanı ve modüller tamamlanır.
