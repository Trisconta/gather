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
