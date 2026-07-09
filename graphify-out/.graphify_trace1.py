import json
import networkx as nx
from networkx.readwrite import json_graph
from pathlib import Path

data = json.loads(Path('graphify-out/graph.json').read_text(encoding="utf-8"))
G = json_graph.node_link_graph(data, edges='links')

for nid in ["dashboard_screen_macro_card", "stats_screen_macro_bar_chart"]:
    if nid not in G:
        print(f"MISSING: {nid}")
        continue
    d = G.nodes[nid]
    print(f'NODE {nid}: {d.get("label")} | file={d.get("source_file")} | type={d.get("file_type")} | degree={G.degree(nid)}')
    for neighbor in G.neighbors(nid):
        _raw = G[nid][neighbor]
        edge = next(iter(_raw.values()), {}) if isinstance(G, nx.MultiGraph) else _raw
        print(f'   --{edge.get("relation")}[{edge.get("confidence")} {edge.get("confidence_score")}]--> {G.nodes[neighbor].get("label", neighbor)}  (loc={edge.get("source_location")})')
    print()
