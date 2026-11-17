# Katkı rehberi

VibeOS'un kalbi [`vibeos.md`](vibeos.md): ajanların okuyup uyguladığı kurulum tarifi. Bir
değişiklik binlerce farklı klasörde, farklı ajanlarla çalışacak; bu yüzden kurallar basit.

## Issue
- Hangi ajan (Claude Code, Codex, Hermes, ...), hangi işletim sistemi, hangi modüller.
- Ajanın hangi adımda takıldığı ve **gerçek çıktı** (hata mesajı, çıkış kodu).
- Notlarını, kişisel yollarını, token veya anahtarlarını paylaşma; gerekiyorsa maskele.

## Pull request
- **Küçük tut.** Bir PR, bir değişiklik.
- **Test et.** Değişikliği en az bir ajanla gerçek bir klasörde dene (tercihen hem boş klasörde
  hem mevcut notları olan bir klasörde). PR açıklamasına hangi ajanla, hangi işletim sisteminde
  denediğini ve sonucu yaz.
- **Kullanıcı notlarını koru.** Tarif hiçbir koşulda kullanıcı dosyasını silmemeli, taşımamalı,
  ezmemeli. Bu kuralı gevşeten PR kabul edilmez.
- **Sır yok.** Örneklerde gerçek token, alan adı, IP veya kişisel yol kullanma.
- **Motor değişiklikleri** VibeOS'un değil [Avenox Beyin](https://github.com/avenoxai/avenoxbeyin)
  deposunun konusudur; orada aç.

## Yeni ders eklemek
`vibeos.md` → Dersler tablosuna tek satır: **Tuzak | Ne oldu | Kural**. Kural, bir sonraki ajanın
uygulayabileceği kadar somut olmalı. İlgili adımın metnine de kuralı işle; tablo tek başına yetmez.

## Sürümleme
`vibeos.md` başlığındaki ve `.vibeos/kurulum.json` şablonundaki sürüm birlikte artar.
Kullanıcı tarafında davranışı değiştiren her değişiklik için `CHANGELOG.md`'ye satır ekle.
