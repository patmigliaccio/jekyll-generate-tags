import sys
from transformers import pipeline

content = sys.argv[1]
tags = sys.argv[2]
confidence = float(sys.argv[3])

classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")

data = classifier(content, tags)

labels = data['labels']
scores = data['scores']

# Filter the labels based on the score
filtered_labels = [label for label, score in zip(labels, scores) if score > confidence]

print(",".join(filtered_labels))