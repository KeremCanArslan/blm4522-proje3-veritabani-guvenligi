from flask import Flask, request, render_template_string
import psycopg2

app = Flask(__name__)

DB = {
    "dbname": "finans_guvenlik_db",
    "user": "banka_admin",
    "password": "Admin2026!",
    "host": "localhost",
    "port": "5432"
}

HTML = """
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Musteri Arama</title>
    <style>
        body { font-family: sans-serif; max-width: 800px; margin: 40px auto; padding: 20px; }
        h1 { color: #333; }
        form { margin-bottom: 20px; }
        input[type=text] { padding: 8px; width: 300px; }
        button { padding: 8px 16px; margin-left: 8px; cursor: pointer; }
        .guvensiz { background: #ffebee; border: 1px solid #c62828; padding: 12px; margin: 10px 0; }
        .guvenli { background: #e8f5e9; border: 1px solid #2e7d32; padding: 12px; margin: 10px 0; }
        table { border-collapse: collapse; width: 100%; margin-top: 12px; }
        th, td { border: 1px solid #ccc; padding: 6px 10px; text-align: left; }
        th { background: #f5f5f5; }
        .sql { font-family: monospace; background: #263238; color: #aed581; padding: 8px; font-size: 13px; }
    </style>
</head>
<body>
    <h1>Musteri Arama - SQL Injection Demosu</h1>
    <form method="GET">
        <input type="text" name="ad" value="{{ ad or '' }}" placeholder="Musteri adi girin...">
        <button type="submit" name="mod" value="guvensiz">Guvensiz Ara</button>
        <button type="submit" name="mod" value="guvenli">Guvenli Ara</button>
    </form>

    {% if mod == 'guvensiz' %}
    <div class="guvensiz">
        <strong>Mod: GUVENSIZ (string concatenation)</strong>
        <div class="sql">SELECT musteri_id, ad_soyad, sube_kodu FROM musteriler WHERE ad_soyad = '{{ ad }}'</div>
    </div>
    {% elif mod == 'guvenli' %}
    <div class="guvenli">
        <strong>Mod: GUVENLI (parameterized query)</strong>
        <div class="sql">SELECT musteri_id, ad_soyad, sube_kodu FROM musteriler WHERE ad_soyad = %s</div>
    </div>
    {% endif %}

    {% if hata %}
        <p style="color:red;"><strong>Hata:</strong> {{ hata }}</p>
    {% endif %}

    {% if sonuclar is not none %}
        <p>Bulunan kayit sayisi: <strong>{{ sonuclar|length }}</strong></p>
        {% if sonuclar %}
        <table>
            <tr><th>ID</th><th>Ad Soyad</th><th>Sube</th></tr>
            {% for r in sonuclar %}
            <tr><td>{{ r[0] }}</td><td>{{ r[1] }}</td><td>{{ r[2] }}</td></tr>
            {% endfor %}
        </table>
        {% endif %}
    {% endif %}
</body>
</html>
"""

@app.route("/")
def ara():
    ad = request.args.get("ad")
    mod = request.args.get("mod")
    sonuclar = None
    hata = None

    if ad is not None and mod:
        try:
            conn = psycopg2.connect(**DB)
            cur = conn.cursor()
            if mod == "guvensiz":
                sorgu = f"SELECT musteri_id, ad_soyad, sube_kodu FROM musteriler WHERE ad_soyad = '{ad}'"
                cur.execute(sorgu)
            else:
                cur.execute(
                    "SELECT musteri_id, ad_soyad, sube_kodu FROM musteriler WHERE ad_soyad = %s",
                    (ad,)
                )
            sonuclar = cur.fetchall()
            cur.close()
            conn.close()
        except Exception as e:
            hata = str(e)

    return render_template_string(HTML, ad=ad, mod=mod, sonuclar=sonuclar, hata=hata)

if __name__ == "__main__":
    app.run(debug=True, port=5001)
