package com.stjomd.railway.generator.util;

import com.stjomd.railway.exception.CSVException;
import org.supercsv.io.CsvMapReader;
import org.supercsv.io.ICsvMapReader;
import org.supercsv.prefs.CsvPreference;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Map;

/**
 * Provides methods for working with CSV files.
 */
public interface CSVHandler {

    /**
     * Iterates over rows in a CSV file and performs an action on each iteration.
     *
     * @param fileName the name of the file (with the extension) to be read.
     * @param operator a function that accepts cells (an array of String) and is called on each iteration.
     * @return the amount of rows iterated over.
     */
    static int forEachRowIn(String fileName, CSVRowOperator operator) {
        BufferedReader reader = openOEBBFile(fileName);
        ICsvMapReader csvReader = new CsvMapReader(reader, CsvPreference.STANDARD_PREFERENCE);
        try {
            final String[] header = csvReader.getHeader(true);
            Map<String, String> line;
            while ((line = csvReader.read(header)) != null) {
                operator.operator(line);
            }
            csvReader.close();
        } catch (IOException e) {
            throw new CSVException("Error while iterating over file", e);
        }
        return csvReader.getRowNumber() - 1;
    }

    /**
     * Opens a file and returns a buffered reader for it.
     *
     * @param fileName the name of the file in the Resources folder under <code>static/oebb-data/</code> to be opened.
     * @return the BufferedReader of the file.
     */
    private static BufferedReader openOEBBFile(String fileName) {
        URL url = CSVHandler.class.getResource("/static/oebb-data/" + fileName);
        if (url == null)
            throw new CSVException("Couldn't locate file: /static/oebb-data/" + fileName);
        try {
            return new BufferedReader(new InputStreamReader(url.openStream()));
        } catch (IOException e) {
            throw new CSVException("Couldn't instantiate a BufferedReader", e);
        }
    }

}
