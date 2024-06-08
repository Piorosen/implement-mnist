import tensorflow as tf
from jinja2 import Template
import argparse

def load_from_h5(file: str):
    model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=(7, 7)),
    tf.keras.layers.Dense(30, activation='relu'),
    tf.keras.layers.Dense(10)
    ])

    model.load_weights(file)
    
    model.summary()
    model.get_weight_paths().keys()
    weight = model.get_weight_paths()

    dense1_kernel = weight['dense.kernel'].numpy()
    dense1_bias = weight['dense.bias'].numpy()
    dense2_kernel = weight['dense_1.kernel'].numpy()
    dense2_bias = weight['dense_1.bias'].numpy()
    return (dense1_kernel, dense1_bias,
            dense2_kernel, dense2_bias)

def convert_numpy_to_cpp(weight, is_bias = False):
    result = ""
    data = weight.T
    if is_bias:
        for y in data:
            result += "{:.4f},".format(y)
    else:
        for y in data:
            for x in y:
                result += "{:.4f},".format(x)
    result = result.strip(',')
    return result


def generate_hpp_code_using_template(h5_file: str,
                                     template_file: str, output: str):
    dense1_kernel, dense1_bias, dense2_kernel, dense2_bias = load_from_h5(h5_file)
    
    with open(template_file) as f:
        template = Template(f.read())

    result = template.render({
            'dense1_weight': convert_numpy_to_cpp(dense1_kernel),
            'dense1_bias': convert_numpy_to_cpp(dense1_bias, True),
            'dense2_weight':  convert_numpy_to_cpp(dense2_kernel),
            'dense2_bias': convert_numpy_to_cpp(dense2_bias, True),
        })

    with open(output, "wt+") as f:
        f.write(result)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate')

    parser.add_argument("--h5_file", type=str, default='./model_weight.h5')
    parser.add_argument("--template_file", type=str, default='./template.hpp')
    parser.add_argument("--output", type=str, default='../weights.hpp')
    args = parser.parse_args()

    generate_hpp_code_using_template(args.h5_file, args.template_file, args.output)

#%%
model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=(7, 7)),
    tf.keras.layers.Dense(30, activation='relu'),
    tf.keras.layers.Dense(10)
    ])

model.summary()
#%%