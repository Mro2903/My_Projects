cmake_minimum_required(VERSION 3.29)
project(DiningPhilosophersMutex C)

set(CMAKE_C_STANDARD 99)

add_executable(DiningPhilosophersMutex main.c
        SinglePhilosopher.c)
