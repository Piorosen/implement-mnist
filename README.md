# MNIST for Pure C++ from H5 model on Keras
<pre>
 ______  __       __  _______   __        ________  __       __  ________  __    __  ________      
/      |/  \     /  |/       \ /  |      /        |/  \     /  |/        |/  \  /  |/        |     
$$$$$$/ $$  \   /$$ |$$$$$$$  |$$ |      $$$$$$$$/ $$  \   /$$ |$$$$$$$$/ $$  \ $$ |$$$$$$$$/      
  $$ |  $$$  \ /$$$ |$$ |__$$ |$$ |      $$ |__    $$$  \ /$$$ |$$ |__    $$$  \$$ |   $$ |        
  $$ |  $$$$  /$$$$ |$$    $$/ $$ |      $$    |   $$$$  /$$$$ |$$    |   $$$$  $$ |   $$ |        
  $$ |  $$ $$ $$/$$ |$$$$$$$/  $$ |      $$$$$/    $$ $$ $$/$$ |$$$$$/    $$ $$ $$ |   $$ |        
 _$$ |_ $$ |$$$/ $$ |$$ |      $$ |_____ $$ |_____ $$ |$$$/ $$ |$$ |_____ $$ |$$$$ |   $$ |        
/ $$   |$$ | $/  $$ |$$ |      $$       |$$       |$$ | $/  $$ |$$       |$$ | $$$ |   $$ |        
$$$$$$/ $$/      $$/ $$/       $$$$$$$$/ $$$$$$$$/ $$/      $$/ $$$$$$$$/ $$/   $$/    $$/         

 /  \     /  |/  \  /  |/      | /      \ /        |
 $$  \   /$$ |$$  \ $$ |$$$$$$/ /$$$$$$  |$$$$$$$$/ 
 $$$  \ /$$$ |$$$  \$$ |  $$ |  $$ \__$$/    $$ |   
 $$$$  /$$$$ |$$$$  $$ |  $$ |  $$      \    $$ |   
 $$ $$ $$/$$ |$$ $$ $$ |  $$ |   $$$$$$  |   $$ |   
 $$ |$$$/ $$ |$$ |$$$$ | _$$ |_ /  \__$$ |   $$ |   
 $$ | $/  $$ |$$ | $$$ |/ $$   |$$    $$/    $$ |   
 $$/      $$/ $$/   $$/ $$$$$$/  $$$$$$/     $$/                                
</pre>

# How to build and Test?

```sh
# if you have docker or other container.
$ git clone https://github.com/Piorosen/implement-mnist.git
$ cd implement-mnist && ./scripts/run.sh --all
```

# How do run it?

#### Docker Build Time: about 40m ~ 60m

```sh
$ git clone https://github.com/Piorosen/implement-mnist.git
# Follow below code, if you want to without building image.
$ docker pull ghcr.io/piorosen/implement-mnist:1.0.0
# following below code, if you want to build by your hand 
$ docker build -t ghcr.io/piorosen/implement-mnist:1.0.0 .

$ docker run --rm -it ghcr.io/piorosen/implement-mnist:1.0.0 /bin/ash
$ (container)$ ./mnist # you can see a list of samples in containers.
$ (container)$ ./mnist file 4-0059.txt # need to select file in list.
# Output 4
$ (container)$ cat ./tests/4-0059.txt # if you want to see data.
```

# How do work?

The repository is structured to dynamically generate C++ code to respond to changing weight files.

Therefore, if you try to build C++ without the prerequisites being satisfied, you will get an error in `main.cpp` on line 7 because `#include ‘weights.hpp’` is missing

Therefore, we need to first run `./scripts/model_reproducibility.dockerfile`, a docker file that trains the deep learning model and converts it to C++ code, and import `weight.hpp` separately with `docker cp $container_id:/sources/output/weights.hpp .`.

After that, you can build the `mnist`.

If you are not familiar with `docker`, `Linux`, or `CMakeLists`, you can run `./resources/mnist.cpp`.

The parameter to run is `./mnist file ‘${something file}’`, or you can enter the image directly into the standard input pipeline with `./mnist input`.

## Output

Description|Image
:---:|:---:
h5 keras to cpp|![](/resources/img2.png)
result of execute|![](/resources/img4.png)

## AI Model

```
 Input (1 x 28 x 28) -> 
 Average Pooling (1 x 7 x 7) ->
 Flatten (1 x 49) ->
 Dense (1 x 49 x 30) ->
 ReLu (Activate) ->
 Dense (1 x 30 x 10) ->
 Output (1 x 10) 
```

## For Reproducibility

To ensure the reproducibility of the software, I experimented with the random seed value set to 142 in tensorflow. Additionally, when running through docker (same as run.sh --all), it is automatically set to 142. If you reading this does not need reproducibility, please change the argument value in `./scripts/model_reproducibility.dockerfile`. 

# [Algorithm Competition](http://ascode.org/problem.php?id=1450)

## Example of Input

input is too long text. [[HERE]](/resources/example_input.txt)
![](/resources/img1.png)

### Input Description

```
1. read first line, test case (< 100)
2. read next line, size 28 x 28 array all of them is float and the range of [0, 1].
3. repeat 2.
```

## Example of Output

`5`

### Output Description

```
Predict number from input data.
```

## Limit in Judge System

```
1. Don't install other library.
2. The length of source code that can be written is limited. (about 30kb)
```
