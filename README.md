# gather
- Gathers several music and playlist related scripts and database(s)


## dzr-plays
My own playlists.


## dzdb
Repository sources:
+ https://github.com/trisconta/dzdb
+ Currently private

### Quick dive
```
from jadata import dzdata

zdat = dzdata.ZData("/home/henrique/anaceo/Trisconta/wsound/gather/external/dztxt-data")
assert '+'.join(sorted(zdat.get_all())) == 'album+artist+track', "Three keys"

# ...the Singer(s)
art = zdat.get_artists()
assert len(art) >= 1, "No artist!?"
assert art["1"] == "The Beatles", "Number one...artist :)"
obj_singers = zdat._data["artist"]
assert obj_singers.kind == "S", "Kind should be Singers ('S')"
# sorted(obj_singers.get_data()) is ['by-key', 'seq']
# print(obj_singers) shows: schema=[('artist',), 'dbz-artist', ['dartist.tsv']]
assert len(obj_singers._data["by-key"]) == len(obj_singers._data["seq"]), "By Key or Sequence have the same size"

# ...the Track(s)
trk = zdat.get_tracks()
obj_tracks = zdat._data["track"]
assert obj_tracks.kind == "T", "Kind should be Tracks ('T')"
first = obj_tracks.get_data()["seq"][0]
assert '+'.join(sorted(first, key=str.lower)) == 'Desc+Dur+Title+TMainArtist+track', "Unexpected"
# print(first["Title"]) shows, e.g. P.Y.T. (Pretty Young Thing)
```

### Dive on Playlist Database (dztxt-data)
```
import os, jadata.dzall
b_dir = os.environ.get("HREPO", os.environ["HOME"])
dza = jadata.dzall.DAll(os.path.join(b_dir, "Trisconta/wsound/gather/external/dzr-plays/lists"))
# Get one dzr playlist
res = dza.dig_play("14155169121")
assert (isinstance(res, list), 1 < len(res) <= 40) == (True, True), "Bogus"
# Get all dzr playlists
pls = dza.get_ref_plays()
# Display all Pn playlists
for p_idx, play_id, play_name in pls:
    res = dza.dig_play(play_id)
    empty = len([ala for ala in res if not ala])
    show = f"#{len(res)} empty={empty}"
    print(p_idx, int(play_id), play_name, "; tracks:", show)
# A specific one...
p_idx, play_id, play_name = "P34\t13346388723\tHiding Behind Scenes".split("\t")
dza.dig_play("P34")	# shows [('P34', '13346388723', 'Hiding Behind Scenes')]
# Now dig into the playlist
rpl = dza.get_play_bynum()["13346388723"]
assert rpl.name == "raw-13346388723.txt", rpl.name
assert rpl.get_num() == "13346388723", rpl.get_num()
# Show tracks of that playlist
for idx in rpl.by_index():
    trip = rpl.by_index()[idx]
    lst = dza.dig(trip[0])
    dct = lst[0] if lst else None
    print(idx, f'{dct["TMainArtist"]} / {dct["Title"]}' if dct else trip)
```
