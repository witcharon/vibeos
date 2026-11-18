# Değişiklikler

## 1.2.0 (2026-11-18)
- **Senkron kilitlenmez:** `.vibeos/sync.sh` sırası `pull --rebase` → commit yerine
  commit → merge → push. Yeni (izlenmeyen) dosyalar da önce commit'lenir; aynı adla iki makinede
  oluşan dosya senkronu durduramaz.
- **Çakışmada veri kaybı ve durma yok:** uzak sürüm yerinde kalır, yerel sürüm
  `<ad>.cakisma-<makine>-<zaman>.<uzantı>` olarak yanına yazılıp iki tarafa gider; bildirim bir kez.
- Öbür makinenin `.gitignore`'u commit'ten önce uygulanır; push yarışı ve ağ kopukluğu sessizce
  sonraki tura kalır; yarım kalmış rebase/merge durumları kendiliğinden temizlenir.
- Makineye özel ek adımlar için `.vibeos/sync.local.sh` kancası.
- Eski sürümü kullananlar: aynı VibeOS istemini tekrar verin; ajan betiği yeni sürümle değiştirir.

## 1.1.1 (2026-11-18)
- `learn` tamamlandı: hazır açı görev metinleri (`templates/learn-lens.md`) ve kart iskeleti
  (`templates/project-card.md`); git'siz projeler; alt ajanı olmayan istemcide sıralı çalışma;
  sentezde olumsuz iddiaların doğrulanması, maskeleme, vault > eski repo belgesi; kartın ilk satırı
  öğrenilen commit'in kaynağı; geçici klonun silinmesi; rapor sırası.
- "Tazele" gerçek bir projede denendi: değişen yollar açılara eşlenir, küçük diff'i ana ajan
  kendisi okur, kartın ilk satırı ve "Değişenler" satırı güncellenir.

## 1.1.0 (2026-11-18)
- Yeni yetenek `learn` ("projeyi öğren"): ön keşif, boyuta göre 3-7 paralel salt-okuma açısı,
  sentez ve çapraz doğrulama (olumsuz iddialar dahil), vault'a proje kartı + kurallar,
  `kurulum.json` → `vault.learned`, "tazele" ile yalnız değişen açılar. Kişisel site (4 açı) ve
  Connfig (7 açı) üzerinde denendi.

## 1.0.0 (2026-11-17)
- İlk yayın: tek tarifle kurulum, mevcut sistemlere uyum (Avenox Beyin V1-V3, Obsidian, PARA,
  ajan talimat dosyaları, başka hafıza araçları), modüller (`core`, `sync`, `assistant`,
  `bridge`), tekrar çalıştırmada eksik modülleri tamamlama, sahadan dersler.
