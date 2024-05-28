from openai import OpenAI

client = OpenAI(
  base_url="http://127.0.0.1:4000",
  api_key="sk-1234"
)

completion = client.chat.completions.create(
  model="llama3",
  messages=[
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Hello!"}
  ],
  user="my-customer-id"
)

print(completion.choices[0].message)
