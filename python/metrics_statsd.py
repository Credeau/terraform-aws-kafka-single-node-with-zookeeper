'''
This script exports Kafka consumer group metrics to CloudWatch
'''
import time
import subprocess
import pandas as pd
import statsd


statsd_client = statsd.StatsClient(host='localhost', port=8125, prefix=None)

# Define the command to collect consumer group metrics
BIN = "kafka_2.13-3.8.0/bin/kafka-consumer-groups.sh"

# Define the consumer groups to collect metrics for
CONSUMER_GROUPS = [
    "sms-consumer-group",
    "events-consumer-group",
    "common-consumer-group"
]

def get_group_metrics(consumer_group):
    '''
    Get the consumer group metrics for a given group
    '''
    opts = ["--bootstrap-server", "127.0.0.1:9092", "--describe", "--group", consumer_group]
    cmd = f"{BIN} {' '.join(opts)}"

    try:
        result = subprocess.run(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            universal_newlines=True,
            check=True
        )

        output = result.stdout.strip()
        if not output:
            print(f"No output for group: {group}")
            return None

        lines = [line.split() for line in output.split("\n")]
        if len(lines) < 2:  # No data or only headers
            print(f"No data for group: {group}")
            return None

        headers = [h.lower() for h in lines[0]]
        data = lines[1:]
        return pd.DataFrame(data, columns=headers)
    except subprocess.CalledProcessError as e:
        print(f"Error processing group {group}: {str(e)}")
        return None

def safe_int(value):
    '''
    Convert a value to an integer, returning 0 if the conversion fails
    '''
    try:
        return int(value)
    except Exception:
        return 0

while True:
    for group in CONSUMER_GROUPS:
        df = get_group_metrics(group)
        if df is not None:
            print(df)

            total_lags = {}

            for row_i in range(df.shape[0]):
                row = df.iloc[row_i]

                lag = safe_int(row.get("log-end-offset", 0)) - safe_int(row.get("current-offset", 0))

                if f'topic.{row.group}.{row.topic}.lag' in total_lags:
                    total_lags[f'topic.{row.group}.{row.topic}.lag'] += lag
                else:
                    total_lags[f'topic.{row.group}.{row.topic}.lag'] = lag

                statsd_client.gauge(
                    f'topic.{row.group}.{row.topic}.partition{row.partition}.lag',
                    lag
                )

                statsd_client.gauge(
                    f'topic.{row.group}.{row.topic}.partition{row.partition}.consumeroffset',
                    safe_int(row["current-offset"])
                )

                statsd_client.gauge(
                    f'topic.{row.group}.{row.topic}.partition{row.partition}.receivedoffset',
                    safe_int(row["log-end-offset"])
                )

            for topic, lag in total_lags.items():
                statsd_client.gauge(
                    topic,
                    lag
                )

    time.sleep(1)
