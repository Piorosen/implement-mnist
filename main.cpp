#include <array>
#include <vector>
#include <iostream>
#include <algorithm>

// Function to flatten a 2D array into a 1D array
template<typename T, size_t N, size_t M>
std::array<T, N* M> flatten(const std::array<std::array<T, M>, N>& arr2D) {
    std::array<T, N* M> flattened;
    size_t index = 0;
    for (const auto& row : arr2D) {
        for (const auto& element : row) {
            flattened[index++] = element;
        }
    }
    return flattened;
}

template<typename T, size_t I, size_t O>
std::array<T, O> dense(const std::array<std::array<T, I>, O>& weights,
    const std::array<T, O>& biases,
    const std::array<T, I>& input,
    const bool use_relu = false) {
    std::array<T, O> output {};

    for (size_t i = 0; i < weights.size(); ++i) {
        double weightedSum = biases[i];
        for (size_t j = 0; j < weights[i].size(); ++j) {
            weightedSum += weights[i][j] * input[j];
        }
        if (use_relu) {
            output[i] = std::max(0.0, weightedSum); // ReLU activation
        }
        else {
            output[i] = weightedSum;
        }
    }
    return output;
}

template<typename T, size_t I, size_t O>
std::array<std::array<T, O>, O> resize(const std::array<std::array<T, I>, I>& input) {
    int rows = input.size();
    int cols = input[0].size();
    std::array<std::array<T, O>, O> output{};
    int resizeRatio = rows / output.size();
    for (int i = 0; i < output.size(); ++i) {
        for (int j = 0; j < output[0].size(); ++j) {
            float sum = 0;
            for (int k = 0; k < resizeRatio; ++k) {
                for (int l = 0; l < resizeRatio; ++l) {
                    sum += input[i * resizeRatio + k][j * resizeRatio + l];
                }
            }
            output[i][j] = sum / (resizeRatio * resizeRatio);
        }
    }
    return output;
}

int main() {
    int testCase;
    std::cin >> testCase;

    for (int i = 0; i < testCase; i++) {
        std::array<std::array<float, 28>, 28> input;
        
        for (int y = 0; y < 28; y++) {
            for (int x = 0; x < 28; x++) {
                std::cin >> input[y][x];
            }
        }
        
#include "template.hpp"

        auto sized = resize<float, 28, 7>(input);
        auto flat = flatten(sized);
        auto dense1 = dense(dense1_weight, dense1_bias, flat, true);
        auto dense2 = dense(dense2_weight, dense2_bias, dense1, false);
        int max_idx = std::max_element(dense2.begin(), dense2.end()) - dense2.begin();
        std::cout << "MAX : " << max_idx << "\n";
        for (int i = 0; i < dense2.size(); i++) {
            std::cout << i << " : " << dense2[i] << '\n';
        }
    }
}
