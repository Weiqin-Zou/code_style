# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')

import json

#only filter the ForkEvent, WatchEvent and MemberEvent, i.e.,FWM_event
def filter_FWM_event(hist_json_fin,FWM_fout):
    try:
        repoKey1="repository"
        repoKey2="repo"
        for hist in hist_json_fin.xreadlines():
            try:
                hist=json.loads(hist)
                typeEvent=hist["type"]
                if repoKey1 in hist:
                    repoKey=repoKey1
                if repoKey2 in hist:
                    repoKey=repoKey2
                    print repoKey
                print hist[repoKey]["fork"]
                if typeEvent=="ForkEvent":
                    eventTime=hist["created_at"]
                    who=hist["actor"]["login"]
                    action="Fork"
                    print hist[repoKey]["fork"]
                    if hist[repoKey]["fork"] is false:
                        repoName="/".join(repo["url"].split('/')[-2:])
                        print typeEvent,eventTime,who,acton,repoName
                        break
                break
            except:
                traceback.print_exc()
    except:
        traceback.print_exc()
if __name__ == '__main__':
    try:
        hist_fin=sys.argv[1]
        FWM_event_fout=sys.argv[2]
        filter_FWM_event(file(hist_fin,'r'),file(FWM_event_fout,'w'))
    except:
        traceback.print_exc()


