# <Proje adı> — proje kartı

> "Projeyi öğren" ile çıkarıldı · <YYYY-MM-DD> · commit `<hash>` (<dal>) · <N> açı (<liste>) + vault eşleştirmesi. Kaynak gösterilmeyen yorumlar "doğrulanmadı" işaretli. Tazelemek için: "<proje>'yi tazele" → yalnız `<hash>..<ana-dal>` incelenir.
>
> <Tazelemelerde buraya tarihli "Değişenler" satırı eklenir; en yenisi üstte.>

## Künye
- **Dizin:** <yerel yol> (yerel kopya: dal, ana dalın kaç commit gerisi) · **Repo:** <owner/repo> (<private/public>)
- **Canlı:** <adresler> · **Deploy:** <yol, süre>
- **Stack:** <framework, DB/ORM, önemli kütüphaneler>
- **Komutlar:** <dev / build / test / lint>
- **İlgili notlar:** <vault bağlantıları>

## Ne
<Ne yapar, kimin için.> Özellik haritası, plan ve fiyatlar (kaynaklı). Vault bağlantıları
(görüşmeler, gelir, müşteri).

## Mimari
| Servis | Dizin / giriş | Sorumluluk | Neyle konuşur |
|---|---|---|---|

İstek akışı, auth, geçerli config dosyaları, ölü/çift kod.

## Veri
DB/ORM, ana tablo grupları, tenant izolasyonu, migration yolu, saklama/silme.

## Entegrasyonlar
| Servis | Ne için |
|---|---|

Webhook'lar. Env ADLARI (değer asla), belge-kod farkı.

## Operasyon
Süreçler, zamanlanmış işler, CI, test kapsamı, izleme, yedek.

## Tarihçe
Dönemler tek satırda zincir; dalların durumu; yarım işler.

## Riskler (öncelik sırasıyla)
1. **<risk>** (kaynak). Öneri: <tek cümle>.

Olumlu kontroller: <...>

## Tutarsızlıklar
- <A> ↔ <B> (kaynaklar)

## Açık sorular
- <kullanıcının kararını bekleyen soru>
