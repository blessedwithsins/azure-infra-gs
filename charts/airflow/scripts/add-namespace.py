#!/usr/bin/env python

import yaml
import sys

def addingNamespace(namespace):
    for manifest in yaml.load_all(sys.stdin, Loader=yaml.FullLoader):
        if manifest:
            if 'metadata' in manifest and 'namespace' not in manifest['metadata'] and 'Namespace' not in manifest['kind']:
                manifest['metadata']['namespace'] = namespace
            if 'subjects' in manifest:
                manifest['subjects'][0]['namespace'] = namespace
            print ('---')
            print (yaml.dump(manifest, default_flow_style=False, sort_keys=False))

namespace="osdu"
addingNamespace(namespace)
