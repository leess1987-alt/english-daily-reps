"""Generate natural voice MP3s for every English line in the app with Kokoro (Apache-2.0).

Usage: python gen_audio.py <app.src.html> <out_dir> <model_dir>
File name = slug(text).mp3, the same slug the app computes in JS.
Sentences alternate between a female and a male US voice for listening variety.
"""
import json, re, sys, zlib
from pathlib import Path
import numpy as np
import soundfile as sf
from kokoro_onnx import Kokoro

src, out_dir, model_dir = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
out_dir.mkdir(parents=True, exist_ok=True)
html = src.read_text(encoding="utf-8")

def js_array(name):
    m = re.search(r"const %s=(\[.*?\]);\n" % name, html, re.S)
    return json.loads(m.group(1))

def slug(t):
    return re.sub(r"[^a-z0-9]+", "-", t.lower().replace("’", "'").replace("'", "")).strip("-")

words, sents = js_array("WORDS"), js_array("SENTS")
texts = {}  # text -> voice
for w in words:
    texts.setdefault(w[0], "af_heart")
    texts.setdefault(w[4], "af_heart")
for i, s in enumerate(sents):
    texts[s[0]] = "af_heart" if i % 2 == 0 else "am_michael"
# single words used as tap-to-hear blocks in the sentence builder
for s in sents:
    for w in re.sub(r"[.,?!]", "", s[0]).split():
        if not any(slug(t) == slug(w) for t in texts):
            texts[w] = "af_heart"
for ex, q, a in re.findall(r'ex:\["(.*?)",.*?q:\["(.*?)","(.*?)"', html):
    texts.setdefault(ex, "am_michael")
    texts.setdefault(q.replace("___", a), "af_heart")
texts.setdefault("Nice to meet you.", "af_heart")

kokoro = Kokoro(str(model_dir / "kokoro-v1.0.onnx"), str(model_dir / "voices-v1.0.bin"))

def trim(x, sr, thr=0.008, pad=0.06):
    idx = np.where(np.abs(x) > thr)[0]
    if not len(idx):
        return x
    p = int(sr * pad)
    return x[max(0, idx[0] - p): idx[-1] + p]

made = 0
for text, voice in texts.items():
    path = out_dir / (slug(text) + ".mp3")
    if path.exists():
        continue
    samples, sr = kokoro.create(text, voice=voice, speed=1.0, lang="en-us")
    sf.write(str(path), trim(samples, sr), sr, format="MP3")
    made += 1
    print(f"{voice:11s} {path.name}")
print(f"done: {made} new, {len(texts)} total")
