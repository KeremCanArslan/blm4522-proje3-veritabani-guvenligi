# BLM4522 Vize Projeleri

Ankara Üniversitesi - Bilgisayar Mühendisliği  
Ağ Tabanlı Paralel Dağıtım Sistemleri (BLM4522)

**Öğrenci:** Kerem Can Arslan  
**Numara:** 19291092  
**Danışman:** Öğr. Gör. Enver BAĞCI

## İçerik

### Proje 1: Veritabanı Performans Optimizasyonu ve İzleme
PostgreSQL 16 üzerinde 1 milyon kayıtlı tablo oluşturuldu, darboğaz analizi yapıldı, indeks tasarımı ve bellek ayarları ile %40 hızlanma sağlandı.

### Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü
Aynı veritabanı motorunda rol tabanlı erişim, Row-Level Security, pgcrypto ile kolon bazlı şifreleme, SQL injection savunması ve trigger tabanlı audit log sistemi uygulandı.

## Kurulum

Proje 1:
createdb finans_db
psql -d finans_db -f proje1/sql/01_schema.sql
psql -d finans_db -f proje1/sql/02_optimization.sql

Proje 3:
Proje 3:
createdb finans_guvenlik_db
psql -d finans_guvenlik_db -f proje3/sql/01_schema.sql
psql -d finans_guvenlik_db -f proje3/sql/02_roller_rls.sql
psql -d finans_guvenlik_db -f proje3/sql/03_audit.sql
## Yapı
blm4522-vize-projeleri/
├── proje1/
│   ├── sql/
│   └── screenshots/
├── proje3/
│   ├── sql/
│   ├── flask-demo/
│   └── screenshots/
└── docs/
└── BLM4522_Proje_Raporu.pdf
