"""Stage a reversible, bounded IPE replay with exact built-module identities."""
from pathlib import Path
import ast,hashlib,io,json,shlex,struct,sys,tarfile
import host
HERE=Path(__file__).resolve().parent;P=host.PRIVATE
attempt=sys.argv[1] if len(sys.argv)>1 else 'r1';assert attempt.startswith('r') and attempt[1:].isdigit() and 1<=int(attempt[1:])<=20
if (HERE/'incident-validation.json').exists():
 assert (HERE/'camera-recovery-validation.json').exists() and json.loads((HERE/'camera-recovery-validation.json').read_text())['passed'],'Recover and verify the device before another experiment'
assert json.loads((P/'intree-build-state.json').read_text())['terminal']
build=json.loads((HERE/'intree-build-validation.json').read_text());assert build['passed'] and not build['diagnostics']
assert json.loads((HERE/'runtime-validation.json').read_text())['passed']
probe=json.loads((HERE/'client-build-validation.json').read_text());assert probe['passed']
assert probe['source_sha256']==hashlib.sha256((HERE/'pd10-ipe.c').read_bytes()).hexdigest()
assert probe['probe_sha256']==hashlib.sha256((P/'pd10-ipe').read_bytes()).hexdigest()
prefix=(HERE.parent/'kernel342/native-install.py').read_text().split('def versions():')[0].replace("'stage':342","'stage':429")
body=(HERE.parent/'kernel428/multicamera-worker-body.py').read_text()
a=body.index(" expected_jobs=793");z=body.index(" items=services();",a)
body=body[:a]+''' prior=json.loads(Path('/var/lib/samurai/k428-ds4-r6/state.json').read_text())
 assert prior['terminal'] and prior['passed'] and prior['formal_modules_restored'] and prior['services_restored']
 assert notes()==prior['before_notes']
 assert status()['jobs']==status()['completed']==0 and not any(status()[k] for k in ['users','running','fatal','pinned','orphans','failed','cancelled','first_error'])
'''+body[z:]
a=body.index(" state['captures']={}");z=body.index(" state['candidate_final_status']",a)
body=body[:a]+''' import fcntl
 video=[str(Path('/dev')/p.parent.name) for p in Path('/sys/class/video4linux').glob('video*/name') if p.read_text().strip()=='qcom-ipe-a5']
 assert len(video)==1,video
 media=[]
 for path in Path('/dev').glob('media[0-9]*'):
  try:
   with path.open('rb',buffering=0) as f:
    data=bytearray(256);fcntl.ioctl(f.fileno(),0xc1007c00,data,True)
   model=bytes(data[16:48]).split(b'\\0')[0].decode()
   if model=='SM8150 IPE':media.append(str(path))
  except OSError:continue
 assert len(media)==1,media
 case=root/'replay';case.mkdir()
 for name in ['full-private.bin','pd10-private.bin','parameters-private.bin']:shutil.copyfile(root/name,case/name)
 with (case/'client.log').open('xb') as log:
  child=subprocess.Popen([str(root/'pd10-ipe'),video[0],media[0],str(case)],stdin=subprocess.DEVNULL,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  save('replaying-real-pd10',client_pid=child.pid);code=child.wait(timeout=55)
 text=(case/'client.log').read_text(errors='replace');state['replay_exit_code']=code
 assert code==0 and 'PD10_IPE_RESULT result=0 frames=4' in text,text[-3000:]
 idle();s=status();assert s['jobs']==s['completed']==s['direct_completed']==4 and not any(s[k] for k in ['failed','cancelled','first_error','fatal'])
 state['frames']=4;state['live_sensor_capture']=False
'''+body[z:]
body=body.replace("  if changed:\n   idle()", "  if changed:\n   if not released(core()) or status()['fatal']:\n    (dev/'cleanup').write_text('1\\n')\n   idle()")
source=prefix+'\n'+body;ast.parse(source);(P/'runtime-worker.py').write_text(source)
files={'worker.py':P/'runtime-worker.py','pd10-ipe':P/'pd10-ipe'}
for name in ['full-private.bin','pd10-private.bin','parameters-private.bin']:files[name]=P/name
proof={'modules':{}}
for row in build['modules']:
 if not row['runtime_candidate']:continue
 path=Path(row['private_path']);raw=path.read_bytes();assert hashlib.sha256(raw).hexdigest()==row['sha256']
 shoff=struct.unpack_from('<Q',raw,40)[0];stride,count,strings=struct.unpack_from('<HHH',raw,58)
 sections=[struct.unpack_from('<IIQQQQIIQQ',raw,shoff+i*stride) for i in range(count)];names=raw[sections[strings][4]:sections[strings][4]+sections[strings][5]]
 note=next(s for s in sections if names[s[0]:].split(b'\0')[0]==b'.note.gnu.build-id');name=row['name'].replace('-','_');filename=row['name']+'.ko'
 files[filename]=path;proof['modules'][name]=dict(file=filename,sha256=row['sha256'],note_sha256=hashlib.sha256(raw[note[4]:note[4]+note[5]]).hexdigest())
(P/'runtime-proof-private.json').write_text(json.dumps(proof,indent=2)+'\n');files['proof.json']=P/'runtime-proof-private.json'
manifest={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in files.items()};payload=io.BytesIO()
with tarfile.open(fileobj=payload,mode='w:gz') as tar:
 for n,p in files.items():tar.add(p,arcname=n)
 data=json.dumps(manifest).encode();member=tarfile.TarInfo('manifest.json');member.size=len(data);tar.addfile(member,io.BytesIO(data))
code='''from pathlib import Path
import hashlib,io,json,os,sys,tarfile
root=Path(ROOT);assert not root.exists()
assert Path('/proc/sys/kernel/random/boot_id').read_bytes()==Path('/var/lib/samurai/k394-recovered/boot-id-private.txt').read_bytes()
tar=tarfile.open(fileobj=io.BytesIO(sys.stdin.buffer.read()),mode='r:gz');members=tar.getmembers();assert {m.name for m in members}==NAMES and all(m.isfile() for m in members)
root.mkdir(mode=0o700)
for m in members:
 with (root/m.name).open('xb') as f:f.write(tar.extractfile(m).read());f.flush();os.fsync(f.fileno())
for n,digest in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/n).read_bytes()).hexdigest()==digest
(root/'pd10-ipe').chmod(0o700)
print(json.dumps(dict(staged=True,root=str(root),passed=True)))
'''.replace('ROOT',repr('/var/lib/samurai/k429-pd10-ipe-'+attempt)).replace('NAMES',repr(set(files)|{'manifest.json'}))
q=host.ssh('python3 -c '+shlex.quote(code),input=payload.getvalue(),timeout=30);print(q.stdout.decode());q.check_returncode()
(HERE/('runtime-staging-'+attempt+'-validation.json')).write_bytes(q.stdout)
