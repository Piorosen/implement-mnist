import tensorflow_datasets as tfds
import os
import argparse

def convert_numpy_to_cpp(weight):
    result = ""
    data = weight / 255.
    for y in data:
        for x in y:
            result += "{:.4f} ".format(x)
        result += "\n"
    result = result.strip(' ')
    return result

def save(output: str):
    train_data = tfds.load('mnist', split='train', as_supervised=True, shuffle_files=False)
    index = 0
    for image, label in train_data.take(1000):
        label_np = label.numpy()
        print(label_np)
        image_np = image.numpy().reshape((28,28))
        
        text = convert_numpy_to_cpp(image_np)

        with open(os.path.join(output, "{0}-{1}.txt".format(str(label_np).rjust(1, '0'),
                                                str(index).rjust(4, '0'))), "wt+") as f:
            f.write(text)
        index += 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate')

    parser.add_argument("--output", type=str, default='../tests')
    args = parser.parse_args()

    save(args.output)
