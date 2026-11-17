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
