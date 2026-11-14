"""Refresh Scholar data; preserve the published snapshot if Scholar blocks access."""

import json
import logging
import os
import signal
from datetime import datetime, timezone
from pathlib import Path

from scholarly import scholarly
from scholarly._proxy_generator import MaxTriesExceededException

logging.basicConfig(level=logging.INFO)


class ScholarFetchTimeout(BaseException):
    """The entire fetch exceeded its time budget."""


def fetch_timeout(signum, frame):
    raise ScholarFetchTimeout()


def main():
    scholar_id = os.environ.get('GOOGLE_SCHOLAR_ID', '').strip()
    if not scholar_id:
        raise ValueError('Set the GOOGLE_SCHOLAR_ID repository secret before running this task.')

    scholarly.set_timeout(20)
    scholarly.set_retries(2)
    # scholarly can retry HTTP 403 forever without consuming its retry count.
    previous_handler = signal.signal(signal.SIGALRM, fetch_timeout)
    signal.alarm(180)
    try:
        author = scholarly.search_author_id(scholar_id)
        scholarly.fill(author, sections=['basics', 'indices', 'counts', 'publications'])
    except (MaxTriesExceededException, ScholarFetchTimeout):
        # No new files or publish output: the last successful snapshot stays intact.
        message = 'Google Scholar could not be reached or blocked this request. Keeping the last successful citation data; the next scheduled run will try again.'
        if os.environ.get('GITHUB_ACTIONS') == 'true':
            print(f'::warning::{message}')
            summary = os.environ.get('GITHUB_STEP_SUMMARY')
            if summary:
                with open(summary, 'a') as stream:
                    stream.write(message + '\n')
            return
        raise
    finally:
        signal.alarm(0)
        signal.signal(signal.SIGALRM, previous_handler)

    author['updated'] = datetime.now(timezone.utc).isoformat()
    author['publications'] = {v['author_pub_id']: v for v in author['publications']}
    shieldio_data = {
        'schemaVersion': 1,
        'label': 'citations',
        'message': str(author['citedby']),
    }
    results = Path('results')
    results.mkdir(exist_ok=True)
    for filename, data in [('gs_data.json', author), ('gs_data_shieldsio.json', shieldio_data)]:
        with (results / filename).open('w') as stream:
            json.dump(data, stream, ensure_ascii=False)
    output = os.environ.get('GITHUB_OUTPUT')
    if output:
        with open(output, 'a') as stream:
            stream.write('updated=true\n')
    logging.info('Updated citation data for %s: %s citations', author['name'], author['citedby'])


if __name__ == '__main__':
    main()
