from pathlib import Path
import sys
p = Path(sys.argv[1])
d = p.read_bytes()
out = bytearray()
i = frames = stray = 0
while i < len(d):
    if d[i] == 0x90 and i + 1 < len(d) and 0 < d[i+1] <= 64 and i + 2 + d[i+1] <= len(d):
        n = d[i+1]
        out.extend(d[i+2:i+2+n])
        i += 2+n
        frames += 1
    else:
        i += 1
        stray += 1
text = out.decode('ascii', errors='replace')
p.with_suffix('.txt').write_text(text, encoding='utf-8')
print(f'{p.name}: bytes={len(d)} frames={frames} stray={stray}')
print('\n'.join(line for line in text.splitlines() if 'eud:' in line))
