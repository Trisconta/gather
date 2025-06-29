import tuna

def coarse():
    tunes = tuna.itresume.ItResume(xml_path="/home/henrique/anaceo/Trisconta/other/tuna/itunes.xml")
    dct_idx = tunes.get_simple("track-to-index")
    return (tunes, dct_idx)

def dig(tunes, track_id):
    assert isinstance(track_id, str), f"dig(): {tunes.name}"
    dct_idx = tunes.get_simple("track-to-index")
    info = tunes.track(dct_idx[track_id][0])
    other, track_info = info
    return (track_info, [other])

