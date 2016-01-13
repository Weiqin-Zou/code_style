# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')

import json

#only filter the ForkEvent, WatchEvent and MemberEvent, i.e.,FWM_event
def filter_FWM_event(hist_json_fin,FWM_fout,abnormalHist_fout):
    try:
        repoKey1="repo"
        repoKey2="repository"
        for hist in hist_json_fin.xreadlines():
            try:
                hist=json.loads(hist)
                typeEvent=hist["type"]
                if typeEvent in ("ForkEvent","WatchEvent","MemberEvent"):
                    eventTime=hist["created_at"]
                    if repoKey1 in hist:
                        repoUrl=hist[repoKey1]["url"]
                        if typeEvent in ("ForkEvent","WatchEvent"):
                            who=hist["actor"]["login"]
                    if repoKey2 in hist:
                        repoUrl=hist[repoKey2]["url"]
                        if typeEvent in ("ForkEvent","WatchEvent"):
                            who=hist["actor"]
                    if typeEvent=="ForkEvent":
                        action="Fork"
                    elif typeEvent=="WatchEvent":
                        action="Watch"
                    else:
                        who=hist["payload"]["member"]["login"]
                        action=hist["payload"]["action"]

                    repoName="/".join(repoUrl.split('/')[-2:])

                    print >>FWM_fout,"%s,%s,%s,%s,%s" % (repoName,typeEvent,eventTime,who,action)
            except:
                print >>abnormalHist_fout,hist
                traceback.print_exc()
    except:
        traceback.print_exc()
if __name__ == '__main__':
    try:
        hist_fin=sys.argv[1]
        FWM_event_fout=sys.argv[2]
        abnormal_fout=sys.argv[3]
        filter_FWM_event(file(hist_fin,'r'),file(FWM_event_fout,'a'),file(abnormal_fout,'a'))
    except:
        traceback.print_exc()


