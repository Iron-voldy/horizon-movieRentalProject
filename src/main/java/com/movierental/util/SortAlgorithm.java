package com.movierental.util;

import java.util.List;
import java.util.Comparator;

/**
 * Utility class providing sorting algorithms for the recommendation system
 */
public class SortAlgorithm {

    /**
     * Generic bubble sort method for any list with a comparator
     *
     * @param <T> the type of elements in the list
     * @param list the list to be sorted
     * @param comparator the comparator used for comparison
     */
    public static <T> void bubbleSort(List<T> list, Comparator<? super T> comparator) {
        int n = list.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;

            for (int j = 0; j < n - i - 1; j++) {
                if (comparator.compare(list.get(j), list.get(j + 1)) > 0) {
                    // Swap elements
                    T temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                    swapped = true;
                }
            }

            // If no swapping occurred in this pass, list is already sorted
            if (!swapped) {
                break;
            }
        }
    }

    /**
     * Bubble sort method for lists of Comparable objects with natural ordering
     *
     * @param <T> the type of elements in the list (must implement Comparable)
     * @param list the list to be sorted
     */
    public static <T extends Comparable<T>> void bubbleSort(List<T> list) {
        int n = list.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;

            for (int j = 0; j < n - i - 1; j++) {
                if (list.get(j).compareTo(list.get(j + 1)) > 0) {
                    // Swap elements
                    T temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                    swapped = true;
                }
            }

            // If no swapping occurred in this pass, list is already sorted
            if (!swapped) {
                break;
            }
        }
    }

    /**
     * Bubble sort method for sorting movies by rating in descending order
     *
     * @param <T> the type of elements in the list
     * @param list the list to be sorted
     * @param ratingExtractor function to extract rating from an element
     */
    public static <T> void bubbleSortByRatingDescending(List<T> list, RatingExtractor<T> ratingExtractor) {
        int n = list.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;

            for (int j = 0; j < n - i - 1; j++) {
                if (ratingExtractor.getRating(list.get(j)) < ratingExtractor.getRating(list.get(j + 1))) {
                    // Swap elements
                    T temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                    swapped = true;
                }
            }

            // If no swapping occurred in this pass, list is already sorted
            if (!swapped) {
                break;
            }
        }
    }

    /**
     * Functional interface to extract rating from an element
     */
    @FunctionalInterface
    public interface RatingExtractor<T> {
        double getRating(T element);
    }
}