from llm_client import generate_completion
import time

print("Testing Local LLM Connectivity...", flush=True)
start = time.time()
res = generate_completion("Respond with exactly one word: 'Connected'.")
print(f"Response: {res}", flush=True)
print(f"Time taken: {time.time() - start:.2f}s", flush=True)
