# Açı görevi şablonu (`learn`)

Her açı için bir alt ajan görevi. `<...>` alanlarını doldur; **ORTAK** bölümü her göreve aynen
koy, **AÇI** bölümünden yalnız ilgili olanı ekle. Kanonik tarif: `vibeos.md` §5.

---

## ORTAK

Bu bir VibeOS "projeyi öğren" incelemesi. Proje: <ad> (<tek cümle: ne yapar>).

Kod (incelemeyi BURADAN yap):
- <rol, ör. Uygulama>: <mutlak yol> (<dal> @ <commit>, <N> commit, <N> izlenen dosya, ~<N> satır;
  üst klasörler: <klasör dosya-sayısı, ...>)
- <varsa ikinci repo/klasör>

Vault'tan bilinenler (doğrulamak için; repodan teyit edemezsen öyle söyle):
- <ör. deploy yolu, sunucu, bilinen olaylar>

Kurallar:
- Yalnız oku. Dosya değiştirme; `git checkout/pull/reset/stash/fetch` yok; paket kurma, build,
  test, deploy, veritabanı bağlantısı yok.
- `.env*`, anahtar ve token DEĞERLERİNİ okuma/yazdırma. Adları değer yazdırmayan komutla çıkar
  (`grep -o '^[A-Z_][A-Z0-9_]*' dosya`, kodda `process.env.X` araması). Geçmişte sır taraması
  yalnız var/yok + commit hash + dosya adı döndürür.
- Her bulguya kaynak ver: `dosya:satır` veya commit hash (yollar repo köküne göre).
  Emin olmadığını "doğrulanmadı" diye işaretle.
- Platform: <ör. macOS, `timeout` yok>. Ağ gerektiren komutu çalıştırma; atladığını söyle.
- Hafızaya, nota, receipt'e yazma.
- Önce projenin kendi anlatımına bak (README, AGENTS.md, docs/), sonra kodla doğrula.
- Çıktı: <dil>, maddeler halinde, en çok ~700 kelime; sonda "Riskler" ve "Açık sorular".

---

## AÇI

### 1 · Ürün
Hedef: ne yapar, kimin için; özellik haritası (sayfalar/modüller); plan ve fiyatlar; onboarding;
landing/pazarlama mesajları, içerik ve SEO.
Kapsam dışı: kod mimarisi ayrıntısı, veri şeması, deploy. Fiyatı kaynakla ver; iki kaynak
farklıysa ikisini de yaz.

### 2 · Mimari
Hedef: dizin haritası; servisler ve nasıl konuştukları (tablo: servis | dizin | giriş |
sorumluluk | neyle konuşur); istek akışı; auth yolu; kuyruk/iş sistemi; geçerli config dosyaları;
ölü/çift kod.
Kapsam dışı: tablo/kolon ayrıntısı, dış servis listesi, deploy.

### 3 · Veri
Hedef: DB ve ORM; şema dosyaları; ana tablolar ve ilişkiler (en önemli ~15'i tek satırla);
migration yolu ve sayısı; önemli indeksler; tenant izolasyonu; saklama/silme (KVKK/GDPR).
Kapsam dışı: dış API'ler, deploy, UI.

### 4 · Entegrasyonlar
Hedef: dış servisler ve ne için (tablo: servis | ne için | dosya); webhook uçları ve nasıl
doğrulandıkları; env ADLARI servise göre gruplu; belge (`.env.example`, kurulum belgesi) ile kod
arasındaki fark.
Kapsam dışı: deploy/CI, veri şeması.

### 5 · Operasyon
Hedef: çalıştırma/build/test komutları; her süreç için ad, başlatma komutu, kaynak; deploy yolu;
CI; zamanlanmış işler; test altyapısı ve kapsamı; izleme/loglama/hata takibi; yedek.
Kapsam dışı: kod kalitesi, ürün.

### 6 · Tarihçe ve durum
Hedef: dönemler (`git log --format='%ad %s' --date=short`, ay bazında commit sayısı); uzak
dalların ana dala göre ileri/geri sayısı ve son tarihi; son 30 günün işleri; plan/denetim
belgeleri; TODO/FIXME; yarım işler. Kullanıcının yerel kopyası farklı daldaysa o commit'in ana
dalda olup olmadığını ve kaç commit geride olduğunu ver.
Kapsam dışı: güvenlik denetimi.

### 7 · Riskler
Hedef: geçmişte sır (var/yok + commit + dosya); yetki ve tenant izolasyonu; rate limit;
webhook imzaları; e-posta/itibar riskleri (varsa); bağımlılık yaşı ve bilinen açıklar; testsiz
kritik yollar; mevcut denetim raporlarının açık bulguları (kendi bulgularından ayrı).
Kapsam dışı: ürün yorumu, mimari anlatım. Öncelik sırası (kritik/yüksek/orta), her birine tek
cümle öneri. Olumlu kontrolleri de ayrı listele.
