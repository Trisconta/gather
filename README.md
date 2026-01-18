# gather
- Gathers several music and playlist related scripts and database(s)

Structure, in a nutshell:
```text
gather/
  +-- external/
  |     +-- dztxt-data
  |     +-- dzr-plays
  +-- scripts/
  +-- README.md
```
Hint:
- Use a simple native linux command to obtain a more detailed tree, as follow:
  * `find . -type d | sed 's/[^-][^\/]*\//  |/g;s/|\([^ ]\)/|-- \1/'`
  * Although `referral` from _Trisconta_ is a submodule referred here (at `gather), it is not referenced in this README, as it is orthogonal to the remaining modules/ submodule.

## Getting updates done in a nutshell
If `raw-*` text files are up to date, which is usually the case, do:
1. `(cd ~/anaceo/Trisconta/wsound/gather; ./update_dzdb.sh)`
1. `(cd ~/anaceo/Trisconta/wsound/gather; ./several.sh --skip)`
   + The first updates `external/dztxt-data`
     * Hint: list latest changes using `lsa -v external/dztxt-data`
   + The latter creates `/tmp/playlists.html` and uploads it into the server
     * Hint: using `jadata-samples` script `upload_playlists.sh`

If you want just to upload the latest playlists without a database update,
1. Upload textual playlists to server:
   + `(cd ../gather/external/jadata-samples && ./upload_playlists.sh)`


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

## About dztxt-data
Textual database with records of DZR online.

### Updating dztxt-data
A quick way to update said `dztxt-data` (which has its own repo) is to run `update_dzdb.sh` bash script at **gather** repo/ directory.
After a successful run, you should be able to see which new tracks have been added to the database. Example:
1. `henrique@pino:~/anaceo/Trisconta/wsound/gather/external/dztxt-data> git diff | grep ^+ | grep get_names.sh.--get-t`
