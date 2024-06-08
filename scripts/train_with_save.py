import tensorflow as tf
import tensorflow_datasets as tfds
import argparse

tf.random.set_seed(142)

def normalize_img(image, label):
  """Normalizes images: `uint8` -> `float32`."""
  return tf.cast(image, tf.float32) / 255., label

def reshape_image(image, label):
    return tf.image.resize(image, (7, 7)), label
    # return image, label

def load_from_tfds():
    return tfds.load(
        'mnist',
        split=['train', 'test'],
        shuffle_files=True,
        as_supervised=True,
        with_info=True,
    )

def train(save_weight: str, epochs: int):
    (ds_train, ds_test), ds_info = load_from_tfds()
    ds_train = ds_train.map(
        normalize_img, num_parallel_calls=tf.data.AUTOTUNE)

    ds_train = ds_train.map(reshape_image)
    ds_train = ds_train.cache()
    ds_train = ds_train.shuffle(ds_info.splits['train'].num_examples)
    ds_train = ds_train.batch(128)
    ds_train = ds_train.prefetch(tf.data.AUTOTUNE)
    ds_test = ds_test.map(
        normalize_img, num_parallel_calls=tf.data.AUTOTUNE)
    ds_test = ds_test.map(reshape_image)
    ds_test = ds_test.batch(128)
    ds_test = ds_test.cache()
    ds_test = ds_test.prefetch(tf.data.AUTOTUNE)

    model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=(7, 7)),
    tf.keras.layers.Dense(30, activation='relu'),
    tf.keras.layers.Dense(10)
    ])

    model.compile(
        optimizer=tf.keras.optimizers.Adam(0.001),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=[tf.keras.metrics.SparseCategoricalAccuracy()],
        )

    model.fit(
        ds_train,
        epochs=epochs,
        validation_data=ds_test,
    )

    model.save_weights(save_weight)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate')

    parser.add_argument("--save_weight", type=str, default='./model_weight.h5')
    parser.add_argument("--epoch", type=int, default=1000)
    args = parser.parse_args()

    train(args.save_weight, args.epoch)
