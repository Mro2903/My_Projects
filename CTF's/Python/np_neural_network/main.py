import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import pickle


class NeuralNetwork:
    def __init__(self):
        self.w1 = np.random.randn(10, 784)
        self.b1 = np.random.randn(10, 1)
        self.w2 = np.random.randn(10, 10)
        self.b2 = np.random.randn(10, 1)

    @staticmethod
    def __ReLU(z):
        return np.maximum(0, z)

    @staticmethod
    def __deriv_ReLU(z):
        return z > 0

    @staticmethod
    def __softmax(z):
        return np.exp(z) / sum(np.exp(z))

    def __forward(self, x):
        z1 = np.dot(self.w1, x) + self.b1
        a1 = self.__ReLU(z1)
        z2 = np.dot(self.w2, a1) + self.b2
        a2 = self.__softmax(z2)
        return z1, a1, z2, a2

    @staticmethod
    def __hat(y):
        y_hat = np.zeros((y.size, y.max() + 1))
        y_hat[np.arange(y.size), y] = 1
        return y_hat.T

    def __backward(self, x, y, z1, a1, a2):
        y_hat = self.__hat(y)
        dz2 = a2 - y_hat
        dw2 = 1 / y.size * np.dot(dz2, a1.T)
        db2 = 1 / y.size * np.sum(dz2)
        dz1 = np.dot(self.w2.T, dz2) * self.__deriv_ReLU(z1)
        dw1 = 1 / y.size * np.dot(dz1, x.T)
        db1 = 1 / y.size * np.sum(dz1)
        return dw1, db1, dw2, db2

    def __update(self, dw1, db1, dw2, db2, alpha):
        self.w1 -= alpha * dw1
        self.b1 -= alpha * db1
        self.w2 -= alpha * dw2
        self.b2 -= alpha * db2

    @staticmethod
    def __predict(a2):
        return np.argmax(a2, axis=0)

    @staticmethod
    def __accuracy(predicted, actual):
        return np.sum(predicted == actual) / actual.size

    def train(self, x, y, iterations, alpha):
        for i in range(iterations):
            z1, a1, z2, a2 = self.__forward(x)
            dw1, db1, dw2, db2 = self.__backward(x, y, z1, a1, a2)
            self.__update(dw1, db1, dw2, db2, alpha)
            if i % 100 == 0:
                predicted = self.__predict(a2)
                acc = self.__accuracy(predicted, y)
                print(f'Iteration {i}: {acc}')

    def __make_prediction(self, x):
        _, _, _, a2 = self.__forward(x)
        return self.__predict(a2)

    def test(self, x, y):
        predicted = self.__make_prediction(x)
        print("Prediction: ", predicted)
        print("Label: ", y)

        current_image = x.reshape((28, 28)) * 255
        plt.gray()
        plt.imshow(current_image, interpolation='nearest')
        plt.show()


def main():
    data = pd.read_csv('train.csv')
    data = np.array(data)
    m, n = data.shape
    np.random.shuffle(data)

    data_dev = data[0:1000].T
    y_dev = data_dev[0]
    x_dev = data_dev[1:n]
    x_dev = x_dev / 255.

    data_train = data[1000:m].T
    y_train = data_train[0]
    x_train = data_train[1:n]
    x_train = x_train / 255.
    _, m_train = x_train.shape

    nn = NeuralNetwork()
    nn.train(x_train, y_train, 10000, 0.1)

    with open('model.pkl', 'wb') as file:
        pickle.dump(nn, file)

    for i in range(10):
        input("Press Enter to continue...")
        nn.test(x_dev[:, i, None], y_dev[i])


if __name__ == '__main__':
    main()
