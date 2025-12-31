from kafka import KafkaConsumer, TopicPartition
import os
import json
import time

KAFKA_BROKER = os.getenv('KAFKA_BROKER', 'kafka:29092')

def get_lag():
    try:
        consumer = KafkaConsumer(
            bootstrap_servers=[KAFKA_BROKER],
            group_id='monitor_group',
            enable_auto_commit=False
        )
        
        total_lag = 0
        topics = ['gogobe.import.discovered', 'gogobe.import.downloaded']
        
        for topic in topics:
            partitions = consumer.partitions_for_topic(topic)
            if not partitions:
                continue
                
            for p in partitions:
                tp = TopicPartition(topic, p)
                # Get last offset (end of log)
                end_offsets = consumer.end_offsets([tp])
                last_offset = end_offsets[tp]
                
                # Get current committed offset for the actual consumer groups would be better,
                # but for now, let's just check if the topic is empty? 
                # No, we want to know if there is *pending work*.
                # Pending work = (End Offset) - (Committed Offset of Parser/Carrier).
                
                # This is hard to get from a generic consumer.
                # EASIER STRATEGY: 
                # Just check if we received any messages in the last X seconds? 
                # No, that's flaky.
                pass
        
        # Simpler approach for "IDLE" detection without complex Group coordination:
        # We can checks the Prometheus metrics if we had them.
        
        # Let's rely on the Consumer Groups API via AdminClient? 
        # kafka-python AdminClient is limited.
        
        # BACKUP PLAN:
        # Just check if the topics exist. 
        # Actually, let's use the 'kafka-consumer-groups.sh' command line tool available in the Confluent image
        # wrapper method.
        return "UNKNOWN"

    except Exception as e:
        print(f"Error: {e}")
        return "ERROR"

if __name__ == "__main__":
    # Since writing a python script to check lag reliably across consumer groups is complex without the right libs,
    # we will use the shell command in the manager script instead.
    print("Use kafka-consumer-groups.sh instead")
