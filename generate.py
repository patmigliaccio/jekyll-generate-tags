import sys
from transformers import pipeline

content = sys.argv[1]
labels = sys.argv[2]

classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")

data = classifier(content, labels)

labels = data['labels']
scores = data['scores']

# Filter the labels based on the score
filtered_labels = [label for label, score in zip(labels, scores) if score > 0.30]

print(",".join(filtered_labels))