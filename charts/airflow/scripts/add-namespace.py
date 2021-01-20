#!/usr/bin/env python

import yaml
import sys

def addNamespace(namespace, manifest):
    if 'metadata' in manifest and 'namespace' not in manifest['metadata'] and 'Namespace' not in manifest['kind']:
        manifest['metadata']['namespace'] = namespace
    if 'subjects' in manifest:
        manifest['subjects'][0]['namespace'] = namespace
def removeReplicasFromWorkerStatefulSet(manifest):
    if manifest['kind'] == 'StatefulSet' and manifest['metadata']['name'] == 'airflow-worker':
        del manifest['spec']['replicas']


def addingNamespace(namespace):
    for manifest in yaml.load_all(sys.stdin, Loader=yaml.FullLoader):
        if manifest:
            addNamespace(namespace, manifest)
            removeReplicasFromWorkerStatefulSet(manifest)
            print ('---')
            print (yaml.dump(manifest, default_flow_style=False, sort_keys=False))

namespace="osdu"
addingNamespace(namespace)
